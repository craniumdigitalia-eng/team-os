---
name: youtube-scriptwriting
description: "Método de roteiro para YouTube longo e Shorts — 5 estruturas (tutorial, explicativo, lista, review, história), gancho de 0–5 s que o vídeo paga, pontos de retenção marcados, CTA único e lista obrigatória de claims com texto, risco e fonte (proibido número sem fonte). Use ao escrever, revisar ou aprovar roteiro de vídeo para o canal."
version: "1.0"
updated: "2026-10-20"
---

# YouTube Scriptwriting — roteiro que prende e se sustenta

Roteiro de YouTube tem dois inimigos: o espectador que sai aos 30 segundos e o comentário que prova que um número estava errado. Este método ataca os dois — estrutura escolhida de propósito, gancho que o vídeo paga, retenção planejada cena a cena e **todo fato verificável listado com a fonte antes de gravar**.

Usada por: youtube-content (escreve) e youtube-strategist (julga). Para Shorts, combine com `/social-scriptwriting` (núcleo de roteiro curto).

## 1. Antes de escrever

- [ ] Pauta aprovada pela youtube-strategist (pilar, ângulo novo, público)
- [ ] Promessa do vídeo em **uma frase**: "depois de assistir, você vai {resultado}"
- [ ] **Valor original** declarado: o que este vídeo tem que os 10 primeiros resultados da busca não têm (dado próprio, demonstração, caso real, opinião fundamentada). Sem isso, o roteiro não começa
- [ ] Fontes reunidas para os fatos que você já sabe que vai usar
- [ ] Duração-alvo e formato (longo 16:9 ou Shorts 9:16)

## 2. As 5 estruturas

Escolha **uma** e declare no topo do roteiro. A estrutura nasce da promessa, não do gosto.

| Estrutura | Quando usar | Sequência de blocos |
|---|---|---|
| **Tutorial** | "como fazer X" — resultado prático | gancho → introdução → problema → passos → demonstração → recapitulação → CTA |
| **Explicativo** | "por que / o que é X" | gancho → pergunta central → contexto → explicação → exemplos → implicações → resumo → CTA |
| **Lista** | "N formas / ferramentas / erros" | gancho → introdução → itens (do 2º melhor ao melhor, último guardado) → bônus → resumo → CTA |
| **Review** | avaliar produto, serviço, ferramenta | gancho → introdução → visão geral → prós → contras → comparação → veredicto → CTA |
| **História** | caso, bastidor, jornada | gancho → cenário → conflito → jornada → clímax → resolução → lição → CTA |

Regras:
- **Lista:** não entregue o melhor item primeiro; anuncie no gancho que existe um item que "muda o jogo" e cumpra.
- **Review:** contras são obrigatórios. Review sem contra é publicidade — e, se houver relação comercial, a divulgação de patrocínio também é obrigatória.
- **História:** o conflito aparece até 20% da duração; sem conflito não há história, há relato.

## 3. Gancho (0–5 s)

Os primeiros 5 segundos decidem se existe o resto. O gancho:
1. **Confirma o clique** — repete ou aprofunda a promessa do título/thumb (quem clicou precisa saber que está no vídeo certo)
2. **Abre um laço** — uma pergunta, tensão ou resultado que só se fecha mais à frente
3. **Não promete o que o vídeo não paga** — gancho que o vídeo não sustenta derruba a retenção aos 30 s

Tipos (escreva 2–3 e escolha um):
| Tipo | Forma | Cuidado |
|---|---|---|
| Pergunta | "Por que {coisa contraintuitiva}?" | pergunta genérica não prende |
| Resultado | mostrar o fim primeiro ("isto aqui levou 10 minutos") | o resultado precisa ser real e mostrado |
| Contraintuitivo | "Quase todo mundo faz {X} — e é por isso que {Y}" | precisa de prova no vídeo |
| Promessa | "Em {N} minutos você vai {resultado}" | N real, resultado real |
| Dado | "{número} de {grupo} {fato}" | **número vai para a lista de claims com fonte** |

Depois do gancho, até ~20 s: **introdução curta** — quem fala, por que confiar (uma frase), o que vem. Nada de "fala, pessoal, antes de começar deixa o like".

## 4. Pontos de retenção

Marque no roteiro, com minutagem estimada, onde o espectador tende a sair e o que o segura:

- **Reengate a cada 60–90 s** no longo: nova pergunta, virada, "agora a parte que ninguém mostra", mudança visual
- **Laço aberto** antes de cada bloco longo: anuncie o que vem e por que importa
- **Mudança de cena** marcada para o estúdio: `[CENA: tela | câmera | b-roll | gráfico]`
- **Corte do óbvio:** frase que o público já sabe sai
- **Bloco de dados:** no máximo 1 número por frase; números grandes ganham comparação concreta
- **Final sem "então é isso"**: a última informação de valor vem imediatamente antes do CTA

Formato de marcação:
```
[00:00–00:05] GANCHO (tipo: resultado) — texto
[00:05–00:20] INTRODUÇÃO — texto
[01:30] ⟲ REENGATE — "mas tem um detalhe que muda tudo…"
[CENA: tela] demonstração do passo 3
```

Depois da publicação, a youtube-publisher lê a curva por cena (`/youtube-analytics`); quedas fortes voltam como nota para o próximo roteiro. Por isso as cenas precisam de rótulo estável.

## 5. CTA

- **Um** CTA principal, coerente com o objetivo do vídeo (inscrição, próximo vídeo, material, comentário com pergunta específica)
- Pedido de comentário com **pergunta concreta** ("qual desses passos travou você?") — gera dado para a pauta
- "Próximo vídeo" aponta para um vídeo real do canal, com motivo
- CTA comercial só se a linha do canal permitir e com divulgação clara

## 6. Lista de claims (obrigatória)

Todo fato **verificável por terceiros** — número, data, nome de lei, preço, resultado de estudo, afirmação sobre empresa ou pessoa, comparação — entra na lista. Opinião declarada como opinião não entra.

```markdown
## Claims — vídeo {id}

| # | Claim (texto exato do roteiro) | Risco | Fonte (URL ou documento) | Consultada em |
|---|---|---|---|---|
| 1 | "68% das pequenas empresas…" | alto | https://… (relatório X, p. 12) | 2026-10-20 |
| 2 | "a ferramenta custa R$ 49/mês" | padrão | página de preços oficial | 2026-10-20 |
| 3 | "a lei Y obriga Z" | alto | — | — |
```

- **Risco alto:** saúde, finanças, jurídico, segurança, afirmação sobre terceiro identificável, número que sustenta a tese do vídeo. **Padrão:** o resto.
- **Proibido número sem fonte.** Claim sem fonte: (a) acha a fonte, (b) reescreve sem o número ("muita gente", "a maioria dos que eu atendi" — se for verdade e declarado como experiência), ou (c) sai do roteiro.
- Fonte é **a primária** quando existe (relatório, documento oficial, página do fabricante), não o blog que citou.
- Use só fontes que você abriu. Nunca invente URL nem página.
- Claim de risco alto sem fonte = FAIL no gate, sem exceção.
- Dispensa de fonte só por decisão escrita da youtube-strategist, registrada na lista.

## 7. Shorts

- 1 ideia por Short; gancho no primeiro segundo; texto na tela ≤6 palavras na zona segura
- Short derivado de vídeo longo leva um motivo próprio para existir (não é trailer)
- Mesmas regras de claims — o Short não ganha passe livre por ser curto

## 8. Entrega

`social-media/youtube/{id}/roteiro.md` com: estrutura declarada, promessa, valor original, roteiro marcado (gancho, retenção, cenas, CTA), duração estimada; e `claims.md` separado. Depois, SendMessage à youtube-strategist com os dois paths.

## 9. Checklist do gate (youtube-strategist)

- [ ] Estrutura declarada e coerente com a promessa
- [ ] Gancho 0–5 s confirma o clique e é pago pelo vídeo
- [ ] Reengates marcados; cenas com rótulo estável
- [ ] Valor original explícito
- [ ] Lista de claims completa; nenhum número sem fonte; risco alto com fonte primária
- [ ] CTA único

## 10. Anti-padrões

| Anti-padrão | Por que falha |
|---|---|
| Gancho "neste vídeo eu vou falar sobre…" | anuncia em vez de prender |
| "Estudos mostram que…" sem estudo | claim sem fonte disfarçado |
| Introdução de 1 minuto | a curva cai antes do conteúdo |
| Lista com o melhor item primeiro | não há motivo para ficar |
| Mesmo roteiro com outro tema | conteúdo repetitivo — risco de política e de canal |
| Pedir like/inscrição no gancho | troca o motivo do clique por um pedido |

> Método adaptado de darkzOGx/youtube-automation-agent (MIT) — estruturas, gancho 0–5 s e lista de claims com risco e fonte; reescrito para o fluxo de squad, sem automação.
