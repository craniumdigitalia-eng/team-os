---
name: social-apify-research
description: "Pesquisa de tendências e concorrentes via Apify MCP — referências escolhidas pelo múltiplo de outlier (views ÷ mediana da conta), contas comparáveis, hashtags e padrões de gancho, com limite de volume e respeito aos termos das plataformas. Use ao pesquisar tendências, analisar perfis concorrentes ou levantar referências antes de planejar conteúdo social."
version: "1.1"
updated: "2026-10-20"
---

# Social Apify Research — Pesquisa via Apify MCP

> Skill injetada no agente LYRIS (social-content). Núcleo comum a todas as plataformas; o que só vale para o Instagram está na seção **Instagram** no fim.

## 1. Limite de volume e termos de uso (ler antes de rodar)

- **Pesquisa, não raspagem em massa.** Coleta pequena e dirigida: ~5–10 contas, ~12 posts recentes de cada, por rodada. Nada de crawler, varredura de hashtag inteira, coleta de seguidores/comentaristas ou execução agendada sem pedido.
- Coleta automatizada em volume viola os termos de uso das plataformas (Instagram, TikTok) e pode gerar bloqueio de conta. Se o pedido exigir volume maior, **pare e pergunte** ao usuário, registrando o risco.
- **Só dado público e agregado** (views, curtidas, legenda, formato, data). Nunca guardar dado pessoal de terceiros (lista de seguidores, perfis de comentaristas, contato).
- Cada rodada de actor tem custo na conta Apify do usuário: diga quantos itens vai pedir antes de rodar.

## 2. Escolher referências pelo múltiplo de outlier

Views brutas enganam: conta grande em dia fraco ainda supera conta pequena no melhor dia. Para cada conta coletada:

1. **Mediana** de views dos últimos ~12 posts do mesmo formato.
2. **Múltiplo de outlier = views do post ÷ mediana da própria conta.**
3. **> 3× = referência** (algo funcionou ali). 1,5×–3× = anotar. **< 1,5× = ruído**, descarte.
4. Compare só com contas **até 10× o tamanho** da conta do usuário — o que funciona com milhões de seguidores muitas vezes funciona por causa dos milhões.

Sem mediana, não há ranking: volte a coletar os ~12 posts da conta.

## 3. Casos de uso

### Referências do nicho (padrão)
```markdown
## Referências — [Nicho] — [data] — N contas, N posts, base: mediana de cada conta

| Múltiplo | Conta (seguidores) | Views (mediana) | Formato | Fórmula do gancho | 1ª linha |
|---|---|---|---|---|---|
| 12,4× | @conta_a (18 mil) | 96.000 (7.700) | Reel 24 s | Ninguém te conta | "..." |

**O que separa o terço de cima do de baixo:** gancho mais curto, número na 1ª frase, ...
**Fórmulas recorrentes nos outliers:** [nomes de `social-scriptwriting/reference/ganchos.md`]
```

### Análise de concorrentes
- Posts acima de 3× nos últimos 30–60 dias (não "mais curtidos")
- Formatos e durações dos outliers
- Frequência de publicação
- Ganchos e CTAs usados nos outliers

### Hashtags
Rótulos de tema específicos, não alavanca de alcance. Levante **3–5 hashtags relevantes** por tema (regra C4 do CT, até haver fonte oficial datada): uma ampla do nicho + 2–4 específicas. Descarte genéricas (`#viral`, `#fyp`, `#explore`).

## 4. Protocolo

1. Definir nicho e mercado (BR, PT, ES, EN) e o tamanho da conta do usuário.
2. Selecionar 5–10 contas comparáveis (até 10× o tamanho).
3. Rodar o actor com limite explícito de itens (seção 1).
4. Calcular mediana e múltiplo; ficar com os > 3×.
5. Consolidar no modelo acima e extrair 3–5 insights acionáveis para copy e roteiro.
6. Salvar em `social-media/campaigns/{id}/research/research.md` com data e fonte de cada número.

## 5. Frequência
- Referências do nicho: semanal ou por campanha
- Concorrentes: quinzenal
- Hashtags: por campanha

## Instagram

- Actor: `apify/instagram-scraper` (posts, perfis, hashtags) — sempre com `resultsLimit` baixo.
- Views de Reel são o número de comparação; para carrossel use curtidas + comentários com a mesma lógica de mediana.
- Nada é seguido, curtido, comentado ou enviado por esta skill: ela só lê.
