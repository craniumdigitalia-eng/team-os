---
name: seo-geo
description: "Otimizar conteúdo para AI Overviews, ChatGPT search, Perplexity e outras buscas por IA — Generative Engine Optimization (GEO): sinais de menção de marca, acesso de crawlers de IA, llms.txt, citabilidade por passagem e otimização por plataforma. Use ao pedir 'AI Overviews', 'GEO', 'AI search', 'LLM optimization', 'AI citations' ou 'AI visibility'."
version: "2.4.0"
updated: "2026-10-20"
user-invocable: true
argument-hint: "[url]"
license: MIT
metadata:
  author: AgriciDaniel
  version: "2.3.1"
  category: seo
---

# Busca por IA / Otimização GEO (maio de 2026)

## Fonte primária: o guia de otimização para IA do Google

Posição oficial do Google, publicada na documentação do Search Central:

> "Optimizing for generative AI search is **still SEO** from Google's
> perspective. AEO and GEO are rebranded labels for the same work."

Leia `references/google-ai-optimization-guide.md` para a síntese completa, a
lista de mitos derrubados (`llms.txt`, chunking, reescrita "para IA",
fabricação de menções — todos rejeitados pelo Google como ineficazes) e o teste
Who/How/Why de qualidade de conteúdo.

A auditoria deve enquadrar os achados de GEO como **fundamentos de SEO aplicados
às superfícies de busca por IA**, não como disciplina de otimização separada.
Quando recomendação da comunidade contradiz a fonte primária do Google, siga o
Google e registre a contradição no relatório.

## Estatísticas-chave

| Métrica | Valor | Fonte |
|--------|-------|--------|
| Alcance do AI Overviews | 2,5 bilhões+ de usuários ativos mensais, segundo a cobertura do keynote do Google I/O 2026; não confirmado em fonte do próprio Google; 200+ países | Cobertura de terceiros do I/O |
| Cobertura de consultas do AI Overviews | ~50% das consultas (medição de terceiros; varia por país) | Dados de mercado |
| Usuários mensais do AI Mode | 1 bi+, segundo a cobertura do keynote do Google I/O 2026; não confirmado em fonte do próprio Google | Cobertura de terceiros do I/O |
| Modelo do AI Mode | versão customizada do Gemini 2.5 | Google |
| Crescimento de sessões vindas de IA | 527% (jan–mai 2025) | SparkToro |
| Usuários ativos semanais do ChatGPT | 900 milhões | OpenAI |
| Consultas mensais no Perplexity | 500+ milhões | Perplexity |

## Insight crítico: menção de marca > backlinks

**Menções de marca têm correlação 3x maior com visibilidade em IA do que backlinks.**
(Estudo da Ahrefs de dezembro de 2025 com 75.000 marcas)

| Sinal | Correlação com citações em IA |
|--------|------------------------------|
| Menções no YouTube | ~0,737 (a mais forte) |
| Menções no Reddit | Alta |
| Presença na Wikipedia | Alta |
| Presença no LinkedIn | Moderada |
| Domain Rating (backlinks) | ~0,266 (fraca) |

**Só 11% dos domínios** são citados ao mesmo tempo pelo ChatGPT e pelo Google AI Overviews para a mesma consulta — por isso a otimização por plataforma é essencial.

---

## Critérios de análise GEO (atualizados)

### 1. Pontuação de citabilidade (25%)

**Tamanho ótimo de passagem: 134–167 palavras** para citação por IA. E **~44% das
citações de IA vêm dos primeiros 30% da página** (estudo da SE Ranking): ponha
no início a resposta mais citável e autocontida, em vez de enterrá-la abaixo da
dobra.

**Sinais fortes:**
- Frases claras e citáveis, com fatos/estatísticas específicos
- Blocos de resposta autocontidos (extraíveis sem contexto)
- Resposta direta nas primeiras 40–60 palavras da seção
- Afirmações atribuídas a fontes específicas
- Definições no padrão "X é..." ou "X se refere a..."
- Dados únicos que não existem em outro lugar

**Sinais fracos:**
- Afirmações vagas e genéricas
- Opinião sem evidência
- Conclusões enterradas
- Nenhum dado específico

### 2. Legibilidade estrutural (20%)

**92% das citações do AI Overview vêm de páginas no top 10**, mas 47% vêm de páginas abaixo da posição 5 — a lógica de seleção é outra.

**Sinais fortes:**
- Hierarquia limpa H1->H2->H3
- Títulos em forma de pergunta (casam com o padrão das consultas)
- Parágrafos curtos (2–4 frases)
- Tabelas para dados comparativos
- Listas ordenadas/não ordenadas para passo a passo ou vários itens
- Seções de FAQ em formato claro de pergunta e resposta

**Sinais fracos:**
- Parede de texto sem estrutura
- Hierarquia de títulos inconsistente
- Nenhuma lista ou tabela
- Informação enterrada em parágrafos

### 3. Conteúdo multimodal (15%)

Conteúdo com elementos multimodais tem **taxa de seleção 156% maior**.

**Verifique:**
- Texto + imagens relevantes
- Vídeo (embutido ou linkado)
- Infográficos e gráficos
- Elementos interativos (calculadoras, ferramentas)
- Dados estruturados que sustentam a mídia

### 4. Sinais de autoridade e marca (20%)

**Sinais fortes:**
- Assinatura do autor com credenciais
- Data de publicação e de última atualização
- **Recência**: conteúdo com menos de 3 meses tem ~3x mais chance de ser citado em respostas de IA; páginas paradas há 6+ meses perdem elegibilidade de citação (SE Ranking, estudo com 1,3 mi de citações). Um programa agendado de atualização é uma das jogadas de GEO de maior alavanca.
- Citação de fontes primárias (estudos, documentação oficial, dados)
- Credenciais e afiliações da organização
- Citações de especialistas com atribuição
- Presença da entidade na Wikipedia e no Wikidata
- Menções no Reddit, YouTube, LinkedIn

**Sinais fracos:**
- Autoria anônima
- Sem datas
- Sem fontes citadas
- Sem presença da marca nas plataformas

### 5. Acessibilidade técnica (20%)

**Crawlers de IA NÃO executam JavaScript.** Renderização no servidor é crítica.

**Verifique:**
- Renderização no servidor (SSR) vs conteúdo só no cliente
- Acesso de crawlers de IA no robots.txt
- Presença e configuração do llms.txt
- Termos de licenciamento RSL 1.0

---

## Detecção de crawlers de IA

Verifique no `robots.txt` estes crawlers de IA:

| Crawler | Dono | Finalidade | Obedece robots.txt? |
|---------|-------|---------|---|
| GPTBot | OpenAI | **Só treino de modelo** (NÃO é o ChatGPT Search) | sim |
| OAI-SearchBot | OpenAI | **Citabilidade no ChatGPT Search** (é o crawler que decide) | sim |
| ChatGPT-User | OpenAI | Navegação do ChatGPT (acionada pelo usuário) | não (acionado pelo usuário) |
| ClaudeBot | Anthropic | **Só treino de modelo** (NÃO são os recursos de busca do Claude) | sim |
| Claude-SearchBot | Anthropic | **Citabilidade nos resultados de busca do Claude/Claude.ai** (é o crawler que decide) | sim |
| Claude-User | Anthropic | Navegação do Claude em nome do usuário (acionada pelo usuário) | não (acionado pelo usuário) |
| PerplexityBot | Perplexity | Busca por IA do Perplexity | sim |
| CCBot | Common Crawl | Dados de treino (frequentemente bloqueado) | sim |
| Bytespider | ByteDance | IA do TikTok/Douyin | sim |
| cohere-ai | Cohere | Modelos da Cohere | sim |
| Google-Extended | Google | **Só treino e grounding do Gemini/Vertex** (NÃO é a Busca do Google) | sim |
| Google-CloudVertexBot | Google | Rastreios do Vertex AI Agent pedidos pelo dono do site | sim |
| Google-Agent | Google | Navegação agêntica (Project Mariner), age em nome do usuário | **não (acionado pelo usuário)** |
| Google-NotebookLM | Google | Busca URLs de fonte adicionadas pelo usuário | **não (acionado pelo usuário)** |
| Google Messages | Google | Busca acionada pelo usuário | **não (acionado pelo usuário)** |
| Applebot-Extended | Apple | **Só opt-out de dados de treino da Apple Intelligence / IA generativa** (NÃO é Siri, Spotlight nem a busca do Safari; não rastreia sozinho, rotula conteúdo já buscado pelo Applebot) | sim |

Fontes: [OpenAI crawlers](https://platform.openai.com/docs/bots),
[Google crawlers overview](https://developers.google.com/search/docs/crawling-indexing/overview-google-crawlers),
[artigo de suporte da Anthropic sobre crawlers](https://support.anthropic.com/en/articles/8896518-does-anthropic-crawl-data-from-the-web-and-how-can-site-owners-block-the-crawler),
[artigo de suporte da Apple sobre o Applebot-Extended](https://support.apple.com/en-us/119829).
O artigo atual da Anthropic documenta só ClaudeBot, Claude-User e
Claude-SearchBot; não lista `anthropic-ai`, então a linha `anthropic-ai`, antes
não verificada, foi removida em vez de mantida como chute.

**Recomendação:** permita OAI-SearchBot, Claude-SearchBot e PerplexityBot para
visibilidade em busca por IA. GPTBot, ClaudeBot, CCBot e Applebot-Extended são
sinais só de treino — permita ou bloqueie por preferência de licenciamento, não
por visibilidade em busca.

### Confira o bot certo para a afirmação que você faz

Dois pares são confundidos com frequência. **Cada afirmação abaixo só pode ser
sustentada pelo status no robots.txt do próprio bot** — verifique e relate
cada um separadamente.

| Afirmação que você quer fazer | Bot a verificar | Bot que NÃO sustenta esta afirmação |
|---|---|---|
| "O conteúdo é citável no ChatGPT Search" | `OAI-SearchBot` | `GPTBot` |
| "O conteúdo está disponível para treino de modelos da OpenAI" | `GPTBot` | `OAI-SearchBot` |
| "O conteúdo pode ser usado em treino e grounding do Gemini/Vertex" | `Google-Extended` | `Googlebot` |
| "O conteúdo é elegível à Busca do Google / AI Overviews" | `Googlebot` | `Google-Extended` |
| "O conteúdo é citável nos recursos de busca do Claude" | `Claude-SearchBot` | `ClaudeBot` |
| "O conteúdo está disponível para treino de modelos da Anthropic" | `ClaudeBot` | `Claude-SearchBot` |
| "O conteúdo pode ser usado no treino da Apple Intelligence" | `Applebot-Extended` | `Applebot` |
| "O conteúdo é encontrável via Siri, Spotlight ou busca do Safari" | `Applebot` | `Applebot-Extended` |

- **`Google-Extended` governa só o uso em treino e grounding do Gemini e do
  Vertex AI. Não afeta a inclusão na Busca comum do Google, nem no AI Overviews e
  no AI Mode, ambos servidos pelo índice do `Googlebot`.** Nunca pontue
  `Google-Extended` como sinal de "prontidão para a Busca do Google" e nunca cite
  um `Google-Extended` bloqueado como evidência de que o site sumiu da Busca.
- **`OAI-SearchBot` é o crawler que determina a citabilidade no ChatGPT Search.
  `GPTBot` é o crawler de treino, separado, da OpenAI.** Checar o acesso do
  `GPTBot` não diz nada sobre se o ChatGPT Search pode citar a página. Um site que
  bloqueia `GPTBot` e permite `OAI-SearchBot` é totalmente citável no ChatGPT Search.
- **`Claude-SearchBot` é o crawler que determina a citabilidade nos recursos de
  busca do próprio Claude. `ClaudeBot` é o crawler de treino, separado, da
  Anthropic** (conforme o artigo de suporte da Anthropic). Checar o `ClaudeBot`
  não diz nada sobre citabilidade na busca do Claude, e vice-versa; relate cada um.
- **`Applebot-Extended` é um sinal de opt-out de dados de treino, não um crawler
  que busca páginas.** Pelo artigo de suporte da Apple, bloquear
  `Applebot-Extended` tira o site do treino da Apple Intelligence / modelos
  generativos, mas a página continua encontrável via Siri, Spotlight e Safari
  enquanto o `Applebot` estiver permitido. Nunca cite um `Applebot-Extended`
  bloqueado como evidência de que o site sumiu das superfícies de busca da Apple.

Não use esses nomes como sinônimos no texto do relatório. Ao relatar acesso de
crawler, nomeie o user-agent exato verificado e a capacidade específica que ele governa.

> **Fetchers acionados pelo usuário ignoram o robots.txt por design** (Google-Agent, Google-NotebookLM, Google Messages, ChatGPT-User). O robots.txt não os bloqueia — use controle de acesso no servidor. A referência canônica de rastreio/robots do Google mudou para **developers.google.com/crawling** (migrada em 2025-11-20); os arquivos de faixas de IP agora ficam em `/crawling/ipranges/` e `googlebot.json` foi renomeado para `common-crawlers.json`. Emergente: **Web Bot Auth** (RFC 9421) permite que bots se autentiquem via header `Signature-Agent` + diretório de chaves (usado pelo Google-Agent); a verificação por DNS reverso continua como alternativa.

---

## Padrão llms.txt

Leia `references/llmstxt-evidence.md` para a evidência primária (Mueller, Illyes, estudo da SE Ranking com 300 mil domínios, auditoria de logs de servidor da OtterlyAI) de por que o `/llms.txt` hoje não é alavanca de citação nos grandes sistemas de busca por IA. O claude-seo relata a presença, mas não atribui peso de ranqueamento de citação.

> **O Google agora diz isso explicitamente.** O guia de otimização para IA do
> Google, lançado em 2026-05-15 e esclarecido em 2026-06-15, diz que `llms.txt` e
> outros arquivos de texto "para IA" não são necessários para a Busca do Google e
> não ajudam nem prejudicam visibilidade ou ranking. Podem servir a sistemas que
> não são do Google. Nunca recomende `llms.txt` como alavanca de ranking ou de
> citação no Google. Fonte:
> developers.google.com/search/docs/fundamentals/ai-optimization-guide

O padrão emergente **llms.txt** dá aos crawlers de IA uma orientação estruturada de conteúdo.

**Local:** `/llms.txt` (raiz do domínio)

**Formato:**
```
# Title of site
> Brief description

## Main sections
- [Page title](url): Description
- [Another page](url): Description

## Optional: Key facts
- Fact 1
- Fact 2
```

**Verifique:**
- Presença do `/llms.txt`
- Orientação estruturada de conteúdo
- Destaque das páginas-chave
- Informações de contato/autoridade

---

## RSL 1.0 (Really Simple Licensing)

Padrão novo (dezembro de 2025) para termos de licenciamento de IA legíveis por máquina.

**Apoiado por:** Reddit, Yahoo, Medium, Quora, Cloudflare, Akamai, Creative Commons

**Verifique:** implementação do RSL e termos de licenciamento adequados.

---

## Otimização por plataforma

| Plataforma | Principais fontes de citação | Foco da otimização |
|----------|---------------------|-------------------|
| **Google AI Overviews** | Fortemente correlacionado ao ranking; cita páginas que já ranqueiam bem | SEO tradicional + otimização de passagem |
| **Google AI Mode** (versão customizada do Gemini 2.5) | Fracamente correlacionado ao ranking; conjunto mais amplo (~9 domínios citados por consulta, Ahrefs) | Superfície distinta: recência, autoridade da entidade, passagens citáveis além da posição 5 |
| **ChatGPT** | Wikipedia (47,9%), Reddit (11,3%) | Presença da entidade, fontes de autoridade |
| **Perplexity** | Reddit (46,7%), Wikipedia | Validação da comunidade, discussões |
| **Bing Copilot** | Índice do Bing, sites de autoridade | SEO para Bing, IndexNow |

> **Dois motores de citação do Google, não um.** AI Mode e AI Overviews chegam à
> mesma conclusão ~86% das vezes, mas citam as mesmas URLs só **13,7%** das vezes
> (estudo da Ahrefs, 540 mil pares de consultas). Trate-os como superfícies
> separadas: ranquear bem na Busca clássica alimenta o AI Overviews, mas o AI Mode
> puxa de um conjunto mais amplo, em que recência e autoridade da entidade pesam
> mais que a posição. Pontue os dois.
>
> **O AI Mode também é superfície de reserva (2026-08-27).** Acompanhamento de
> preço de voo com alerta por e-mail (180+ países e territórios), reserva de hotel
> por parceiros integrados e tarifas em pontos ou milhas agora acontecem dentro do
> AI Mode. Clientes de viagem e hotelaria devem checar elegibilidade de parceiro;
> nada disso é mudança de ranking documentada.
>
> **A experiência está unificada; as superfícies continuam distintas.** No Google
> I/O 2026 (2026-05-19) o Google juntou AI Overviews e AI Mode numa "experiência
> única de busca com IA" (pergunta → AI Overview → continuação no AI Mode) com uma
> nova caixa de busca inteligente. A *experiência* é um fluxo só, mas os dois
> motores de citação seguem tecnicamente distintos (modelos e conjuntos de links
> diferentes) — continue pontuando os dois.

### Superfícies e controles de citação na busca por IA (2026)

O Google adicionou várias superfícies de citação/fonte no AI Overviews **e** no AI Mode (maio de 2026):

- **Preferred Sources** — um domínio ou subdomínio elegível pode ser escolhido
  pelo usuário, o que aumenta a chance de o conteúdo aparecer nas Top Stories
  dele e o torna elegível a um selo de preferido no AI Mode ou no AI Overviews.
  É uma **preferência por usuário**, não um sinal geral de ranking documentado.
  O publisher pode oferecer o botão interativo do Google ou um deeplink, mas não
  deve prometer ganho de ranking no site inteiro. Fonte:
  developers.google.com/search/docs/appearance/preferred-sources
- **Selos "Highly Cited"** — conquistados com reportagem primária original que outros artigos citam.
- **Community Perspectives** — destaca Reddit/fóruns/conteúdo em primeira mão.
- Links inline, **Link Previews** ao passar o mouse no desktop e carrosséis de links em destaque.

**Controlar a aparição em recursos de IA:** **não existe arquivo de opt-out específico para IA**. A aparição no AI Overviews e no AI Mode é governada pelas diretivas padrão de prévia/índice — `nosnippet`, `data-nosnippet`, `max-snippet`, `noindex` (distintas dos controles de robots para crawlers de IA de terceiros acima). Fonte: developers.google.com/search/docs/appearance/ai-features

**Agentes de busca (já no ar, não só WebMCP):** os "Information Agents" do Google rodam em segundo plano monitorando temas, além de reserva/ligação agêntica em categorias selecionadas (em liberação para usuários dos EUA, verão de 2026). Por isso otimizar a página para agentes (elementos interativos reais, árvore de acessibilidade, estabilidade de layout) agora importa para ações, não só para citações.

---

## Medir visibilidade real

A auditoria acima diz se a página **pode** ser citada. Esta seção mede se ela **é** citada. NUT executa o painel; os números resultantes (taxas) entram na ficha da SESHAT (`seo-google`) com `#id` e o comando ou registro que reproduz a medição. MAAT (`seo-qa`) reprova qualquer taxa apresentada sem n.

**1. Painel de prompts.** Monte de 10 a 20 perguntas, distribuídas por estágio de consciência (problema → solução → comparação → compra). Entram só as que mexem em receita: pergunta de glossário raramente vende. Variantes de redação da mesma intenção viram uma pergunta só. Rode cada pergunta de 3 a 5 vezes por plataforma (AI Overviews, ChatGPT, Perplexity, Copilot), porque a resposta não é determinística — uma rodada única é anedota. Registre sempre a **taxa com n**: "citada 3/5, n=5", nunca "aparece". Guarde data, plataforma, modo (com/sem busca), pergunta e trecho da resposta.

**2. Escada de visibilidade.** Para cada pergunta, classifique o degrau alcançado:

| Degrau | O que significa |
|---|---|
| Recuperado | A página entrou nas fontes consultadas |
| Citado | A página aparece como link/fonte da resposta |
| Mencionado | A marca é nomeada no texto da resposta |
| Recomendado | A marca entra na lista curta que a resposta indica |

Citação não é recomendação: ser citado mostra que o conteúdo foi útil para consultar; entrar na lista curta depende do consenso fora do site (avaliações, fóruns, imprensa). Duas métricas saem daqui: **taxa de recomendação** (respostas que recomendam a marca ÷ respostas do painel) e **participação de voz em IA** (menções da marca ÷ menções de todas as marcas do segmento no mesmo painel). Ambas com n.

**3. Laço de correção.**
- A IA afirma algo errado ou vago sobre a marca (preço, recurso, limite) → a página dona daquele fato não o diz com clareza; corrija **primeiro essa página** (via squad sites) e meça de novo na rodada seguinte.
- A marca está ausente → as fontes que a IA cita para aquela pergunta viram a **lista-alvo de menções**; passe para `seo-backlinks` (ANUBIS) e para a squad brand. NUT não faz outreach.

**4. Query fan-out.** A busca por IA desdobra uma pergunta em várias consultas derivadas e sintetiza a resposta. Para cada tema do painel, liste as 5 a 10 consultas derivadas prováveis e confira se existe **uma página dona por família de fatos**. A cobertura do cluster é do HEKA (`seo-cluster`); NUT só aponta a lacuna.

**5. O que NÃO fazer.**
- Não escrever conteúdo separado "para IA": risco de enquadramento como *scaled content abuse* nas políticas de spam do Google, além de duplicar fatos.
- Não picotar a página em fragmentos para "caber" na citação — o próprio guia do Google rejeita o chunking (ver `references/google-ai-optimization-guide.md`). Passagem citável se faz com bom texto, não com página fatiada.

**Ferramenta.** O painel manual é o padrão e basta. Se o DataForSEO estiver disponível (ver "Integração com DataForSEO" abaixo), use-o para ampliar o n, mantendo o mesmo registro por pergunta.

---

## Saída

Gere `GEO-ANALYSIS.md` com:

1. **Pontuação de prontidão GEO: XX/100**
2. **Detalhamento por plataforma** (notas de Google AIO, ChatGPT, Perplexity)
3. **Status de acesso de crawlers de IA** — relate cada crawler separadamente,
   com a capacidade que ele governa. Acesso para treino (`GPTBot`,
   `Google-Extended`, `CCBot`, `ClaudeBot`, `Applebot-Extended`) e citabilidade
   em busca (`OAI-SearchBot`, `Googlebot`, `PerplexityBot`, `Claude-SearchBot`,
   `Applebot`) são achados distintos e nunca podem virar uma linha só.
4. **Status do llms.txt** (presente, ausente, recomendações)
5. **Análise de menções de marca** (presença em Wikipedia, Reddit, YouTube, LinkedIn)
6. **Citabilidade por passagem** (blocos ótimos de 134–167 palavras identificados)
7. **Checagem de renderização no servidor** (análise de dependência de JavaScript)
8. **Painel de prompts: taxa por plataforma com n** (degrau da escada, taxa de recomendação, participação de voz; `#id` da ficha da SESHAT)
9. **Top 5 mudanças de maior impacto**
10. **Recomendações de schema** (para descoberta por IA)
11. **Sugestões de reformatação de conteúdo** (passagens específicas a reescrever)

---

## Ganhos rápidos

1. Adicionar a definição "O que é [tema]?" nas primeiras 60 palavras
2. Criar blocos de resposta autocontidos de 134–167 palavras
3. Adicionar títulos H2/H3 em forma de pergunta
4. Incluir estatísticas específicas com fonte
5. Adicionar datas de publicação/atualização
6. Implementar schema Person para autores
7. Permitir os crawlers de IA-chave no robots.txt

## Esforço médio

1. Criar o arquivo `/llms.txt` (opcional: ignorado pela Busca do Google; pode ajudar outros crawlers de IA)
2. Adicionar bio do autor com credenciais + links para Wikipedia/LinkedIn
3. Garantir renderização no servidor do conteúdo-chave
4. Construir presença da entidade no Reddit e no YouTube
5. Adicionar tabelas comparativas com dados
6. Implementar seções de FAQ (estruturadas; sem schema em sites comerciais)

## Alto impacto

1. Criar pesquisa/levantamento original (citabilidade única)
2. Construir presença na Wikipedia para a marca/pessoas-chave
3. Criar canal no YouTube com menções de conteúdo
4. Implementar ligação de entidades completa (sameAs entre plataformas)
5. Desenvolver ferramentas ou calculadoras únicas

## Integração com DataForSEO (opcional)

Se as ferramentas MCP do DataForSEO estiverem disponíveis, use `ai_optimization_chat_gpt_scraper` para checar o que a busca do ChatGPT retorna para as consultas-alvo (checagem real de visibilidade GEO) e `ai_opt_llm_ment_search` com `ai_opt_llm_ment_top_domains` para acompanhar menções em LLMs nas plataformas de IA.

## Tratamento de erros

| Cenário | Ação |
|----------|--------|
| URL inacessível (falha de DNS, conexão recusada) | Relate o erro com clareza. Não adivinhe o conteúdo do site. Sugira ao usuário conferir a URL e tentar de novo. |
| Crawlers de IA bloqueados no robots.txt | Relate exatamente quais crawlers estão bloqueados e quais estão permitidos. Forneça as diretivas de robots.txt a adicionar para habilitar a visibilidade em busca por IA. |
| llms.txt não encontrado | Registre a ausência (arquivo opcional; a Busca do Google o ignora) e forneça um modelo pronto de llms.txt para crawlers de IA que não são do Google. |
| Nenhum dado estruturado detectado | Relate a lacuna e dê recomendações de schema específicas (Article, Organization, Person) para melhorar a descoberta por IA. |

## Integração com o framework FLOW

Para otimização de conteúdo para IA guiada por prompts, use `/seo flow optimize <url>`: os 21 prompts do estágio optimize do FLOW complementam a análise de citabilidade e estrutura do GEO com prompts de IA baseados em evidência.
