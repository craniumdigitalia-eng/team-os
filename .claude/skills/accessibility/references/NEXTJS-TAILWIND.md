# Acessibilidade em Next.js + Tailwind (stack de sites do CT)

Padrões prontos para Next.js App Router + Tailwind + shadcn/ui, alinhados à WCAG 2.2. Carregue quando a página auditada ou implementada estiver nessa stack. Checklist resumido no [SKILL.md](../SKILL.md#nextjstailwind--checklist-rápido).

---

## Padrões ARIA essenciais (JSX)

```tsx
// Botão que abre/fecha o menu de navegação (disclosure) — não é diálogo,
// então nada de aria-haspopup: aria-expanded + aria-controls bastam
<button aria-expanded={isOpen} aria-controls="menu-principal" onClick={toggle}>
  Menu
</button>
<nav id="menu-principal" aria-label="Principal" hidden={!isOpen}>...</nav>

// Botão que abre um diálogo de verdade
<button aria-haspopup="dialog" aria-expanded={isFiltersOpen} onClick={openFilters}>
  Filtros
</button>

// Diálogo (prefira o Radix Dialog do shadcn, que já faz foco preso, Esc e aria-*)
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <h2 id="modal-title">Título</h2>
</div>

// Várias navs: cada landmark com nome próprio
<nav aria-label="Principal">...</nav>
<nav aria-label="Rodapé">...</nav>

// Imagem decorativa: só alt vazio (aria-hidden junto é redundante)
<Image src="/textura.png" alt="" width={800} height={400} />

// Loading anunciado sem roubar foco (4.1.3)
<div aria-busy={isLoading}>...</div>
<p role="status" className="sr-only">{isLoading ? 'Carregando…' : ''}</p>
```

---

## Idioma no layout raiz (3.1.1)

```tsx
// app/layout.tsx
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
```

---

## Skip link com Tailwind (2.4.1)

```tsx
<a
  href="#main-content"
  className="sr-only focus:not-sr-only focus:fixed focus:top-4 focus:left-4 focus:z-50 focus:px-4 focus:py-2 focus:bg-primary focus:text-primary-foreground"
>
  Pular para o conteúdo
</a>
{/* ... header e navegação ... */}
<main id="main-content" tabIndex={-1}>...</main>
```

`sr-only` do Tailwind substitui a classe `.visually-hidden` manual; `focus:not-sr-only` mostra o link ao receber foco.

---

## Foco visível com Tailwind (2.4.7, 1.4.11)

```css
/* globals.css — anel de foco global só para teclado */
@layer base {
  :focus-visible {
    @apply outline-2 outline-offset-2 outline-current;
  }
}
```

`outline-current` usa `currentColor` (a cor do texto, que já passou no contraste). Se trocar por cor de marca (`outline-primary`), meça ≥ 3:1 contra todo fundo em que o anel aparece. Nunca use `outline-none` sem colocar um substituto `focus-visible:*` no mesmo elemento.

---

## Foco não encoberto com header fixo (2.4.11)

```tsx
// Header sticky de 64px: compense o scroll ao focar ou navegar por âncora
<html lang="pt-BR" className="scroll-pt-20">
```

---

## Checklist para páginas Next.js

- [ ] `lang` definido no `<html>` do `app/layout.tsx` raiz
- [ ] Skip link + `<main id="main-content">`
- [ ] Todos os interativos acessíveis por teclado (componentes shadcn/Radix já cobrem — não quebrar com wrappers `div onClick`)
- [ ] Focus trap só em modal (Radix `Dialog` gerencia sozinho)
- [ ] HTML semântico; ARIA só quando o nativo não basta
- [ ] `next/image` com `alt` descritivo, ou `alt=""` se decorativa
- [ ] Alvos de toque ≥ 24×24 px (2.5.8) — botão de ícone `size="icon"` já cumpre
- [ ] Animações (Framer Motion, CSS) respeitam `prefers-reduced-motion` (`motion-safe:` / `motion-reduce:` no Tailwind, `useReducedMotion` no Framer Motion)

## Teste rápido

1. Navegar a página inteira só com Tab/Enter/Esc
2. Ler com VoiceOver (Mac) ou NVDA (Windows)
3. Rodar `npx lighthouse <url> --only-categories=accessibility` e `npx @axe-core/cli <url>` no build de produção (`next build && next start`), não só no `next dev`
