# Navegação do deck na tela (HTML para apresentar)

O mesmo HTML que vira PDF (§6 da SKILL) serve para apresentar no navegador em tela cheia. Na tela, mostra um slide por vez com teclado, clique e barra de progresso; na impressão, todas as `.page` saem em sequência, sem controles. **Nada de CDN**: sem `<script src="https://...">`, sem fonte remota, sem imagem de banco de imagens por URL — o arquivo abre e exporta sem rede.

## CSS (acrescentar ao `print.css` embutido)

```css
/* Tela: um slide por vez, letterbox 16:9 */
@media screen {
  html, body { height: 100%; overflow: hidden; background: #111; }
  .page { display: none; position: absolute; inset: 0; margin: auto;
          width: min(100vw, calc(100vh * 16 / 9)); height: min(100vh, calc(100vw * 9 / 16)); }
  .page.is-active { display: block; }
  .deck-progress { position: fixed; top: 0; left: 0; height: 3px; background: var(--color-primary, currentColor); z-index: 10; }
  .deck-counter { position: fixed; bottom: 12px; right: 16px; font-size: 13px; opacity: .6; z-index: 10; }
}
/* Impressão: todas as páginas, sem controles */
@media print {
  .page { display: block !important; }
  .deck-progress, .deck-counter { display: none !important; }
}
```

Os tokens (`--color-primary` etc.) vêm do design system do projeto, colados no `<style>`; não há passo de geração de tokens.

## HTML de controle (antes de `</body>`)

```html
<div class="deck-progress" id="deckProgress"></div>
<div class="deck-counter"><span id="deckCurrent">1</span> / <span id="deckTotal"></span></div>
```

## Script (inline, sem dependência)

```html
<script>
(() => {
  const pages = [...document.querySelectorAll('.page')];
  const total = pages.length;
  let current = 0;
  const fromHash = parseInt(location.hash.slice(1), 10);
  if (fromHash >= 1 && fromHash <= total) current = fromHash - 1;
  document.getElementById('deckTotal').textContent = total;

  function show(i) {
    current = Math.max(0, Math.min(total - 1, i));
    pages.forEach((p, n) => p.classList.toggle('is-active', n === current));
    document.getElementById('deckCurrent').textContent = current + 1;
    document.getElementById('deckProgress').style.width = ((current + 1) / total * 100) + '%';
    history.replaceState(null, '', '#' + (current + 1));
  }

  document.addEventListener('keydown', (e) => {
    if (['ArrowRight', 'PageDown', ' '].includes(e.key)) { e.preventDefault(); show(current + 1); }
    if (['ArrowLeft', 'PageUp'].includes(e.key)) { e.preventDefault(); show(current - 1); }
    if (e.key === 'Home') show(0);
    if (e.key === 'End') show(total - 1);
  });
  document.addEventListener('click', (e) => { if (!e.target.closest('a, button')) show(current + 1); });

  show(current);
})();
</script>
```

- `#N` na URL abre direto no slide N (útil para retomar a apresentação).
- O script não interfere no export: `html-to-pdf.mjs` imprime em mídia `print`, onde todas as `.page` aparecem.
- Sem animação de transição — o slide troca seco; o PDF é o mesmo que a plateia viu.

## Gráficos

**Preferir SVG inline** gerado a partir da ficha de números: barras e linhas simples são `<rect>`/`<polyline>` com coordenadas calculadas, cores do design system, rótulo com o valor e a origem (`#id`). SVG imprime nítido, não depende de script e passa no `check-pdf.sh`.

Se um gráfico exigir biblioteca (ex.: Chart.js), **vendorizar** o arquivo minificado na pasta da proposta (`vendor/chart.umd.min.js`, versão fixa) e referenciá-lo por caminho relativo; desligar animação (`animation: false`) para o export capturar o gráfico pronto. Nunca carregar de CDN.
