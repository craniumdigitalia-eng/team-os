---
name: social-analytics
description: "Análise de métricas de redes sociais — múltiplo de outlier sobre a mediana da conta, retenção em 3 s, envios e follows por alcance, KPIs por objetivo, rubrica de perfil e relatório. Use ao analisar performance de campanhas sociais, montar relatório de métricas, comparar resultados com benchmarks ou decidir ajustes de conteúdo com base em dados."
version: "1.2"
updated: "2026-10-20"
---

# Social Analytics — Métricas e Relatórios

> Skill injetada no agente PULSE (social-publisher).

Núcleo comum a todas as plataformas; o que só vale para o Instagram está na seção **Instagram** no fim. Rubrica de perfil em `reference/perfil-rubrica.md`.

## 1. Primeiro: views brutas não são evidência

Uma conta grande com uma terça fraca ainda tem mais views que a melhor semana de uma conta pequena. Views dependem de quantos já seguem. Compare cada post **com a própria conta**:

**Múltiplo de outlier = views do post ÷ mediana de views da própria conta** (mediana dos últimos ~12 posts do mesmo formato).

| Múltiplo | Leitura |
|---|---|
| **> 3×** | Sinal — algo nesse post funcionou; investigue o quê |
| 1,5× – 3× | Bom dia; anote, não conclua |
| **< 1,5×** | Ruído — dia normal, não tire lição |

Use a **mediana**, não a média (um viral distorce a média). Ao comparar com outras contas, escolha contas **até 10× o tamanho** da conta analisada — fórmula que funciona com 2 milhões de seguidores muitas vezes funciona *porque* tem 2 milhões.

## 2. Métricas que separam acerto de sorte

| Métrica | Conta | O que diz |
|---|---|---|
| **Retenção em 3 s** | % que ainda assiste no segundo 3 | É a **nota do gancho**. Se topo e fundo diferem aqui, o problema é o gancho |
| **Envios / alcance** | compartilhamentos ÷ alcance | O sinal mais forte: alguém pôs o próprio nome no post |
| **Follows / alcance** | novos seguidores vindos do post ÷ alcance | Se o perfil converteu a atenção |
| **% de alcance fora dos seguidores** | alcance de não seguidores ÷ alcance | Se o post viajou de fato |
| Salvamentos / alcance | salvamentos ÷ alcance | Valor de consulta (carrossel, lista) |

Ordene por **múltiplo de outlier e envios/alcance**, não por views. Um post com 4 mil views e 90 envios venceu o de 60 mil com 11.

**Diagnóstico separado:** post **sem views** = problema de gancho (retenção em 3 s). Post **com views e sem follows** = problema de **perfil** (rode `reference/perfil-rubrica.md`), não de conteúdo.

## 3. Comparar topo × fundo

Separe os 5 melhores e os 5 piores por múltiplo de outlier e procure o que os distingue: fórmula de gancho (registrada no roteiro), retenção em 3 s, duração, formato, tema, horário. Conclusão só com diferença consistente entre os grupos — um post isolado não é padrão.

## 4. KPIs por objetivo de campanha

### Awareness
- **Reach:** Contas únicas alcançadas
- **Impressions:** Total de visualizações
- **Brand mentions:** Menções espontâneas

### Engagement
- **Engagement Rate:** (likes + comments + shares + saves) / reach × 100
- **Comments:** Qualidade (positivos/negativos) e volume
- **Saves:** Indicador forte de valor percebido
- **Shares:** Amplificação orgânica

### Conversão
- **Click-through Rate (CTR):** Cliques / impressões × 100
- **Link clicks:** Cliques no link da bio ou CTA
- **Story swipe-ups:** (se conta verificada)

### Vídeo específico
- **Video completion rate:** Viram até o fim / iniciaram × 100
- **Average watch time:** Segundos médios vistos
- **Replays:** Viram mais de uma vez

## 5. Benchmarks por plataforma

Referência genérica de mercado, sem fonte datada — use só como contexto. A comparação que decide é contra a mediana da própria conta (seção 1).

| Plataforma | ER bom | ER excelente | CTR médio |
|---|---|---|---|
| Instagram | 1-3% | > 5% | 0.22% |
| TikTok | 5-10% | > 15% | — |
| Facebook | 0.5-1% | > 3% | 0.9% |
| LinkedIn | 0.5-2% | > 5% | 0.4% |

## 6. Template de relatório

```markdown
## Relatório de Performance — [Campanha]
**Período:** [data início] → [data fim]
**Plataformas:** ...

---

### Métricas de Alcance
| Métrica | Resultado | vs Benchmark | Tendência |
|---|---|---|---|
| Reach | X | +/-X% | ↑↓→ |
| Impressions | X | — | — |

### Métricas de Engagement
| Métrica | Resultado | vs Benchmark |
|---|---|---|
| ER | X% | +/-X% |
| Saves | X | — |
| Comments | X | — |

### Outliers (mediana da conta: X views)
| Post | Múltiplo | Retenção 3 s | Envios/alcance | Follows/alcance | % fora dos seguidores | Fórmula do gancho |
|---|---|---|---|---|---|---|
| ... | 4,2× | 64% | 1,8% | 0,6% | 58% | Confissão de custo |

### Insights
1. **Melhor desempenho:** [post/formato/horário]
2. **Pior desempenho:** [post/formato/horário]
3. **Padrão identificado:** ...

### Recomendações para próxima campanha
1. ...
2. ...
```

## 7. Frequência de relatório
- **Semanal:** checagem rápida das métricas principais
- **Mensal:** Relatório completo com tendências
- **Por campanha:** Relatório fechado após fim da campanha

## Instagram

- Insights por post: views, alcance, interações, tempo assistido, salvamentos, compartilhamentos, follows e a fatia de alcance de não seguidores — print das telas de insights serve como fonte.
- O gráfico de retenção do Reel dá a retenção em 3 s; peça o dos 5 melhores e 5 piores.
- Conta pessoal não tem insights: conta profissional (criador/empresa) é pré-requisito (item da rubrica de perfil).

## Skills relacionadas
- Rubrica de perfil (12 itens, 100 pontos) → `reference/perfil-rubrica.md`.
- Referências de outras contas por múltiplo de outlier → `/social-apify-research`.
- UTMs, atribuição e GA4 → carregue a skill `/traffic-analytics-tracking`.
