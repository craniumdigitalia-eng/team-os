---
name: tiktok-marketing
description: "Estratégia de TikTok orgânico — pilares de conteúdo, gancho nos 3 primeiros segundos, sons em alta com janela de ~48h, hashtags, cadência, horários e métricas de retenção. Use ao planejar pauta, escrever roteiro ou avaliar desempenho orgânico no TikTok. Anúncios e Spark Ads ficam na traffic-paid-ads-optimization."
version: "2.1"
updated: "2026-10-20"
---

# TikTok Marketing — Orgânico

Usada pela squad **tiktok** (tiktok-strategist, tiktok-content, tiktok-publisher). Pacote de upload e leitura do export ficam em `tiktok-publishing`. **Anúncios** (Spark Ads, In-Feed, specs e métricas pagas) ficam em `traffic-paid-ads-optimization` (seção "TikTok Ads"), usada pelo traffic-tiktok — a fronteira é o código de autorização Spark, que o usuário gera no post orgânico.

## Princípio central

TikTok é uma plataforma de **interesse**, não de seguidores: o For You distribui cada vídeo pelo comportamento de retenção da audiência, não pelo tamanho da conta. Tempo assistido e % de conclusão mandam em tudo.

## 1. Pilares de conteúdo

Definir 3-4 pilares por conta e manter proporção estável:

| Pilar | Proporção sugerida | Função |
|---|---|---|
| Educacional (how-to, dicas, mitos) | 40% | Alcance e autoridade |
| Entretenimento (trends, humor, bastidores) | 30% | Retenção e afinidade |
| Prova social (cases, depoimentos, antes/depois) | 20% | Consideração |
| Venda direta (oferta, produto, CTA) | 10% | Conversão |

Regra: conta que só vende morre no alcance. O pilar de venda funciona **porque** os outros três existem.

## 2. Hook — os 3 primeiros segundos

O algoritmo mede a taxa de quem passa dos 3 primeiros segundos. Sem hook, o resto do vídeo não existe.

**Padrões de hook que funcionam:**
- Resultado na frente: "Isso aumentou nossas vendas em 40%" (depois explica)
- Contra-intuitivo: "Pare de postar todo dia. Sério."
- Loop aberto: "O erro nº 3 é o que mais destrói contas novas"
- Chamada direta ao nicho: "Se você tem loja no Instagram, escuta isso"
- Movimento/corte brusco no primeiro frame (nunca abrir com logo ou vinheta)

**Regras:**
- Texto na tela já no primeiro frame reforçando o hook
- Nada de "oi gente, tudo bem?" — começar no meio da ação
- Prometer só o que o vídeo entrega (retenção quebrada = punição no alcance)

## 3. Trending sounds — janela de ~48h

- Sons em ascensão têm janela útil de **~48 horas** antes de saturar: monitorar o Creative Center (Trends) e a aba de sons diariamente
- Usar o som trending **adaptado ao nicho** — replicar o trend literal sem conexão com o pilar não converte
- Sons comerciais: contas business só podem usar a Commercial Music Library; verificar antes de produzir
- Volume do som baixo (10-20%) quando há narração própria

## 4. Hashtags e descrição

- **3–5 hashtags relevantes**: 1 ampla (#marketing), 1–2 de nicho (#trafegopago), 1–2 específicas do conteúdo (regra do pack até haver fonte oficial datada que diga outra coisa)
- Não usar #fyp/#foryou como estratégia — não influencia distribuição
- Descrição: 1 frase com keyword do tema (TikTok indexa como busca) + pergunta que gere comentário

## 5. Cadência

| Estágio da conta | Frequência |
|---|---|
| Conta nova (0-1k) | 1-2x/dia por 30 dias (volume para o algoritmo mapear a audiência) |
| Em crescimento | 5-7x/semana |
| Estabelecida | 3-5x/semana, priorizando qualidade e séries |

- Séries (parte 1, 2, 3...) elevam o retorno ao perfil — o melhor sinal composto
- Responder comentários com vídeo (Video Reply) conta como conteúdo novo

## 6. Horários genéricos BR

*Ponto de partida — ajustar com analytics da conta após 2-4 semanas:*

| Dias | Janelas |
|---|---|
| Seg-Sex | 7h-9h (deslocamento), 12h-13h (almoço), 19h-23h (pico) |
| Sáb-Dom | 11h-13h e 19h-22h |

## 7. Anúncios — fora desta skill

Spark Ads, In-Feed, specs de anúncio, estrutura de campanha e métricas pagas estão em `traffic-paid-ads-optimization` (seção "TikTok Ads") (squad traffic). Aqui a squad tiktok só marca uma peça orgânica como "candidata a Spark"; o usuário gera o código de autorização e daí em diante é do traffic-tiktok.

## 8. Métricas que importam

| Métrica | O que indica | Referência |
|---|---|---|
| **Watch time médio** | Qualidade do conteúdo | quanto maior, melhor |
| **Completion rate** | Força do hook + duração certa | >50% em vídeos <15s é bom |
| Retenção aos 3s | Hook | >70% |
| **Shares** | Sinal mais forte de distribuição | acompanhar por pilar |
| Saves | Conteúdo de referência | alto em educacional |
| Comentários | Comunidade + sinal de distribuição | responder nas 2 primeiras horas |
| Seguidores/visualização | Conversão de perfil | >1% é forte |

Vaidade sem contexto: views totais e seguidores — nunca otimizar por elas isoladamente.

## 9. Checklist antes do pacote de upload

```
[ ] Hook nos 3 primeiros segundos (visual + texto na tela)
[ ] Formato 9:16 1080x1920, legendas burned-in
[ ] Som: trending dentro da janela OU narração clara (Commercial Library se business)
[ ] 3–5 hashtags relevantes (ampla/nicho/específica)
[ ] Descrição com keyword de busca + gatilho de comentário
[ ] Zonas de UI livres de texto (150px topo, 380px base)
[ ] Rótulo de conteúdo gerado por IA marcado se houver mídia realista de IA
[ ] Horário dentro das janelas da conta
```
