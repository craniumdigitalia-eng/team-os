# LCP — referência detalhada

Leia quando o campo reprova LCP ou o trace aponta descoberta, carga ou renderização do elemento LCP.

## Candidatos a elemento LCP

`<img>`, `<image>` dentro de `<svg>`, pôster de `<video>`, elemento com `background-image: url(...)` e bloco de texto. Identifique na sessão atual (não é dado de campo):

```javascript
new PerformanceObserver((lista) => {
  const ultimo = lista.getEntries().at(-1);
  console.log('LCP', {
    elemento: ultimo.element, tempo: ultimo.startTime,
    url: ultimo.url, renderTime: ultimo.renderTime, loadTime: ultimo.loadTime,
  });
}).observe({ type: 'largest-contentful-paint', buffered: true });
```

## Subparte → evidência → correção

| Subparte dominante | Evidência no trace | Correção |
|---|---|---|
| TTFB | Insight de latência do documento; TTFB > ~800 ms | Cache/CDN, `Cache-Control: s-maxage=60, stale-while-revalidate=300`, menos redirects, consulta do servidor mais rápida, evitar cold start |
| Atraso de carga | Recurso LCP pedido tarde (insight de descoberta do LCP) | Pôr no HTML inicial, `fetchpriority="high"`; `preload` só se ainda for tarde |
| Tempo de carga | Download e bytes dominam | Redimensionar, comprimir, AVIF/WebP, `srcset`/`sizes` |
| Atraso de renderização | Insight de recursos bloqueantes; elemento ausente do HTML inicial | CSS crítico, `defer`, SSR/SSG/streaming |

## Imagem

```html
<!-- preload só quando o trace mostra descoberta tardia (ex.: imagem de fundo em CSS) -->
<link rel="preload" as="image" href="/hero-800.webp"
      imagesrcset="/hero-400.webp 400w, /hero-800.webp 800w" imagesizes="100vw"
      fetchpriority="high">

<picture>
  <source srcset="/hero.avif" type="image/avif">
  <source srcset="/hero.webp" type="image/webp">
  <img src="/hero.jpg" width="1200" height="600" fetchpriority="high" alt="…">
</picture>
```

Preload duplicado ou especulativo disputa banda com o que importa. Nunca `loading="lazy"` no elemento LCP.

## Fonte (LCP de texto)

```css
@font-face {
  font-family: 'Titulo';
  src: url('/fonts/titulo.woff2') format('woff2');
  font-display: swap; /* mostra o fallback na hora */
}
```

## CSS e JS bloqueantes

```html
<head>
  <style>/* só o CSS acima da dobra, comprovadamente crítico */</style>
  <link rel="preload" href="/styles.css" as="style"
        onload="this.onload=null;this.rel='stylesheet'">
  <script defer src="/app.js"></script>        <!-- não bloqueia o parse -->
  <script type="module" src="/app.mjs"></script> <!-- module já é deferido -->
</head>
```

Antes de inlinar CSS, prefira remover regras não usadas e separar o não crítico.

## LCP montado no cliente

Se o conteúdo do hero chega por `fetch` num efeito do cliente, o LCP espera o JS baixar, rodar e buscar. Renderize no servidor (SSR), estático (SSG/ISR) ou com streaming (`<Suspense>` com fallback do tamanho final). O como-fazer por framework: Next/React em `/nextjs-react-best-practices`; Nuxt (`<NuxtImg preload loading="eager">`) e Astro (`<Image loading="eager">` de `astro:assets`) seguem o mesmo princípio.

## Speculation Rules (próxima navegação)

Para jornadas previsíveis na mesma origem, pré-renderizar a próxima página deixa a navegação seguinte quase instantânea. Não substitui corrigir o LCP da página atual.

```html
<script type="speculationrules">
{ "prerender": [{ "where": { "href_matches": "/*" }, "eagerness": "moderate" }] }
</script>
```

| `eagerness` | Dispara em |
|---|---|
| `conservative` | Pointer/touch down |
| `moderate` | Desktop: ~200 ms de hover; mobile: heurística de viewport |
| `eager` | Mais cedo que `moderate` (hover curto / link entrando na tela) |
| `immediate` | Assim que a regra é lida |

Comece conservador e meça acerto da previsão, bytes transferidos e carga do servidor. Confira a documentação atual do Chrome antes de fixar tempos. Cuidados:
- Cada prerender ≈ uma carga inteira: restrinja `where` e **exclua** logout, checkout e ações com efeito.
- Analytics, anúncios e qualquer código de carga disparam no início do prerender — condicione a `document.prerendering` / evento `prerenderingchange`.
- Só Chromium; Safari e Firefox ignoram (melhoria progressiva, sem regressão).

## Checklist

- [ ] Elemento LCP identificado e presente no HTML inicial
- [ ] Subparte dominante medida antes e depois
- [ ] Recurso LCP com prioridade; preload apenas se provado necessário
- [ ] Imagem no tamanho e formato certos; sem lazy no LCP
- [ ] Nada de CSS/JS bloqueante desnecessário no `<head>`
- [ ] Fonte não bloqueia texto

Fontes: web.dev "Optimize LCP"; Chrome for Developers "Prerender pages".
