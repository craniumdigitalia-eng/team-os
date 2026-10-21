---
name: dev-error-handling
description: "Padrões de resiliência e error handling para software complexo — retry, circuit breaker, timeouts, error boundaries, logging estruturado e observabilidade (métricas RED, traces OpenTelemetry, alertas por sintoma)."
version: "1.2"
updated: "2026-10-20"
---

# Error Handling & Resilience — Software Complexo

## Princípio fundamental

**Falha é inevitável. Design para falha, não apenas para sucesso.**

Todo código que interage com: banco de dados, APIs externas, filesystem, serviços de terceiros — deve ter error handling explícito.

## Retry com Exponential Backoff

```typescript
async function withRetry<T>(
  fn: () => Promise<T>,
  options: { maxAttempts?: number; baseDelay?: number } = {}
): Promise<T> {
  const { maxAttempts = 3, baseDelay = 300 } = options

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn()
    } catch (error) {
      if (attempt === maxAttempts) throw error
      // Não fazer retry em erros 4xx (erro do cliente, não transitório)
      if (error.status >= 400 && error.status < 500) throw error

      const delay = baseDelay * Math.pow(2, attempt - 1)  // 300ms, 600ms, 1200ms
      const jitter = Math.random() * 100
      await sleep(delay + jitter)
    }
  }
}

// Uso
const user = await withRetry(() => externalApi.getUser(id), { maxAttempts: 3 })
```

## Timeout Explícito

```typescript
async function withTimeout<T>(promise: Promise<T>, ms: number): Promise<T> {
  const timeout = new Promise<never>((_, reject) =>
    setTimeout(() => reject(new Error(`Timeout after ${ms}ms`)), ms)
  )
  return Promise.race([promise, timeout])
}

// Uso — nunca deixar chamada externa sem timeout
const result = await withTimeout(
  externalApi.processPayment(data),
  5000  // 5 segundos máximo
)
```

## Circuit Breaker

Evita cascata de falhas — para de tentar quando serviço está claramente down.

```typescript
class CircuitBreaker {
  private failures = 0
  private lastFailure?: Date
  private state: 'CLOSED' | 'OPEN' | 'HALF_OPEN' = 'CLOSED'

  constructor(
    private readonly threshold = 5,     // abrir após 5 falhas
    private readonly timeout = 60000    // tentar novamente após 60s
  ) {}

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === 'OPEN') {
      const elapsed = Date.now() - this.lastFailure!.getTime()
      if (elapsed < this.timeout) {
        throw new Error('Circuit breaker is OPEN — service unavailable')
      }
      this.state = 'HALF_OPEN'
    }

    try {
      const result = await fn()
      this.onSuccess()
      return result
    } catch (error) {
      this.onFailure()
      throw error
    }
  }

  private onSuccess() { this.failures = 0; this.state = 'CLOSED' }
  private onFailure() {
    this.failures++
    this.lastFailure = new Date()
    if (this.failures >= this.threshold) this.state = 'OPEN'
  }
}
```

## Error Classes Tipadas

```typescript
// Base
export class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
    public readonly details?: unknown
  ) {
    super(message)
    this.name = this.constructor.name
  }
}

// Específicos
export class ValidationError extends AppError {
  constructor(details: { field: string; message: string }[]) {
    super('Validation failed', 'VALIDATION_ERROR', 400, details)
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found`, 'NOT_FOUND', 404)
  }
}

export class ExternalServiceError extends AppError {
  constructor(service: string, cause: Error) {
    super(`${service} failed`, 'EXTERNAL_SERVICE_ERROR', 502)
    this.cause = cause
  }
}
```

## Error Boundary em Express

```typescript
// Handler global — sempre o último middleware
app.use((error: Error, req: Request, res: Response, next: NextFunction) => {
  // Logar com contexto — requestId sempre presente para rastreabilidade
  logger.error({
    err: error,
    requestId: req.requestId,  // gerado pelo middleware de entrada (dev-api-design)
    path: req.path,
    method: req.method,
    userId: req.user?.id,
  }, 'Unhandled error')

  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      error: {
        code: error.code,
        message: error.message,
        details: error.details,
        requestId: req.requestId,  // sempre incluir na resposta
      }
    })
  }

  // Erro desconhecido — não vazar detalhes internos
  return res.status(500).json({
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred',
      requestId: req.requestId,
    }
  })
})
```

## Logging Estruturado

```typescript
import pino from 'pino'

const logger = pino({
  level: process.env.LOG_LEVEL ?? 'info',
  formatters: { level: (label) => ({ level: label }) },
})

// ✅ Correto — requestId sempre presente, contexto rico, sem dados sensíveis
logger.error({
  requestId: req.requestId,  // rastreabilidade end-to-end (ver dev-api-design)
  err: error,
  userId: user.id,
  action: 'payment_process',
  orderId: order.id,
}, 'Payment processing failed')

// ❌ Errado — sem requestId, sem contexto, pode vazar dados sensíveis
console.error('Error:', error)
```

## Graceful Degradation

Quando serviço dependente falha, degradar graciosamente em vez de falhar tudo:

```typescript
async function getUserWithPreferences(userId: string, requestId: string) {
  const user = await db.user.findUnique({ where: { id: userId } })  // crítico
  if (!user) throw new NotFoundError('User')

  // Feature não-crítica — falha silenciosa com fallback
  let preferences = DEFAULT_PREFERENCES
  try {
    preferences = await preferencesService.get(userId)
  } catch (error) {
    logger.warn({
      requestId,      // manter rastreabilidade mesmo no fallback
      userId,
      err: error.message,
    }, 'Failed to load preferences, using defaults')
  }

  return { ...user, preferences }
}
```

## Observabilidade

Código que não se observa não se opera: o primeiro bug relatado vira arqueologia em vez de consulta. Instrumente junto com a feature, como se escreve teste — e comece por 2–4 perguntas que quem estiver de plantão vai fazer ("quantos pagamentos falharam na última hora e por quê?").

**Logs estruturados com correlação.** JSON com campos fixos (`level`, `msg`, `requestId`, `traceId`, `route`, `durationMs`, `errCode`), nunca string concatenada. O `requestId`/`traceId` nasce na entrada e atravessa filas, jobs e chamadas a outros serviços (header `traceparent`), para seguir uma requisição de ponta a ponta. Nada de senha, token ou dado pessoal em claro.

**Métricas RED** em todo endpoint e toda dependência externa:

| Sinal | O que medir | Forma |
|---|---|---|
| **R**ate | requisições por segundo | contador |
| **E**rrors | proporção de falhas (5xx, timeout, exceção) | contador por `status_class` |
| **D**uration | latência | histograma — leia p50/p95/p99, nunca a média |

Rótulos só de conjuntos pequenos e fixos (`route="/api/tasks/:id"`, `status_class="5xx"`, `provider="stripe"`). **Nunca** `userId`, e-mail, URL completa ou texto de erro como rótulo — cada combinação vira uma série e a conta explode; isso vai para log e trace. Para recursos (fila, pool, host): utilização, saturação e erros.

**Traces com OpenTelemetry (básico).** SDK do OpenTelemetry com auto-instrumentação de HTTP e banco; um span por operação relevante (chamada externa, query, job), com atributos de baixo risco (`route`, `db.operation`, `provider`) e o erro registrado no span. O exportador (OTLP) aponta para o backend escolhido — o código não depende do fornecedor. Métricas pelo mesmo SDK quando possível.

**Alertas por sintoma do usuário, não por causa.**

| Alerta (acorda alguém) | Painel (não acorda) |
|---|---|
| taxa de erro > 1% por 5 min | CPU em 85% |
| p99 > 2 s | um pod reiniciou |
| fila parada há > 10 min | disco em 70% |

Todo alerta: acionável (se a resposta é "ignora, se resolve sozinho", apague), com limiar e janela justificados por SLO ou histórico, com runbook de 3 linhas (o que significa, primeira consulta, a quem escalar) e disparado uma vez em staging para provar que chega. Duas severidades só: **urgente** (usuário afetado agora) e **ticket** (degradação, resolver na semana).

**Prova de que funciona:** provoque uma falha em staging e encontre a causa só pela telemetria, sem abrir o código. Se não deu, falta instrumentação. A depuração em si segue `/dev-debugging`.

## Regras absolutas

- Nunca `catch (e) {}` vazio — sempre logar ou relançar com contexto
- Nunca expor stack traces em respostas de API
- Sempre timeout em chamadas a serviços externos
- Retry apenas em erros transitórios (5xx, network) — nunca em 4xx
- **`requestId` em todos os logs e respostas de erro** — rastreabilidade end-to-end
- Erros devem ter contexto suficiente para debug sem reprodução

---

Seção Observabilidade adaptada de addyosmani/agent-skills → observability-and-instrumentation (MIT) — 2026-10-20; texto próprio em pt-BR.
