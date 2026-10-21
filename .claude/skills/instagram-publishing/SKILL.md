---
name: instagram-publishing
description: "Publicação orgânica da squad Instagram via Meta — Instagram (feed, Reels, Stories, carrossel), página do Facebook e Threads. Dupla confirmação (PASS da VERA para a plataforma + confirmação do usuário), upload, agendamento, verificação, registro e pacote manual quando não há servidor. Nunca impulsiona. Use ao publicar ou agendar peça aprovada."
version: "2.0"
updated: "2026-10-20"
---

# Instagram Publishing — Workflow de Publicação

Usada por PULSE (instagram-publisher). Cobre Instagram e, quando o projeto usa, a página do Facebook e o Threads — todos pela mesma conta Meta.

## Regra de dupla confirmação (CRÍTICO)

```
PULSE NUNCA publica sem, para ESTA peça, ESTA versão e ESTA plataforma:
  1. PASS formal da VERA (instagram-strategist) — timestamp e plataforma no validation.md
  AND
  2. Confirmação explícita do usuário nesta sessão
```

- PASS de outra squad de plataforma (TikTok, YouTube, LinkedIn) não vale aqui: aprovação não se transfere entre plataformas.
- PASS do feed do Instagram não cobre Facebook nem Threads, salvo se o validation.md citar a plataforma.
- Peça alterada depois do PASS → novo PASS.
- Timeout nunca vira publicação.

**Pedido de confirmação:**
```
"Vou publicar [descrição da peça] em [plataforma] às [horário].

Confirmações:
✅ PASS da VERA em [data/hora] para [plataforma]
✅ Assets dentro dos specs (/social-format-specs)

Confirma a publicação? (sim / não / agendar para [data])"
```

## Publicar não é impulsionar

Impulsionar (boost), criar anúncio ou definir orçamento gasta dinheiro e é da squad traffic (**traffic-meta**). Mesmo que uma ferramenta de boost (ex.: `ads_boost_ig_post`) apareça na listagem da sessão, PULSE não a usa. Pedido de boost → encaminhar ao lead.

## Onde está a ferramenta de publicação

- O conector Meta Ads (`ads_*`) lê mídia e insights — não publica orgânico.
- Publicação orgânica no Instagram e na página do Facebook exige um servidor MCP de Graph API configurado pelo projeto; Threads usa a API própria do Threads.
- O nome do servidor e das ferramentas fica em `docs/smart-memory/project/mcp.md`. Nunca invente nome de ferramenta.
- **Sem servidor de publicação:** montar o pacote manual (abaixo) e o usuário publica.

## Workflow

### Fase 1: Preparação
1. Verificar o PASS da VERA para a plataforma de destino no `validation.md`
2. Pedir a confirmação do usuário
3. Verificar os assets em `social-media/campaigns/{id}/assets/`
4. Conferir specs (tamanho, proporção, duração, capa) em `/social-format-specs`

### Fase 2: Upload
1. Carregar a mídia pela ferramenta do servidor configurado
2. Verificar o upload
3. Adicionar legenda aprovada (sem alterar uma vírgula — alteração pede novo PASS), alt text e localização, se houver

### Fase 3: Publicação ou agendamento
```
Opção A — publicar agora
Opção B — agendar para data/hora
Opção C — salvar como rascunho
```

### Fase 4: Verificação
1. Confirmar que a peça está no ar e abre corretamente
2. Registrar em `social-media/campaigns/{id}/published/`
3. Notificar o lead e a VERA com a URL
4. Se a peça tem palavra-chave de ManyChat, avisar o usuário para ligar o fluxo aprovado (`/instagram-dm-flows`) — PULSE não configura automação

## Pacote manual (sem servidor de publicação)

```
social-media/campaigns/{id}/published/pacote-{plataforma}.md
- Arquivo final: {path} (proporção, duração, peso)
- Capa: {path}
- Legenda aprovada: {texto exato}
- Alt text: {texto}
- Plataforma e horário: {plataforma} · {data hora}
- PASS da VERA: {timestamp}
- Confirmação do usuário: {timestamp}
```

## Facebook e Threads

- **Facebook (página):** mesma peça pode exigir legenda diferente (link clicável funciona no post; não no Instagram). Peça adaptada = nova versão = novo PASS.
- **Threads:** texto curto, conversa; não é a legenda do Reel colada. Mídia opcional. Gate próprio da VERA.

## Horário

Comece pelos insights de audiência online da própria conta. Tabelas genéricas de "melhor horário" não têm fonte datada — são só ponto de partida e perdem para o dado da conta. O horário importa menos que os primeiros 2 segundos da peça.

## Registro de publicações

```markdown
## Publicação — [Campaign ID]

**Data/hora:** [timestamp]
**Plataforma:** instagram | facebook | threads
**Formato:** ...
**URL do post:** ...
**PASS da VERA:** [timestamp] (plataforma: ...)
**Confirmação do usuário:** [timestamp]
**Assets publicados:** ...
```

## Skills relacionadas

- `/social-format-specs` — specs por formato
- `/social-analytics` — leitura das métricas orgânicas depois de publicar
- `/instagram-dm-flows` — fluxo de DM da palavra-chave da peça
