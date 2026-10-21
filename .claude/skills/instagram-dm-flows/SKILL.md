---
name: instagram-dm-flows
description: "Fluxos de DM do Instagram e triagem de comentários — ManyChat por palavra-chave (variantes e teste de colisão, 4 respostas públicas, gate de seguir, mensagem com pergunta para abrir a janela de 24 h, follow-up, D+3 que vende, parada em 7 dias), opt-in de WhatsApp e resposta a comentários. Só escreve; o humano configura. Use ao criar fluxo de palavra-chave ou responder comentários."
version: "1.0"
updated: "2026-10-20"
---

# Instagram DM Flows — palavra-chave, ManyChat e comentários

Usada por LYRIS (instagram-content), que escreve, e por VERA (instagram-strategist), que valida. **Esta skill só escreve.** Quem configura o ManyChat, liga a automação e envia mensagem é o humano. Nenhum agente envia DM.

## 0. Princípio

A DM que funciona é **resposta a uma mão levantada**: a pessoa comentou a palavra-chave, respondeu um Story, perguntou. Ela se moveu primeiro. DM fria em massa para quem não interagiu viola os Termos do Instagram, restringe a conta e queima a confiança que o conteúdo construiu — **nunca** escreva isso. Automação de resposta a palavra-chave por ferramenta aprovada (ManyChat é parceira da Meta) é permitida.

## 1. Palavra-chave e variantes

1. **Uma palavra**, em maiúsculas no CTA do post, ligada ao que será entregue (ex.: `ROTEIRO`, `PLANILHA`).
2. **Variantes** de digitação que o público realmente escreve: sem acento, com erro comum, plural (ex.: `PLANILHA · PLANILIA · PLANILHAS`).
3. **Correspondência CONTÉM** pega a palavra dentro de frases — e também dentro de outras palavras. Por isso:
4. **Teste de colisão (obrigatório):**
   - A palavra ou variante é pedaço de palavra comum? (`INSTA` pega "instalar"; `IA` pega quase tudo). Se sim, troque.
   - Busque nos fluxos anteriores do projeto (arquivos de ManyChat das campanhas) se a palavra já está em uso em outro gatilho ativo. Se estiver, troque ou restrinja.
   - Se a palavra pode aparecer em comentário comum ("instagram", "claude"), **restrinja o gatilho a este post** — nunca gatilho global.
   - Registre o resultado: "grep em {pastas} em {data}: sem colisão".

## 2. Estrutura do fluxo (padrão do projeto)

```
CONFIGURAÇÃO DO FLUXO
  Gatilho           comentário no post {link ou nome}
  Palavras-chave    {PALAVRA} · {VARIANTE} · {VARIANTE}
  Correspondência   CONTÉM
  Escopo            só este post | global (justificar)
  Resposta pública  SIM

1. RESPOSTA PÚBLICA (variar entre 4)
2. GATE (quem ainda não segue)
3. MENSAGEM PRINCIPAL (entrega + pergunta)
4. FOLLOW-UP · ~23 h · só para quem não respondeu a 3
5. D+3 · só para quem interagiu (respondeu ou clicou) — a única que vende
REGRAS · 7 dias sem resposta, para
```

### 2.1 Resposta pública — 4 variações
Curta (2 a 5 palavras), sem emoji obrigatório, sem repetir a mesma frase em todo comentário (repetição idêntica parece robô e pode ser lida como spam). Ex.: "Te mandei na DM", "Chegou aí", "Acabei de mandar", "Olha a DM".

### 2.2 Gate de seguir — padrão do projeto (decisão C5)
Para quem ainda não segue: uma mensagem curta pedindo para seguir, com dois botões (`Seguir` · `Já sigo`). Quem já segue pula direto para a mensagem principal.

> **Contra-argumento registrado (avaliar por campanha):** entregar primeiro, sem condição, gera mais confiança e menos atrito — a pessoa pediu o que o post prometeu, e condicionar a entrega pode soar como isca e reduzir a taxa de conclusão do fluxo. O gate é o padrão deste projeto porque converte comentário em seguidor; a VERA pode dispensá-lo numa campanha (ex.: público frio de anúncio, entrega de alto valor, post de oferta) registrando o motivo no `validation.md`.

Regras do gate: nunca prometer algo diferente do post; quem toca "Já sigo" recebe a entrega mesmo que o sistema não confirme (não punir quem já segue); uma mensagem só, sem insistência.

### 2.3 Mensagem principal
- **Entrega primeiro**, na primeira linha útil: o link, o arquivo ou a resposta prometida.
- 1 a 2 linhas de como usar.
- **Termina em pergunta** fácil de responder ("Se travar em algum passo, me responde aqui que eu te ajudo." / "Qual parte você vai testar primeiro?"). A resposta da pessoa abre (e renova) a **janela de 24 h** de mensagens — sem ela, os passos 4 e 5 podem nem ser entregues. Marque no texto: *(a última linha abre a janela de 24 h — não cortar)*.
- Links com UTM, se o projeto mede (o mesmo link do tutorial/página da campanha).

### 2.4 Follow-up (~23 h, só para quem não respondeu)
Uma linha, dentro da janela de 24 h (agende para ~23 h depois da principal, não 25 h). Pergunta sobre o uso, nunca "só passando para lembrar". Quem respondeu a 3 não recebe.

### 2.5 D+3 — a única que vende
Só para quem **interagiu** (respondeu ou clicou) — é isso que mantém a janela aberta. Liga o que foi entregue ao que a conta vende, em 2 a 3 linhas, com um link. Nenhuma outra mensagem do fluxo vende.

### 2.6 Parada
7 dias sem resposta → o fluxo para. Sem terceira tentativa, sem reengajamento automático.

### 2.7 Regras do bloco
- Sem emoji (ou o padrão de voz da marca).
- Uma oferta por fluxo; registre quais ofertas **nunca** entram nesse tipo de fluxo (decisão do projeto).
- A URL do fluxo é a mesma do material da campanha (uma fonte só).
- **Prazos e regras da plataforma mudam:** antes de configurar, o humano confere a política atual do ManyChat/Meta (janela de 24 h, tags permitidas fora dela) e registra a data da conferência.

## 3. Saída: arquivo do fluxo

Salvar em `social-media/campaigns/{id}/copy/manychat.txt` com o bloco da seção 2 preenchido e as **notas**: resultado do teste de colisão (com data), escopo do gatilho, se o gate foi dispensado e por quê. Status no topo: `aguarda gate da VERA`. Só depois do PASS o humano configura.

### Exemplo preenchido (fictício)

```
CONFIGURAÇÃO DO FLUXO
  Gatilho           comentário no Reel "checklist de lançamento"
  Palavras-chave    CHECKLIST · CHEKLIST · CHECK LIST
  Correspondência   CONTÉM
  Escopo            só este post ("check" sozinho colide com comentário comum)
  Resposta pública  SIM

1. RESPOSTA PÚBLICA   Te mandei na DM · Chegou aí · Acabei de mandar · Olha a DM
2. GATE               O checklist eu mando pra quem me segue aqui.
                      Toca em seguir e ele chega na hora.
                      [ Seguir ]  [ Já sigo ]
3. PRINCIPAL          Aqui está o checklist de lançamento: {link com UTM}
                      Começa pela parte 1 — é a que mais gente pula.
                      Qual parte do seu lançamento está mais travada hoje?
                      (a última linha abre a janela de 24 h — não cortar)
4. FOLLOW-UP ~23 h    Conseguiu abrir o checklist? Qual item te pegou?
5. D+3                Esse checklist é a parte 1 do método que eu uso com
                      clientes. A versão completa, com acompanhamento: {link}
REGRAS  sem emoji · só a 5 vende · 7 dias sem resposta, para
NOTAS   colisão: busca nos fluxos de {pastas} em {data} — sem uso ativo
```

## 4. WhatsApp a partir da DM

Se o fluxo leva a conversa para o WhatsApp:
- **Opt-in explícito**, nomeando a empresa e o WhatsApp ("Quer receber pelo WhatsApp da {empresa}? Pode sair quando quiser."). Exigência da Meta e da LGPD; nunca caixa pré-marcada.
- **Janela de 24 h também vale no WhatsApp:** dentro dela, mensagem livre; fora dela, só **template aprovado** (marketing, utilidade ou autenticação — a Meta reclassifica template que mistura promoção como marketing).
- Todo template de marketing leva saída fácil (botão "Parar promoções" ou "Responda SAIR"). Saída fácil protege a nota de qualidade do número; bloqueio derruba.
- Preço e limites mudam com frequência: cite a página oficial e a data antes de estimar custo para o cliente.

## 5. Triagem de comentários

O usuário cola os comentários (print serve). Nunca raspar o post com navegador. Classifique **todos** e diga as contagens:

| Categoria | O que é | O que recebe |
|---|---|---|
| **KEYWORD** | a palavra-chave pedida | a entrega (pelo fluxo aprovado ou à mão) + resposta pública variada |
| **LEAD** | alguém descrevendo o problema que a conta resolve | resposta real em público + uma porta ("posso te mandar o modelo") — nunca pitch |
| **SUBSTANCE** | acrescenta dado, discorda, amplia | a resposta mais cuidadosa da thread |
| **QUESTION** | pergunta que muita gente tem | resposta curta + **sugestão de Reel-resposta** para a VERA pautar |
| **SUPPORT** | elogio, emoji, marcação | curtida e 3 a 8 palavras, no máximo |
| **NOISE** | spam, má-fé, isca | nada (ou ocultar, se abusivo) |

Como responder:
- Responda a pergunta de verdade no comentário; não mande para a DM o que cabe ali.
- Nome da pessoa uma vez, no começo. Tamanho proporcional ao comentário.
- **Crítico:** reconheça a parte verdadeira com as palavras dele, depois sustente a posição. Nunca apagar, nunca responder duas vezes na mesma thread.
- **Hater:** não responder (resposta é alcance). Ocultar se for abusivo.

Saída: um bloco agrupado por categoria, respostas prontas para colar, e a lista de QUESTION que viram Reel (vai para a VERA como sugestão de pauta). **Nada é postado até o usuário dizer sim** — ele cola as respostas.

## 6. Checklist do gate (VERA)

- [ ] Palavra-chave com variantes e teste de colisão registrado com data
- [ ] Gatilho restrito ao post quando a palavra é comum
- [ ] 4 respostas públicas diferentes
- [ ] Gate de seguir conforme o padrão (ou dispensa com motivo)
- [ ] Mensagem principal entrega primeiro e termina em pergunta
- [ ] Follow-up só para quem não respondeu, dentro da janela
- [ ] D+3 é a única que vende e só vai para quem interagiu
- [ ] Parada em 7 dias; nenhuma DM para quem não interagiu
- [ ] Opt-in explícito se houver WhatsApp
- [ ] Nenhum número, depoimento ou promessa sem fonte

## Skills relacionadas

- `/instagram-strategy` — onde a palavra-chave entra na pauta
- `/social-copywriting` — CTA com palavra-chave na legenda
- `/social-editorial-validation` — veredicto formal
