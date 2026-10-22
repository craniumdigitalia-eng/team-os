# CLS — referência detalhada

Leia quando o campo reprova CLS, o trace registra deslocamentos ou o código muda geometria sem reservar espaço.

Cada deslocamento vale `fração de impacto × fração de distância`; o CLS soma o pior agrupamento (janela de sessão) da visita. Use o nó deslocado **e** o gatilho: quem se moveu costuma ser vítima de algo inserido acima.

## Reservar espaço de mídia

```html
<!-- ruim -->
<img src="foto.jpg" alt="…">
<iframe src="https://video.exemplo/embed/123" title="Demo"></iframe>

<!-- certo -->
<img src="foto.jpg" alt="…" width="800" height="600">
<div class="quadro-video"><iframe src="https://video.exemplo/embed/123" title="Demo"></iframe></div>
```

```css
.quadro-video { aspect-ratio: 16 / 9; }
.quadro-video iframe { width: 100%; height: 100%; }
```

Anúncios e embeds de tamanho variável: reserve uma altura mínima realista. Placeholder que depois encolhe também desloca.

## Conteúdo dinâmico

Não insira banner, aviso, resumo de validação ou consentimento **acima** do conteúdo visível sem espaço reservado. Prefira sobreposição, inserir fora da área visível ou um contêiner estável que já existe:

```javascript
// ruim
main.prepend(aviso);
// certo: o slot já tem dimensão reservada no CSS
document.querySelector('[data-slot-aviso]').replaceChildren(aviso);
```

Confira se texto traduzido e larguras menores não estouram o slot.

## Fontes

Quando o trace atribui o deslocamento à troca de fonte, use fallback de métrica parecida ajustado:

```css
@font-face {
  font-family: "Marca Fallback";
  src: local("Arial");
  size-adjust: 102%;
  ascent-override: 92%;
  descent-override: 24%;
  line-gap-override: 0%;
}
```

Os valores acima são exemplo — calcule para o seu par de fontes (ferramentas de métrica de fonte, ou `next/font`, que gera o fallback ajustado) e teste com texto real.

## Animar sem layout

Prefira `transform` e `opacity`; `top`, `left`, `width` e `height` disparam layout. Ao trocar, confira que o elemento transformado não cobre conteúdo nem muda a área de clique.

```css
.toast { position: fixed; inset-block-start: 1rem; inset-inline-end: 1rem;
         transform: translateY(-150%); transition: transform 200ms; }
.toast.visivel { transform: translateY(0); }
@media (prefers-reduced-motion: reduce) { .toast { transition: none; } }
```

## Observer da sessão atual (não é distribuição de campo)

```javascript
new PerformanceObserver((lista) => {
  for (const e of lista.getEntries()) {
    if (e.hadRecentInput) continue; // deslocamento após input do usuário não conta
    console.log('Deslocamento', e.value);
    e.sources?.forEach((s) => console.log('Nó', s.node, s.previousRect, s.currentRect));
  }
}).observe({ type: 'layout-shift', buffered: true });
```

## Checklist

- [ ] Imagens e mídia responsiva reservam espaço intrínseco
- [ ] Anúncios, embeds e componentes assíncronos com contêiner estável
- [ ] Banners e mensagens não empurram conteúdo visível
- [ ] Troca de fonte com fallback de métrica ajustada quando causa deslocamento
- [ ] Animações sem trabalho de layout desnecessário
- [ ] Estados e larguras relevantes exercitados, não só a carga inicial
- [ ] Melhora de campo só depois de novas visitas (RUM/CrUX)

Fontes: web.dev "Optimize CLS"; Chrome DevTools "Performance insights"; MDN `size-adjust`.
