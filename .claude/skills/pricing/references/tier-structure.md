# Estrutura de planos e empacotamento

## Conteúdo
- Quantos planos?
- Bom-Melhor-Ótimo
- Estratégias de diferenciação
- Exemplo de estrutura
- Empacotamento por persona (identificar personas de preço, empacotamento por persona)
- Freemium vs. teste grátis (quando usar cada um, abordagens híbridas)
- Preço enterprise (quando ter preço sob medida, elementos, estratégias)

## Quantos planos?

**2 planos:** escolha simples e clara
- Funciona para: divisão clara PME vs. enterprise
- Risco: deixar dinheiro na mesa

**3 planos:** o padrão do mercado
- Bom = porta de entrada
- Melhor = recomendado (ancorado no Ótimo)
- Ótimo = clientes de alto valor

**4+ planos:** mais granularidade
- Funciona para: grande variação de porte de cliente
- Risco: paralisia de escolha, complexidade

---

## Bom-Melhor-Ótimo

**Bom (entrada):**
- Propósito: tirar barreiras de entrada
- Inclui: funcionalidades centrais, uso limitado
- Preço: baixo, acessível
- Para: times pequenos, experimentar antes de comprar

**Melhor (recomendado):**
- Propósito: onde a maioria dos clientes cai
- Inclui: funcionalidades completas, limites razoáveis
- Preço: o seu preço-"âncora"
- Para: times em crescimento, usuários sérios

**Ótimo (premium):**
- Propósito: capturar clientes de alto valor
- Inclui: tudo, recursos avançados, limites maiores
- Preço: premium (em geral 2–3x o "Melhor")
- Para: times grandes, usuários avançados, enterprise

---

## Estratégias de diferenciação

**Por funcionalidade:**
- Funcionalidades básicas em todos os planos
- Avançadas nos planos mais altos
- Funciona quando as funcionalidades têm diferenças claras de valor

**Por limite de uso:**
- Mesmas funcionalidades, limites diferentes
- Mais usuários, armazenamento, chamadas de API nos planos altos
- Funciona quando o valor cresce com o uso

**Por nível de suporte:**
- E-mail → prioritário → sucesso dedicado
- Funciona para produtos com implantação complexa

**Por acesso e personalização:**
- API, SSO, marca própria
- Funciona para diferenciar enterprise

---

## Exemplo de estrutura

```
┌────────────────┬─────────────────┬─────────────────┬─────────────────┐
│                │ Starter         │ Pro             │ Business        │
│                │ 29/mês          │ 79/mês          │ 199/mês         │
├────────────────┼─────────────────┼─────────────────┼─────────────────┤
│ Usuários       │ Até 5           │ Até 20          │ Ilimitado       │
│ Projetos       │ 10              │ Ilimitado       │ Ilimitado       │
│ Armazenamento  │ 5 GB            │ 50 GB           │ 500 GB          │
│ Integrações    │ 3               │ 10              │ Ilimitado       │
│ Analytics      │ Básico          │ Avançado        │ Sob medida      │
│ Suporte        │ E-mail          │ Prioritário     │ Dedicado        │
│ Acesso à API   │ ✗               │ ✓               │ ✓               │
│ SSO            │ ✗               │ ✗               │ ✓               │
│ Logs de auditoria │ ✗            │ ✗               │ ✓               │
└────────────────┴─────────────────┴─────────────────┴─────────────────┘
```

---

## Empacotamento por persona

### Identificar personas de preço

Clientes diferentes têm diferentes:
- Disposição a pagar
- Necessidades de funcionalidade
- Processos de compra
- Percepção de valor

**Segmente por:**
- Porte (autônomo → PME → enterprise)
- Caso de uso (marketing vs. vendas vs. suporte)
- Maturidade (iniciante → usuário avançado)
- Setor (normas de orçamento diferentes)

### Empacotamento por persona

**Passo 1: defina as personas**

| Persona | Porte | Necessidades | Disposição a pagar | Exemplo |
|---------|-------|--------------|--------------------|---------|
| Autônomo | 1 pessoa | Funcionalidades básicas | Baixa | 19/mês |
| Time pequeno | 2–10 | Colaboração | Média | 49/mês |
| Empresa em crescimento | 10–50 | Escala, integrações | Maior | 149/mês |
| Enterprise | 50+ | Segurança, suporte | Alta | Sob medida |

**Passo 2: mapeie funcionalidades por persona**

| Funcionalidade | Autônomo | Time pequeno | Em crescimento | Enterprise |
|----------------|----------|--------------|----------------|------------|
| Funcionalidades centrais | ✓ | ✓ | ✓ | ✓ |
| Colaboração | — | ✓ | ✓ | ✓ |
| Integrações | — | Limitadas | Completas | Completas |
| Acesso à API | — | — | ✓ | ✓ |
| SSO/SAML | — | — | — | ✓ |
| Logs de auditoria | — | — | — | ✓ |
| Contrato sob medida | — | — | — | ✓ |

**Passo 3: preço conforme o valor de cada persona**
- Pesquise a disposição a pagar por segmento
- Defina preços que capturem valor sem travar a adoção
- Considere landing pages por segmento

---

## Freemium vs. teste grátis

### Quando usar freemium

**Freemium funciona quando:**
- O produto tem efeito viral/de rede
- Usuários grátis geram valor (conteúdo, dados, indicações)
- Mercado grande, em que a % de conversão gera volume
- Custo marginal baixo para atender usuário grátis
- Limites claros de funcionalidade/uso que disparam o upgrade

**Riscos do freemium:**
- Usuário grátis pode nunca converter
- Desvaloriza a percepção do produto
- Custo de suporte de quem não paga
- Mais difícil subir o preço depois

### Quando usar teste grátis

**Teste grátis funciona quando:**
- O produto precisa de tempo para mostrar valor
- Exige investimento de onboarding/configuração
- B2B com comitê de compra
- Preços mais altos
- O produto "gruda" depois de configurado

**Boas práticas do teste:**
- 7–14 dias para produtos simples
- 14–30 dias para produtos complexos
- Acesso completo (sem limitar funcionalidades)
- Contagem regressiva e lembretes claros
- Pesar cartão opcional vs. obrigatório

**Cartão de crédito na entrada (números de referência do mercado norte-americano de SaaS; confirme com seus dados):**
- Conversão teste→pago maior (40–50% vs. 15–25%)
- Menos testes iniciados
- Leads mais qualificados

### Abordagens híbridas

**Freemium + teste:**
- Plano grátis com funcionalidades limitadas
- Teste das funcionalidades premium
- Exemplo: Zoom (grátis com 40 min, teste do Pro)

**Teste reverso:**
- Começa com acesso completo
- Depois do teste, cai para o plano grátis
- Exemplo: o usuário vê o valor premium e convive com os limites até estar pronto

---

## Preço enterprise

### Quando ter preço sob medida

Coloque "Fale com vendas" quando:
- O tamanho do negócio passa de ~10 mil/ano
- O cliente precisa de contrato sob medida
- Há implantação/onboarding
- Há exigências de segurança/compliance
- Há processo de compras (procurement)

### Elementos do plano enterprise

**O mínimo esperado:**
- SSO/SAML
- Logs de auditoria
- Controles de administrador
- SLA de disponibilidade
- Certificações de segurança

**Diferenciais:**
- Suporte/sucesso dedicado
- Onboarding sob medida
- Treinamentos
- Integrações sob medida
- Prioridade no roadmap

### Estratégias de preço enterprise

**Por assento em escala:**
- Desconto por volume para times grandes
- Exemplo: 15/usuário (padrão) → 10/usuário (100+)

**Taxa de plataforma + uso:**
- Taxa base de acesso
- Uso cobrado acima de limiares
- Exemplo: 500/mês de base + 0,01 por chamada de API

**Contratos baseados em valor:**
- Preço atrelado à receita/resultado do cliente
- Exemplo: % das transações, participação na receita
