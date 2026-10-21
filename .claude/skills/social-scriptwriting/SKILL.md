---
name: social-scriptwriting
description: "Roteiros para vídeo curto (Reels, TikTok, Shorts, Stories) — 3 ganchos de fórmulas diferentes com nota 0–100, fala e texto de tela como roteiros separados, zona segura, uma ideia por vídeo, loop final e nada de número inventado. Use ao roteirizar vídeo curto, escolher o gancho, definir timing de cenas ou escrever texto em tela e narração."
version: "1.3"
updated: "2026-10-20"
---

# Social Scriptwriting — Roteiros para Vídeo Curto

> Skill injetada nos agentes de conteúdo das squads de plataforma (`<plataforma>-content` — ex.: LYRIS, instagram-content). Núcleo comum a vídeo vertical curto; o que só vale para o Instagram está na seção **Instagram** no fim. Fórmulas de gancho em `reference/ganchos.md`.

## 1. Antes de escrever

1. **Voz do usuário.** Leia o guia de voz do projeto (smart-memory) ou 2–3 roteiros já gravados por ele. Roteiro em voz errada não serve: ele precisa falar aquilo em voz alta.
2. **Uma coisa específica e verdadeira.** Se a ideia está rala, não encha: faça UMA pergunta agrupada — o que aconteceu, com quem, quanto custou ou rendeu.
3. **Uma ideia por vídeo.** Se o roteiro tem duas, são dois vídeos — diga isso e separe.

## 2. Forma

```
0:00–0:02   GANCHO      a afirmação. Fala e texto de tela escritos separados.
                        Movimento no primeiro quadro, não rosto parado.
0:02–0:07   O QUE ESTÁ EM JOGO   por que importa para quem assiste. Uma linha.
0:07–…      CORPO       uma ideia por batida; o quadro muda a cada batida (≤4 s cada).
3 s finais  ENTREGA     cumpre o que o gancho prometeu + a UMA ação.
última fala LOOP        repete uma palavra do gancho para o replay emendar limpo.
```

Duração de trabalho: 15–45 s. Abaixo de 7 s só infla repetição; acima de 60 s precisa de motivo.

## 3. Gancho: 3 opções, 3 fórmulas, nota em cada

1. Escolha **3 fórmulas diferentes** de `reference/ganchos.md` que caibam de verdade na ideia (não três reescritas da mesma).
2. Para cada uma, escreva a **fala** e o **card de tela**.
3. Dê nota pela rubrica abaixo e mostre o ranking ao usuário.
4. **Abaixo de 50 não grava.** Não existe gancho ainda — volte à ideia, não ao polimento.

### Rubrica manual (5 critérios, 0–20 cada → 0–100)

| Critério | 20 pontos | 10 pontos | 0–5 pontos |
|---|---|---|---|
| **Comprimento** | 5–12 palavras, ≤60 caracteres, ~2–4 s falado | 13–16 palavras ou 3–4 palavras | Mais de 16 ou menos de 3 |
| **Especificidade** | Número, valor, prazo ou nome próprio | Algo concreto, mas sem número | Só adjetivo ("muito", "incrível") |
| **O que está em jogo** | Perda, custo, erro, risco ou ganho claro | Insinuado | Afirmação neutra |
| **Essencial na frente** | A palavra que importa nas 3 primeiras | Entre a 4ª e a 6ª | Depois da 6ª, ou abre com "Então…", "Olá", "Neste vídeo" |
| **Fala direta** | "Você" ou imperativo ("Para de…") | Primeira pessoa ("eu", "a gente") | Terceira pessoa, ninguém na sala |

Regra do elo fraco: se **um critério tiver 0–5**, desconte 10 da soma — um defeito basta para o dedo seguir rolando. Faixas: **≥70 forte · 50–69 ok · <50 não grava.**

```
GANCHOS (nota)
  90  forte  Confissão de custo "Paguei dois anos de hora extra só formatando proposta."
                                tela: 2 ANOS PERDIDOS        (20+20+20+20+10)
  80  forte  Tempo encolhido    "Proposta me tomava cinco horas. Hoje, vinte minutos."
                                tela: 5 HORAS → 20 MIN       (20+20+10+20+10)
  40  fraco  Lista genérica     "Algumas dicas para melhorar suas propostas"  → não grava
                                (20+0+5+5+20 = 50, −10 do elo fraco)
```

## 4. Texto de tela é um roteiro separado

Escreva sempre à parte, com tempo de entrada. É lido antes de ser ouvido — a maioria assiste sem som primeiro.

- **≤6 palavras por card.** Lido a um braço de distância por quem ainda não está ouvindo.
- **O card do gancho entra no quadro 1**, não depois de um silêncio.
- **Reforça, não repete** a fala palavra por palavra (exceto a legenda queimada do corpo).
- **Legenda queimada no corpo** do vídeo.
- **Zona segura (1080×1920):** nada acima de **y=230** nem abaixo de **y=1440**, e **230 px livres à direita**. Fora dessa caixa ficam a legenda do post, os botões laterais e a faixa de áudio da interface.
- Nunca ponha o gancho na base do quadro — é onde a legenda do post cobre.
- Fonte legível no celular (mínimo ~48 px no quadro 1080 de largura).

## 5. Regras que fazem diferença

- **Corte a introdução.** Sem saudação, sem "neste vídeo", sem nome, sem vinheta. O vídeo começa na frase que normalmente viria no segundo 6.
- **Número em vez de adjetivo.** "R$ 4.200" vence "muito dinheiro".
- **Nunca inventar número**, cliente, faturamento ou resultado em nome do usuário, nem como exemplo. Sem o dado, escreva `{{seu número}}` no roteiro e sinalize na entrega.
- **Muda o quadro a cada batida.** Plano parado por 8 s é onde as pessoas saem.
- **Uma ação no fim.** Comentar uma palavra, salvar ou seguir. A keyword é a mesma da legenda (`/social-copywriting`) e é **falada**.
- **Não construa o roteiro em cima de áudio em alta que o usuário não pode usar** (conta comercial, direitos). Se a ideia depende da voz dele, diga.

## 6. Formato de entrega

```markdown
## Roteiro — [Título]
**Plataforma:** Reel | TikTok | Shorts   **Duração:** ~28 s   **Formato:** talking head | b-roll | tela
**Gancho escolhido:** [fórmula] — nota [N] (forte/ok)

### Fala
[0:00–0:02] "..."
[0:02–0:07] "..."
...
[0:25–0:28] "... comenta PROPOSTA ..."   ← ação
[0:28–0:30] "... [palavra do gancho]"    ← loop

### Texto de tela (separado)
| Entrada | Card (≤6 palavras) | Posição |
|---|---|---|
| 0:00 | 5 HORAS → 20 MIN | centro, y 600–900 |

### Pendências
- {{seu número}} em 0:12 — pedir ao usuário
```

Depois: legenda em `/social-copywriting` (quase sempre Job A). Nada é gravado nem publicado por esta skill.

## 7. Reaproveitar em outra plataforma

A versão para outra plataforma é **peça nova**: reescreva gancho, duração, texto de tela e ação para o formato de lá, e ela **passa pelo gate daquela plataforma**. Aprovação de uma plataforma não vale para outra.

## Instagram

- Reels: corte/mudança de quadro a cada 2–3 s; TikTok tende a 1–2 s.
- A zona segura acima (1080×1920, y 230–1440, 230 px à direita) é a do Reel com legenda e botões sobrepostos.
- Capa do Reel escolhida de propósito (legível no grid), não o quadro 1 por acaso.
- Stories: até 15 s por quadro, uma mensagem por quadro, figurinha de interação só se servir à ação.
