# Métodos de pesquisa de preço

## Conteúdo
- Van Westendorp (as quatro perguntas, como analisar, dicas, exemplo de saída)
- MaxDiff (como funciona, exemplo de pergunta, leitura, uso no empacotamento)
- Pesquisas de disposição a pagar
- Correlação uso × valor

## Van Westendorp (Price Sensitivity Meter)

A pesquisa Van Westendorp mapeia a faixa de preço que o público **percebe** como aceitável. Ela mede percepção, não demanda.

### As quatro perguntas

Pergunte a cada respondente:
1. "A partir de que preço você acharia [produto] tão caro que nem consideraria comprar?" (Caro demais)
2. "A partir de que preço você acharia [produto] tão barato que duvidaria da qualidade?" (Barato demais)
3. "A partir de que preço você acharia [produto] caro, mas ainda consideraria?" (Caro)
4. "A partir de que preço você acharia [produto] uma pechincha — ótima compra pelo que custa?" (Barato / bom negócio)

### Como analisar

1. **Valide as respostas antes de plotar.** Tudo na mesma moeda, no mesmo período de cobrança (mensal ou anual) e para a mesma descrição de produto. Sinalize resposta faltando, não numérica ou com ordem inconsistente — a ordem esperada é `barato demais ≤ barato ≤ caro ≤ caro demais`. Registre quantas respostas foram excluídas e por quê; nunca "corrija" uma resposta em silêncio.
2. **Monte as quatro curvas** com o preço candidato no eixo x e a fração de respondentes no eixo y. As duas curvas de "barato" **caem** à medida que o preço sobe; as duas de "caro" **sobem**. Para cada preço candidato `p`:

   | Curva | Fração a plotar | Direção |
   |-------|-----------------|---------|
   | Barato demais | respondentes cujo limite "barato demais" é **≥ `p`** | decrescente |
   | Barato / bom negócio | respondentes cujo limite "barato" é **≥ `p`** | decrescente |
   | Caro | respondentes cujo limite "caro" é **≤ `p`** | crescente |
   | Caro demais | respondentes cujo limite "caro demais" é **≤ `p`** | crescente |

   Para os pontos marginais use também as **curvas invertidas**: **"não barato" = 1 − "barato"** (crescente) e **"não caro" = 1 − "caro"** (decrescente).

   **Erro clássico:** aplicar uma distribuição acumulada crescente às quatro perguntas. Isso inverte o sentido das curvas de "barato" e desloca todos os cruzamentos. A curva "barato demais" tem de cair conforme o preço sobe (ver o [exemplo da Sawtooth](https://sawtoothsoftware.com/resources/blog/posts/van-westendorp-pricing-sensitivity-meter)).

   **Regra de empate:** respostas exatamente iguais a `p` entram com a convenção da tabela (≥ nas curvas de barato, ≤ nas de caro). Use a mesma convenção em todas as curvas e registre-a no relatório. Quando o cruzamento cair entre dois preços da grade, interpole linearmente entre eles e diga que interpolou; se as curvas se tocam num intervalo, informe o intervalo, não um ponto.
3. **Encontre os cruzamentos:**
   - **Ponto de barateza marginal (PMC):** "barato demais" cruza **"não barato"**
   - **Ponto de carestia marginal (PME):** "caro demais" cruza **"não caro"**
   - **Optimal Price Point (OPP):** "barato demais" cruza "caro demais"
   - **Ponto de indiferença (IDP):** "barato" cruza "caro"

**Faixa de preço aceitável (percebida):** de PMC a PME.
**Preços candidatos a teste:** OPP e IDP ajudam a montar uma lista curta; **não** definem uma zona economicamente ótima.

As quatro perguntas medem percepção de preço, não probabilidade de compra. Antes de projetar demanda, use pesquisa adicional de intenção de compra (por exemplo a extensão Newton-Miller-Smith, declarando as premissas), um estudo de escolha (conjoint) ou teste real de preço. Compare receita, margem e retenção: um preço aceitável mais alto **não garante** demanda igual. Ver a [explicação da Sawtooth sobre o método e seus limites](https://sawtoothsoftware.com/resources/blog/posts/van-westendorp-pricing-sensitivity-meter).

### Dicas de pesquisa
- 100–300 respondentes para um resultado confiável (por segmento analisado)
- Segmente por persona (disposição a pagar muda)
- Use descrições realistas do produto
- Acrescente perguntas de intenção de compra se for falar de demanda

### Exemplo de saída

```
Sensibilidade a preço — resultado:
─────────────────────────────────
Respostas válidas:              212 de 230 (18 excluídas: ordem inconsistente)
Convenção de empate:            ≥ nas curvas de barato, ≤ nas de caro
Ponto de barateza marginal:     29/mês
Optimal Price Point:            49/mês
Ponto de indiferença:           59/mês
Ponto de carestia marginal:     79/mês

Preços candidatos a teste:      49 e 59/mês
Preço atual:                    39/mês
Variação:                       +25,6% e +51,3%
Impacto em demanda, conversão e churn: NÃO medido por estas quatro perguntas
Próximo passo: validar comportamento de compra e unit economics antes de implantar
```

---

## MaxDiff (Best-Worst Scaling)

O MaxDiff mostra quais funcionalidades o cliente mais valoriza e orienta o empacotamento.

### Como funciona

1. Liste 8–15 funcionalidades candidatas
2. Mostre conjuntos de 4–5 por vez
3. Pergunte: "Qual é a MAIS importante? Qual é a MENOS importante?"
4. Repita em vários conjuntos até comparar todas
5. A análise estatística gera um índice de importância

### Exemplo de pergunta

```
Qual funcionalidade é a MAIS importante para você?
Qual funcionalidade é a MENOS importante para você?

□ Projetos ilimitados
□ Marca própria
□ Suporte prioritário
□ Acesso à API
□ Analytics avançado
```

### Leitura

Funcionalidades ordenadas pelo índice de utilidade:
- Alta = obrigatória (entra no plano de entrada)
- Média = diferencial (separa os planos)
- Baixa = desejável (plano premium ou corte)

### Uso no empacotamento

| Faixa de utilidade | Decisão |
|--------------------|---------|
| 20% do topo | Em todos os planos (o mínimo esperado) |
| 20–50% | Diferencia os planos |
| 50–80% | Só nos planos mais altos |
| 20% de baixo | Cortar ou virar add-on premium |

---

## Pesquisas de disposição a pagar

**Pergunta direta (simples, mas enviesada):**
"Quanto você pagaria por [produto]?"

**Melhor: Gabor-Granger:**
"Você compraria [produto] por [X]?" (sim/não)
Varie o preço entre respondentes para montar uma curva de demanda declarada.

**Ainda melhor: análise conjunta (conjoint):**
Mostre pacotes com preços diferentes; o respondente escolhe o preferido. A análise revela a sensibilidade a preço por funcionalidade.

Todas medem intenção declarada. Antes de prometer impacto em receita, confirme com comportamento real (teste de preço com clientes novos).

---

## Correlação uso × valor

### 1. Instrumente o uso
- Frequência de uso por funcionalidade
- Métricas de volume (usuários, registros, chamadas de API)
- Métricas de resultado (receita gerada, tempo economizado)

### 2. Cruze com sucesso do cliente
- Que padrões de uso preveem retenção?
- Que padrões preveem expansão?
- Quem paga mais, e por quê?

### 3. Ache os limiares de valor
- Em que nível de uso o cliente "entende" o produto?
- Em que nível ele expande?
- Em que nível o preço deveria subir?

### Exemplo

```
Correlação uso × valor:
─────────────────────────────────
Segmento: clientes de LTV alto (>10 mil/ano)
Usuários ativos/mês (média): 15
Projetos (média): 8
Integrações (média): 4

Segmento: clientes que cancelaram
Usuários ativos/mês (média): 3
Projetos (média): 2
Integrações (média): 0

Leitura: valor acompanha adoção pelo time (usuários)
         e profundidade de uso (integrações)

Recomendação: cobrar por usuário, integrações nos planos mais altos
```
