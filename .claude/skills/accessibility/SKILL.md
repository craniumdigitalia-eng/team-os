---
name: accessibility
description: "Auditar e melhorar acessibilidade web seguindo WCAG 2.2 — auditoria com evidência (Lighthouse/axe + teclado + leitor de tela) e padrões para Next.js/Tailwind. Use ao \"melhorar acessibilidade\", fazer \"a11y audit\", garantir \"WCAG compliance\", suporte a screen reader, navegação por teclado ou \"tornar acessível\"."
version: "2.0.0-ct"
updated: "2026-10-20"
source: "https://github.com/addyosmani/web-quality-skills"
license: MIT
---

# Acessibilidade (a11y)

Auditar e corrigir acessibilidade com base na WCAG 2.2 e nas auditorias de acessibilidade do Lighthouse. Objetivo: conteúdo utilizável por todo mundo, inclusive pessoas com deficiência. Alvo padrão: **nível AA**.

**Quando usar esta vs. `web-design-guidelines`:** esta audita e corrige acessibilidade contra a WCAG (com evidência de ferramenta e teste manual). Para revisar código de UI contra as guidelines gerais de interface da Vercel (formulários, tipografia, performance, i18n), use `web-design-guidelines`.

**Carregue quando precisar** (não leia tudo de saída):
- `references/A11Y-PATTERNS.md` — exemplos de código por critério (alt, contraste, teclado, foco, alvo, formulários, erros, ARIA, live regions, modal, skip link, arrastar, atalhos de leitor de tela).
- `references/NEXTJS-TAILWIND.md` — padrões e checklist da stack de sites do CT (Next.js App Router + Tailwind + shadcn/ui).
- `references/WCAG.md` — critérios por nível, padrões ARIA comuns, mudanças 2.1 → 2.2, ferramentas.

## Fluxo de auditoria com evidência

Quando houver página renderizada:

1. **Auditoria automática ao vivo.** Rode o Lighthouse (categoria Accessibility) na página. Com Chrome DevTools MCP, use `lighthouse_audit`; em página pública, modo navegação mobile; em fluxo autenticado ou com estado criado pelo usuário, modo snapshot (recarregar perderia o estado).
2. **Localize pelos nós que falharam.** Use os seletores/nós reprovados na auditoria para achar o componente ou template responsável — não varra o repositório inteiro atrás de padrões genéricos.
3. **Inspecione a árvore de acessibilidade renderizada** (nomes, papéis, estados, landmarks, hierarquia de headings) — com Chrome DevTools MCP, `take_snapshot`; ou o `read_page` do navegador embutido. Percorra o fluxo afetado só com teclado.
4. **Corrija na fonte e re-audite:** rode de novo a mesma auditoria e a mesma interação manual, e registre o antes/depois.

Sem ferramentas ao vivo, use a CLI (abaixo) e faça as mesmas checagens manuais. Ferramenta automática pega só uma parte das barreiras: **nota 100 não é conformidade WCAG**, e nota baixa não substitui evidência por achado (componente, critério, nó, correção).

```bash
# Lighthouse — só acessibilidade
npx lighthouse https://example.com --only-categories=accessibility

# axe-core (sem instalar nada global)
npx @axe-core/cli https://example.com
```

## Princípios WCAG: POUR

| Princípio | O que exige |
|-----------|-------------|
| **P**erceivable — perceptível | O conteúdo pode ser percebido por mais de um sentido (alt, legendas, contraste) |
| **O**perable — operável | A interface funciona com teclado, sem armadilhas, com tempo e alvos adequados |
| **U**nderstandable — compreensível | Linguagem, navegação e erros previsíveis e explicados |
| **R**obust — robusto | Funciona com tecnologias assistivas (HTML semântico, ARIA correto) |

Níveis: **A** (mínimo, obrigatório) · **AA** (padrão — exigência legal em muitas jurisdições; é o nosso alvo) · **AAA** (reforçado, desejável).

## O que checar, por princípio

Os exemplos de código de cada item estão em `references/A11Y-PATTERNS.md`.

### Perceptível
- **Texto alternativo (1.1.1):** toda imagem informativa com `alt` descritivo; decorativa com `alt=""` (só isso — `aria-hidden` ou `role="presentation"` junto é redundante); botão só de ícone com nome acessível (`aria-label` ou texto `sr-only`) e o SVG com `aria-hidden="true"`.
- **Contraste (1.4.3):** texto normal ≥ 4,5:1; texto grande (≥ 18px, ou ≥ 14px bold) ≥ 3:1.
- **Contraste de não-texto (1.4.11):** componentes de UI, ícones que carregam sentido e **o indicador de foco** ≥ 3:1 contra o fundo onde aparecem.
- **Não depender só de cor (1.4.1):** erro = cor + ícone + texto.
- **Mídia (1.2):** vídeo com legendas (`<track kind="captions">`); áudio com transcrição.

### Operável
- **Teclado (2.1.1):** tudo funciona com teclado. Prefira elementos nativos (`<button>`, `<a href>`, controles de formulário) — eles já tratam Enter/Espaço, foco e semântica. Só adicione tratamento manual de teclado quando não der para usar elemento nativo (ex.: `div` com `role="button"` precisa de `tabindex="0"` + `keydown` para Enter/Espaço). **Nunca** adicione `keydown` de Enter/Espaço a um `<button>` nativo: ele já dispara `click` com essas teclas, e a ação roda duas vezes.
- **Sem armadilha de teclado (2.1.2):** dá para entrar e sair de todo componente com Tab; foco preso só em modal (o `<dialog>` nativo e o Radix `Dialog` já fazem isso).
- **Foco visível (2.4.7):** nunca `outline: none` sem substituto; use `:focus-visible` com `outline: 2px solid currentColor` (herda a cor do texto, que já passou no contraste) e `outline-offset: 2px`. Cor de marca no foco só se medir ≥ 3:1 contra todo fundo em que ela cair.
- **Skip link (2.4.1)** para pular a navegação repetida.
- **Movimento (2.3):** respeitar `prefers-reduced-motion: reduce`.
- **Tempo (2.2.1):** limite de tempo com aviso e opção de estender.

### Compreensível
- **Idioma (3.1.1):** `lang` no `<html>` (`pt-BR` nos projetos brasileiros); trecho em outro idioma com `lang` próprio.
- **Navegação consistente (3.2.3)** entre páginas, com `aria-current="page"` no item atual.
- **Rótulos (3.3.2):** todo campo com label associado programaticamente.
- **Erros (3.3.1, 3.3.3):** `aria-invalid="true"`, mensagem ligada por `aria-describedby`, anúncio por `role="alert"`/`aria-live`, foco no primeiro erro ao enviar, e sugestão de correção.

### Robusto
- **HTML nativo antes de ARIA (4.1.2):** `<button>` em vez de `<div role="button">`; ARIA só quando o nativo não basta, com papéis e estados corretos (`aria-expanded`, `aria-controls`, `aria-selected`…).
- **Mensagens de status (4.1.3):** mudança dinâmica anunciada por `aria-live`/`role="status"` sem mover o foco.

## ARIA de uso frequente

| Situação | Marcação correta |
|----------|------------------|
| Botão que abre/fecha um painel ou menu de navegação (disclosure) | `aria-expanded` + `aria-controls="id-do-painel"` (sem `aria-haspopup`) |
| Botão que abre um diálogo | `aria-haspopup="dialog"` + `aria-expanded`, e o diálogo com `role="dialog"` `aria-modal="true"` `aria-labelledby` |
| Abas | `role="tablist"` / `tab` (`aria-selected`, `aria-controls`) / `tabpanel` |
| Item atual da navegação | `aria-current="page"` |
| Várias `<nav>` na página | `aria-label` distinto em cada uma |
| Carregando | `aria-busy="true"` na região + anúncio em `role="status"` |

## Critérios novos da WCAG 2.2

- **2.4.11 Foco não encoberto (AA):** elemento focado não pode ficar totalmente escondido por header/footer fixo ou painel — use `scroll-margin-top`/`scroll-margin-bottom`.
- **2.4.12 Foco não encoberto, reforçado (AAA):** nenhuma parte do elemento focado escondida.
- **2.4.13 Aparência do foco (AAA):** indicador com área e contraste mínimos.
- **2.5.7 Movimentos de arrastar (AA):** toda ação de arrastar tem alternativa com um único ponteiro (botões, campo).
- **2.5.8 Tamanho do alvo (AA):** alvo interativo ≥ 24×24 px CSS (recomendado 44×44 em toque); exceções: link em texto corrido, controle nativo do navegador, alvo com espaçamento suficiente.
- **3.2.6 Ajuda consistente (A):** contato, chat, FAQ repetidos entre páginas ficam na mesma ordem relativa.
- **3.3.7 Entrada redundante (A):** não pedir de novo o que o usuário já informou na mesma sessão (preencher automaticamente ou deixar escolher).
- **3.3.8 Autenticação acessível (AA):** login sem teste cognitivo, a menos que haja colar/autopreenchimento, método alternativo (passkey, SSO, link por e-mail) ou reconhecimento de objeto/conteúdo pessoal.
- **4.1.1 Parsing** foi removido na 2.2.

## Next.js/Tailwind — checklist rápido

Padrões completos e exemplos em `references/NEXTJS-TAILWIND.md`.

- [ ] `lang="pt-BR"` (ou o idioma do site) no `<html>` do `app/layout.tsx` raiz
- [ ] Skip link com `sr-only focus:not-sr-only` apontando para `<main id="main-content">`
- [ ] Foco visível global em `:focus-visible` (`outline-2 outline-offset-2 outline-current`), sem `outline-none` solto
- [ ] Interativos acessíveis por teclado — componentes shadcn/Radix já cobrem; não quebrar com wrappers `div onClick`
- [ ] Focus trap só em modal (Radix `Dialog` gerencia sozinho)
- [ ] `next/image` decorativa com `alt=""`; informativa com `alt` descritivo
- [ ] HTML semântico; ARIA só quando o nativo não basta
- [ ] Alvos ≥ 24×24 px (botão de ícone `size="icon"` do shadcn já cumpre)
- [ ] Anúncio de loading/erro com `aria-live` sem roubar foco

## Checagem manual (sempre, além da automática)

- [ ] **Teclado:** percorrer a página com Tab/Shift+Tab, ativar com Enter/Espaço, fechar com Esc
- [ ] **Ordem de foco** lógica e igual à ordem visual; foco nunca escondido por barra fixa
- [ ] **Leitor de tela:** VoiceOver (Mac), NVDA (Windows) ou TalkBack (Android) — atalhos em `references/A11Y-PATTERNS.md#screen-reader-commands`
- [ ] **Zoom 200%** e reflow em 320 px sem perder conteúdo
- [ ] **Alto contraste** (modo de alto contraste do Windows / `forced-colors`)
- [ ] **Movimento reduzido** com `prefers-reduced-motion: reduce`
- [ ] **Alvos** ≥ 24×24 px

## Problemas comuns por impacto

**Crítico (corrigir já):** campo sem label · imagem sem alt · contraste insuficiente · armadilha de teclado · sem indicador de foco.

**Sério (corrigir antes de publicar):** página sem `lang` · hierarquia de headings quebrada · link sem texto descritivo ("clique aqui") · mídia com autoplay · sem skip link.

**Moderado (corrigir em seguida):** ícone sem nome acessível · navegação inconsistente · erro não identificado · tempo limite sem controle · sem landmarks (`header`, `nav`, `main`, `footer`).

## Formato do achado

Para cada problema: **critério WCAG (nº e nível) · componente/arquivo · nó ou seletor que falhou · impacto (crítico/sério/moderado) · correção · evidência da re-auditoria**.

## Referências

- [WCAG 2.2 Quick Reference](https://www.w3.org/WAI/WCAG22/quickref/)
- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- [Regras do axe (Deque)](https://dequeuniversity.com/rules/axe/)
- `references/WCAG.md` · `references/A11Y-PATTERNS.md` · `references/NEXTJS-TAILWIND.md`
