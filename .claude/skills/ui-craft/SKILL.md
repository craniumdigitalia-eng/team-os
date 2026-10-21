---
name: ui-craft
description: "Ofício de interface sem cara de IA — o brief vence, inventário do assunto e 3 defaults rejeitados antes de desenhar, plano de tokens, registro de ~30 sinais (tell → faça em vez disso), regras tipográficas com número, movimento com propósito e gate visual em 4 larguras com veredicto PASS/CONCERNS/FAIL. Use ao especificar, implementar ou revisar UI de site ou produto."
version: "1.0.0"
updated: "2026-10-20"
license: "Apache-2.0 (partes adaptadas) + MIT — ver Fontes"
---

# UI Craft — interface que parece escolhida, não gerada

Página gerada por IA não é feia: é **intercambiável**. Os mesmos defaults aparecem seja qual for o assunto. Esta skill troca o default por decisão — e prova a decisão com screenshot.

**Fluxo no time:**

| Quem | Faz | Blocos |
|---|---|---|
| `sites-ux` / `dev-ux` | Especifica: modo, inventário, frase-ideia, defaults rejeitados, plano de tokens — tudo na spec | 1–2 |
| `sites-dev-alpha` / `dev-dev-alpha` | Implementa seguindo o plano e as regras com número | 4–5 |
| `sites-qa` / `dev-qa` | Confere o registro de sinais e roda o gate visual | 3 + 6 |

Acessibilidade não se repete aqui: `/accessibility` (WCAG 2.2) e `/web-design-guidelines`. Tiques de **texto** (copy, microcopy, títulos) são da `/copy-humanize`. Sistema visual da marca: `/brand-visual-system` (formato DESIGN.md).

---

## 1. Postura

1. **O brief vence.** Se o brief fixa estética, época, paleta, fonte ou material, siga à risca — mesmo que caia num sinal da tabela. Redirecionar um brief claro para o seu gosto é falha.
2. **Sinal (tell) é default, não proibição.** Todo item do §3 é legítimo para algum brief. Ele só vira problema quando aparece **sem motivo**. Justificou no brief ou na spec ("broadsheet porque é um jornal de bairro") → liberado.
3. **Tirar enfeite não basta.** Página limpa e vazia também é genérica. Cada sinal removido precisa ser trocado por **substância do cliente**: foto real, dado real, nome real, processo real.
4. **Escolha o modo pela superfície, não pelo produto:**
   - **Persuadir** (site, landing, preço, campanha): ousadia com ponto de vista; o design é o produto.
   - **Operar** (app, dashboard, admin, configurações): precisão e contenção; padrão conhecido ganha; a marca vive no detalhe.
   - **Ler** (docs, artigo, ajuda, changelog): estrutura para entender, leitura confortável.
   A landing de uma ferramenta é Persuadir; a documentação de uma grife é Ler.
5. **Gaste a ousadia num lugar só.** Um elemento memorável; o resto quieto e disciplinado. Antes de entregar, tire um acessório.

## 2. Antes de desenhar (vai na spec do UX)

### 2.1 Inventário do assunto
Liste **8–12 coisas que só este cliente tem** e nenhum concorrente: o nome e o que ele significa, endereço e rua, ano de fundação, materiais, ferramentas do ofício, vocabulário da equipe, fotos que existem, números verdadeiros, objetos do dia a dia. Busque no assunto, não na categoria ("padaria" é categoria; "o forno a lenha de 1974 na Rua X" é assunto).

### 2.2 Frase-ideia + teste do concorrente
Escreva uma frase:

> No site, **[coisa do inventário]** vira **[recurso de design]**.

Ex.: "No site, *o caderno de receitas manuscrito da fundadora* vira *a tipografia de destaque e as anotações nas margens*."

**Teste do concorrente:** troque a coisa pelo concorrente mais próximo. Se a frase continua funcionando, a ideia é da categoria, não do cliente — refaça.

### 2.3 Domínio, mundo de cor, assinatura, defaults rejeitados
- **Domínio:** ≥5 conceitos, metáforas e palavras do mundo do produto (território, não features).
- **Mundo de cor:** ≥5 cores que existem *de verdade* nesse mundo (se o produto fosse um lugar físico, o que se veria?). Não "quente" ou "frio".
- **Assinatura:** um elemento (visual, estrutural ou de interação) que só existe para este produto. Sem assinatura nomeada, continue explorando.
- **3 defaults nomeados e REJEITADOS**, visuais e estruturais, cada um com a alternativa:
  `Rejeito: [default] → [alternativa] · [default] → [alternativa] · [default] → [alternativa]`
  Você não evita um padrão que não nomeou.

### 2.4 Plano de tokens (antes do código)
- **Cor:** 4–6 cores nomeadas com hex e papel (fundo, tinta, acento, apoio, estado).
- **Tipografia:** famílias e papéis (display, corpo, dado). Uma família ou duas claramente distintas.
- **Layout:** conceito em 1 frase + **wireframe ASCII** das seções principais; alinhamento (esquerda, centro, justificado).
- **Princípios:** 3 frases sobre o que torna esta página única.

**Revisão do plano contra o brief:** pergunte "outro modelo, com prompt parecido, chegaria aqui?". Se sim em algum item, revise esse item e registre na spec o que mudou e por quê. Só então o código começa.

## 3. Registro de sinais — tell → faça em vez disso

Use como checklist de revisão (QA) e de autocrítica (dev). Sinal **com justificativa no brief/spec** não conta.

| # | Sinal (tell) | Faça em vez disso |
|---|---|---|
| 1 | Gradiente roxo/azul-violeta (mesh, aurora) de fundo | Cor do mundo do cliente (§2.3); superfície chapada com textura real ou foto |
| 2 | Texto com gradiente | Ênfase por peso ou tamanho |
| 3 | Glass/blur como decoração | Superfície sólida; blur só onde tem função (overlay sobre mídia) |
| 4 | Glow / halo colorido sem deslocamento | Sombra com offset e desfoque suave, ou nenhuma |
| 5 | Eyebrow/pill em CAIXA ALTA espaçada acima do H1 | Apague; o título carrega o próprio peso |
| 6 | Uma palavra do título em itálico ou outra cor | Título inteiro forte; destaque pela frase, não pelo estilo |
| 7 | Rótulos em caixa alta em tudo | Caixa de frase; caixa alta só onde há convenção (siglas, tabelas densas) |
| 8 | Fundo creme (~#F4F1EA) + serifa de alto contraste + acento terracota (~#D97757) | Paleta do mundo de cor do cliente |
| 9 | Fundo quase-preto + um único acento neon (verde-ácido, vermelhão) | Escolha claro/escuro pela cena de uso (quem, onde, que luz) |
| 10 | Broadsheet: filetes finos, raio zero, colunas de jornal | Grid derivado do conteúdo real |
| 11 | Três cards iguais com ícone + título + texto como estrutura da página | Variar forma pelo conteúdo: lista, tabela, foto grande, depoimento real |
| 12 | Card dentro de card | Um nível de contêiner; hierarquia por espaço e tipo |
| 13 | Um raio de borda em tudo | Raio por hierarquia; aninhado = concêntrico (§5) |
| 14 | A mesma sombra cinza suave (rgba(0,0,0,.1)) em todo card | Sombra só para elevação real; estrutura com borda ou espaço |
| 15 | Hero de métrica: número grande, rótulo pequeno, stats e acento | Abrir com a coisa mais característica do assunto (foto, demo, objeto) |
| 16 | Emoji ou glifo Unicode como ícone | Biblioteca de ícones ou SVG próprio, um traço e um peso |
| 17 | Inter (ou a fonte do sistema) em tudo | Fonte escolhida pelo caráter do assunto, auto-hospedada |
| 18 | Monoespaçada como fantasia de "tech" | Mono só para código, dado ou medida |
| 19 | Numeração 01 / 02 / 03 sem sequência real | Números só em passo a passo ou linha do tempo |
| 20 | Métrica, logo de cliente ou depoimento inventado | Só dado com fonte; sem dado, sem bloco (placeholder marcado) |
| 21 | Borda lateral colorida >1px em card, alerta ou callout | Ícone + título, fundo tingido ou nada |
| 22 | Sombra dura deslocada (4px 4px 0) fora de um mundo neobrutalista | Sombra coerente com o sistema |
| 23 | Strings com ponto médio (A · B · C) e "PALAVRA — fragmento" | Frase normal ou lista |
| 24 | "→" colado em todo link e botão | Verbo claro no botão; seta só onde indica direção real |
| 25 | `hover:scale-105` (ou `-translate-y-1` + sombra) em todo card | Hover só em elemento clicável, sutil e coerente |
| 26 | Carrossel automático sem pausa | Conteúdo estático ou carrossel manual com pausa e controle |
| 27 | Cursor follower / cursor customizado | Cursor nativo |
| 28 | Fade-up em toda seção ao rolar | Um momento de entrada orquestrado; o resto já visível |
| 29 | Sparklines, anéis de progresso e retângulos arredondados no lugar de conteúdo | Conteúdo real ou espaço vazio honesto |
| 30 | Máscara geométrica imitando recorte de foto | Recorte real (alpha) do asset ou nenhum |
| 31 | Seleção, caret, scrollbar e foco no padrão do navegador | Temar pela paleta (§4) |

**Tells de copy** (frases de efeito vazias, tríades, "não é só X, é Y", travessões em série, CTA genérico) → `/copy-humanize`. O ui-craft não revisa texto.

## 4. Regras com número

| Regra | Valor |
|---|---|
| Tamanhos de fonte na página | **≤ 5** |
| Tracking de display | **−0,02 a −0,05 em** (mais negativo quanto maior; piso −0,05) |
| Corpo | **16–20 px**, entrelinha **1,45–1,6**, linha **45–75 caracteres** |
| H1 | **≤ 2 linhas** em todas as larguras do §6 |
| Espaço entre seções | **maior** que qualquer espaço interno de seção; mais espaço acima do título que abaixo |
| Cor | **um fundo, uma tinta, um acento** (estados e neutros derivados deles) |
| Quebra de texto | `text-wrap: balance` em títulos, `text-wrap: pretty` em parágrafos |
| Números que mudam ou se alinham | `font-variant-numeric: tabular-nums` |
| Contraste | **≥ 4,5:1** texto normal, **≥ 3:1** texto grande (medir, não estimar) |
| Superfícies do navegador | temar `::selection`, `caret-color`, scrollbar, anel de foco e `text-underline-offset` pela paleta |
| Hierarquia | tamanho + peso + cor juntos; 4 níveis de texto (principal, apoio, meta, desabilitado) |

## 5. Movimento e microinteração

**Antes de animar, preencha o quadro** (na spec ou no PR):

| Frequência de uso | Decisão |
|---|---|
| 100+ vezes/dia (atalho, paleta de comando) | Sem animação |
| Dezenas/dia (hover, navegação em lista) | Quase imperceptível ou nada |
| Ocasional (modal, drawer, toast) | Animação padrão |
| Rara / primeira vez (onboarding, sucesso) | Aqui mora o encanto |

**Propósito** (um): feedback · consistência espacial · indicar estado · evitar salto · explicar · encanto (só no nível raro). Sem propósito nomeado, não anima.

| Elemento | Duração | Easing |
|---|---|---|
| Feedback de toque/clique | 100–160 ms | ease-out |
| Tooltip, popover pequeno | 125–200 ms | ease-out |
| Dropdown, select | 150–250 ms | ease-out |
| Modal, drawer | 200–500 ms | ease-out (saída mais suave que entrada) |
| Movimento na tela | — | ease-in-out forte |

Regras:
- **Nunca `ease-in` em UI** (atrasa o instante que o usuário está olhando). Feedback de UI responde em **< 300 ms**.
- **Raio concêntrico:** raio externo = raio interno + padding.
- **Botão ao pressionar:** `scale(0.96)`; nunca `scale(0)` como entrada.
- **Área de toque ≥ 44 px**, mesmo com ícone menor (estenda com padding ou pseudo-elemento).
- **Sem `transition: all`** — liste as propriedades.
- Motion/Framer: `initial={false}` em elementos que já estão na tela no primeiro render (sem animar a carga).
- **Anime só `transform` e `opacity`**; nunca `width`, `height`, `top`, `left`, `margin`, `padding`.
- **Pause loops fora da tela** (IntersectionObserver) e evite animar imagens grandes ou a tela inteira.
- **UM momento de assinatura por página** (uma sequência de entrada ou um reveal); o resto entra já visível.
- Transições de estado interativo em CSS (interrompíveis); keyframes só para sequência única. Stagger 30–100 ms só em entrada rara.
- **Curva própria vira token** do design system (`--ease-out`, `--ease-in-out`), nunca número solto no componente.
- **`prefers-reduced-motion` é obrigatório** — ver a Regra zero de `/sites-scroll-motion`.

## 6. Gate visual (QA)

1. **Screenshots em 320, 390, 768 e 1440 px** de largura, com conteúdo real: pelo navegador embutido do Claude Code (redimensionar e capturar) ou `npx playwright screenshot --viewport-size=390,844 <url> 390.png` (uma por largura).
2. **Teste da troca (swap):** troque mentalmente a fonte pela de sempre e o layout por um template padrão. Onde nada mudaria, houve default.
3. **Teste do borrão (squint):** desfoque o olhar. A hierarquia (o que está acima, onde a seção divide) continua legível e nada salta de forma bruta?
4. **Teste da assinatura:** aponte 5 lugares específicos onde a assinatura do §2.3 aparece. "A sensação geral" não conta.
5. Percorra o §3 e o §4 contra as capturas e o código.

Achados em tabela:

| Severidade | Local | Antes | Depois | Por quê |
|---|---|---|---|---|
| CRITICAL / HIGH / MEDIUM / LOW | seção · largura · arquivo:linha | o que está | o que deve ficar | sinal nº ou regra violada |

**Veredicto:**
- **FAIL** — métrica, logo ou depoimento inventado (#20); gradiente roxo/azul-violeta sem pedido no brief (#1); H1 que estoura ou texto ilegível em alguma das 4 larguras; contraste abaixo do §4.
- **CONCERNS** — qualquer sinal do §3 sem justificativa no brief/spec; regra do §4 ou §5 violada sem motivo.
- **PASS** — nenhum dos anteriores, capturas anexadas e assinatura apontada.

Acessibilidade completa (teclado, leitor de tela, ARIA) segue em `/accessibility`; checklist de interface em `/web-design-guidelines`.

---

## Fontes

Conteúdo adaptado e traduzido para pt-BR, **com modificações** (reorganizado, resumido e integrado ao fluxo das squads do CT):

- **§1 Postura** — brief vence e sinal como default liberado por justificativa: `anthropics/skills` frontend-design (Apache-2.0) e `pbakaus/impeccable` (Apache-2.0); "preencher com substância": `Leonxlnx/taste-skill` (MIT); modos Persuadir/Operar/Ler: impeccable.
- **§2 Antes de desenhar** — inventário 8–12 e frase-ideia com teste do concorrente: taste-skill; domínio, mundo de cor, assinatura e defaults rejeitados: `Dammyjay93/interface-design` (MIT); plano de tokens, wireframe ASCII e revisão contra o brief: anthropic frontend-design.
- **§3 Registro de sinais** — anthropic frontend-design (perfis creme/terracota, preto/neon, broadsheet, kit de cards, cromo de template), impeccable craft-floor (eyebrow, texto com gradiente, glass, borda lateral, sombra dura, mono, emoji), taste-skill e `Nutlope/hallmark` (MIT) para os demais.
- **§4 Regras com número** — impeccable craft-floor (contraste, superfícies do navegador, medida), `jakubkrehel/make-interfaces-feel-better` (MIT; text-wrap, tabular-nums), interface-design (hierarquia em 3 alavancas).
- **§5 Movimento** — `emilkowalski/skills` animate (MIT; frequência, propósito, durações, nunca ease-in); make-interfaces-feel-better (raio concêntrico, scale 0.96, área de toque, sem transition-all, `initial={false}`); `ibelick/ui-skills` baseline-ui (MIT; só transform/opacity, pausar loops); momento único: anthropic frontend-design.
- **§6 Gate visual** — testes swap/squint/assinatura: interface-design; batch de capturas: impeccable.

Licenças completas e avisos em `THIRD_PARTY_NOTICES.md`.
