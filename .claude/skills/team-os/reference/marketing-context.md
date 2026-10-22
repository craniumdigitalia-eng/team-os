# Template — `docs/smart-memory/project/marketing-context.md`

> Extraído do SKILL.md — carregar sob demanda. É o **contexto mínimo de marca** que os agentes de canal (instagram, tiktok, youtube, linkedin, traffic, sales) leem antes de escrever ou aprovar. Um arquivo por projeto, curto (alvo: menos de 120 linhas), mantido com o usuário.

## Regra de origem — leia antes de criar

- **Squad brand instalada** (existe `docs/smart-memory/project/brand-platform.md`): este arquivo é **DERIVADO**. Ele só aponta para a plataforma de marca, o guia de voz (`project/brand-voice.md`) e o framework de mensagens (`project/brand-messaging.md`). Nunca reescreve, resume com outras palavras nem "atualiza" o que a brand decidiu. Mudança de promessa, voz ou público vai para a squad brand, não para cá. Use a variante curta no fim deste arquivo.
- **Sem squad brand**: este arquivo é a fonte. Crie a partir do template abaixo, **preenchido com o usuário** — nunca inventado. Campo sem resposta fica `[PERGUNTAR]`, não com um palpite plausível.
- Quem cria: o primeiro strategist de canal que precisar dele (ou o lead na Fase 2 do `/team-os`). Quem altera: qualquer strategist, sempre com data e origem na seção de aprendizados.
- Agentes de conteúdo **leem**; não editam. Achou algo errado? Mande ao strategist da sua squad.

## Template (projeto sem squad brand)

```markdown
---
status: rascunho | validado-com-usuario
updated: AAAA-MM-DD
origem: conversa com o usuário em AAAA-MM-DD (+ documentos citados)
---

# Contexto de marketing — {empresa / projeto}

## 1. Produto e oferta
- O que vendemos, numa frase que o dono diria a um amigo:
- Ofertas ativas (nome · para quem · preço ou faixa · o que inclui):
- O que NÃO vendemos / não prometemos:
- Próxima ação que queremos do leitor (seguir, chamar no direct, agendar, comprar):

## 2. Público e dores — na linguagem do cliente
- Quem compra (cargo, momento de vida, contexto):
- Dores, escritas como o cliente fala (cole frases reais de comentário, DM, reunião, avaliação — com a origem):
  - "…" — fonte: {DM de 2026-09-12 / transcrição / avaliação Google}
- O que ele já tentou e por que não funcionou:
- Palavras que ELE usa para o problema (não as nossas):

## 3. Objeções
| Objeção (como o cliente diz) | Resposta que usamos | Prova que sustenta |
|---|---|---|
| | | |

## 4. Provas — só com fonte
| Prova (número, caso, depoimento, credencial) | Fonte verificável | Pode citar nome? | Data |
|---|---|---|---|
| | | | |
Prova sem fonte não entra em peça. Número sem fonte → `[SEM FONTE]` até alguém confirmar.

## 5. Voz
- Três adjetivos da voz, cada um com o "mas não" (ex.: direta, mas não grossa):
- Tratamento (você / vocês / tu), uso de gíria, emoji (sim/não/onde), palavrão (sim/não):
- Uma frase que soa como nós:
- Uma frase que NÃO soa como nós:
- Grafias fixas (nome da empresa, produtos, termos técnicos):

## 6. Palavras e temas proibidos
- Palavras que a marca não usa (além do léxico de `/copy-humanize`):
- Promessas proibidas (resultado garantido, prazo, comparação nominal com concorrente…):
- Temas fora de pauta:
- Restrições legais ou de plataforma do setor (saúde, finanças, infoproduto…):

## 7. Aprendizados datados
Uma linha por aprendizado, a mais nova em cima. Nunca apague: marque `supersedes`.
- AAAA-MM-DD · {canal} · {o que aprendemos} · evidência: {link/métrica/#id} · supersedes: —
```

## Variante curta (projeto com squad brand)

```markdown
---
status: derivado
updated: AAAA-MM-DD
---

# Contexto de marketing — {empresa / projeto}

Fonte de marca: squad brand. Este arquivo não decide nada.
- Plataforma (promessa, público, posicionamento, provas): `project/brand-platform.md`
- Voz e "dizemos / não dizemos": `project/brand-voice.md`
- Mensagens por público e nível de consciência: `project/brand-messaging.md`
- Glossário e grafias: `agents/brand/voice/glossary.md`

## Específico de canal (não contradiz a brand)
- Ofertas ativas e próxima ação por canal:
- Objeções ouvidas nos canais (com origem):

## Aprendizados datados
- AAAA-MM-DD · {canal} · {aprendizado} · evidência: {…} · supersedes: —
```

Se algo aqui conflitar com a plataforma, a plataforma vence e o conflito vai para a squad brand.
