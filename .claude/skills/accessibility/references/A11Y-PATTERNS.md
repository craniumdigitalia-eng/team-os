# Accessibility Code Patterns

Practical, copy-paste-ready patterns for common accessibility requirements. Each pattern is self-contained and linked from the main [SKILL.md](../SKILL.md).

---

## Modal focus trap

Trap keyboard focus inside a modal dialog so Tab/Shift+Tab cycle through its focusable elements and Escape closes it.

```javascript
function openModal(modal) {
  const focusableElements = modal.querySelectorAll(
    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
  );
  const firstElement = focusableElements[0];
  const lastElement = focusableElements[focusableElements.length - 1];

  modal.addEventListener('keydown', (e) => {
    if (e.key === 'Tab') {
      if (e.shiftKey && document.activeElement === firstElement) {
        e.preventDefault();
        lastElement.focus();
      } else if (!e.shiftKey && document.activeElement === lastElement) {
        e.preventDefault();
        firstElement.focus();
      }
    }
    if (e.key === 'Escape') {
      closeModal();
    }
  });

  firstElement.focus();
}
```

The native `<dialog>` element handles focus trapping automatically—prefer it when browser support allows.

---

## Skip link

Allows keyboard users to bypass repetitive navigation and jump straight to main content.

```html
<body>
  <a href="#main-content" class="skip-link">Skip to main content</a>
  <header><!-- navigation --></header>
  <main id="main-content" tabindex="-1">
    <!-- main content -->
  </main>
</body>
```

```css
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #000;
  color: #fff;
  padding: 8px 16px;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
```

---

## Error handling

Announce errors to screen readers and focus the first invalid field on submit.

```html
<form novalidate>
  <div class="field" aria-live="polite">
    <label for="email">Email</label>
    <input type="email" id="email"
           aria-invalid="true"
           aria-describedby="email-error">
    <p id="email-error" class="error" role="alert">
      Please enter a valid email address (e.g., name@example.com)
    </p>
  </div>
</form>
```

```javascript
form.addEventListener('submit', (e) => {
  const firstError = form.querySelector('[aria-invalid="true"]');
  if (firstError) {
    e.preventDefault();
    firstError.focus();

    const errorSummary = document.getElementById('error-summary');
    errorSummary.textContent =
      `${errors.length} errors found. Please fix them and try again.`;
    errorSummary.focus();
  }
});
```

---

## Form labels

Every input needs an associated label—either explicit (`for`/`id`) or implicit (wrapping `<label>`).

```html
<!-- ❌ No label association -->
<input type="email" placeholder="Email">

<!-- ✅ Explicit label -->
<label for="email">Email address</label>
<input type="email" id="email" name="email"
       autocomplete="email" required>

<!-- ✅ Implicit label -->
<label>
  Email address
  <input type="email" name="email" autocomplete="email" required>
</label>

<!-- ✅ With instructions -->
<label for="password">Password</label>
<input type="password" id="password"
       aria-describedby="password-requirements">
<p id="password-requirements">
  Must be at least 8 characters with one number.
</p>
```

---

## Dragging movements

Any action triggered by dragging must offer a single-pointer alternative (WCAG 2.5.7).

```html
<!-- ❌ Drag-only reorder -->
<ul class="sortable-list" draggable="true">
  <li>Item 1</li>
  <li>Item 2</li>
</ul>

<!-- ✅ Drag + button alternatives -->
<ul class="sortable-list">
  <li>
    <span>Item 1</span>
    <button aria-label="Move Item 1 up">↑</button>
    <button aria-label="Move Item 1 down">↓</button>
  </li>
  <li>
    <span>Item 2</span>
    <button aria-label="Move Item 2 up">↑</button>
    <button aria-label="Move Item 2 down">↓</button>
  </li>
</ul>
```

Also applies to sliders, map panning, colour pickers, and similar drag-based widgets—always provide an equivalent click/tap or keyboard path.

---

## ARIA tabs

Tabs require `role="tablist"`, `role="tab"`, and `role="tabpanel"` with proper `aria-selected`, `aria-controls`, and keyboard support.

```html
<div role="tablist" aria-label="Product information">
  <button role="tab" id="tab-1" aria-selected="true"
          aria-controls="panel-1">Description</button>
  <button role="tab" id="tab-2" aria-selected="false"
          aria-controls="panel-2" tabindex="-1">Reviews</button>
</div>
<div role="tabpanel" id="panel-1" aria-labelledby="tab-1">
  <!-- Panel content -->
</div>
<div role="tabpanel" id="panel-2" aria-labelledby="tab-2" hidden>
  <!-- Panel content -->
</div>
```

Arrow keys should move focus between tabs; the active tab receives `tabindex="0"` while inactive tabs use `tabindex="-1"`.

---

## Live regions and notifications

Use `aria-live` to announce dynamic content changes to screen readers without moving focus.

```html
<!-- Status updates (polite — waits for pause in speech) -->
<div aria-live="polite" aria-atomic="true" class="status">
  <!-- Content updates announced to screen readers -->
</div>

<!-- Urgent alerts (assertive — interrupts) -->
<div role="alert" aria-live="assertive">
  <!-- Interrupts current announcement -->
</div>
```

```javascript
function showNotification(message, type = 'polite') {
  const container = document.getElementById(`${type}-announcer`);
  container.textContent = '';
  requestAnimationFrame(() => {
    container.textContent = message;
  });
}
```

Clear the container before writing to ensure the same message triggers a new announcement.

---

## Screen reader commands

Quick reference for the most common screen reader shortcuts.

| Action | VoiceOver (Mac) | NVDA (Windows) |
|--------|-----------------|----------------|
| Start/Stop | ⌘ + F5 | Ctrl + Alt + N |
| Next item | VO + → | ↓ |
| Previous item | VO + ← | ↑ |
| Activate | VO + Space | Enter |
| Headings list | VO + U, then arrows | H / Shift + H |
| Links list | VO + U | K / Shift + K |

---

## Texto alternativo (1.1.1)

```html
<!-- ❌ Sem alt -->
<img src="chart.png">

<!-- ✅ Alt descritivo -->
<img src="chart.png" alt="Gráfico de barras: vendas do 3º trimestre subiram 40%">

<!-- ✅ Imagem decorativa: só alt vazio (role/aria-hidden juntos são redundantes) -->
<img src="decorative-border.png" alt="">

<!-- ✅ Imagem complexa com descrição longa -->
<figure>
  <img src="infographic.png" alt="Infográfico de tendências de mercado 2024"
       aria-describedby="infographic-desc">
  <figcaption id="infographic-desc"><!-- descrição detalhada --></figcaption>
</figure>
```

Botão só de ícone precisa de nome acessível:

```html
<!-- ❌ Sem nome acessível -->
<button><svg><!-- ícone --></svg></button>

<!-- ✅ aria-label -->
<button aria-label="Abrir menu">
  <svg aria-hidden="true"><!-- ícone --></svg>
</button>

<!-- ✅ Texto visualmente oculto -->
<button>
  <svg aria-hidden="true"><!-- ícone --></svg>
  <span class="visually-hidden">Abrir menu</span>
</button>
```

```css
/* Equivale ao sr-only do Tailwind */
.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

---

## Contraste e cor (1.4.1, 1.4.3, 1.4.6, 1.4.11)

| Tamanho do texto | AA mínimo | AAA reforçado |
|------------------|-----------|---------------|
| Normal (< 18px / < 14px bold) | 4,5:1 | 7:1 |
| Grande (≥ 18px / ≥ 14px bold) | 3:1 | 4,5:1 |
| Componentes de UI, gráficos e indicador de foco | 3:1 | 3:1 |

```css
/* ❌ Contraste baixo (2,8:1) */
.low-contrast { color: #999; background: #fff; }

/* ✅ Contraste suficiente (12,6:1) */
.high-contrast { color: #333; background: #fff; }

/* ✅ Foco também precisa de contraste (3:1 contra o fundo, WCAG 1.4.11) */
:focus-visible {
  outline: 2px solid currentColor;
  outline-offset: 2px;
}
```

Não depender só de cor:

```html
<!-- ❌ Só a cor indica erro -->
<input class="error-border">

<!-- ✅ Cor + ícone + texto -->
<div class="field-error">
  <input aria-invalid="true" aria-describedby="email-error">
  <span id="email-error" class="error-message">
    <svg aria-hidden="true"><!-- ícone de erro --></svg>
    Informe um e-mail válido
  </span>
</div>
```

---

## Mídia (1.2)

```html
<!-- Vídeo com legendas e audiodescrição -->
<video controls>
  <source src="video.mp4" type="video/mp4">
  <track kind="captions" src="captions.vtt" srclang="pt-BR" label="Português" default>
  <track kind="descriptions" src="descriptions.vtt" srclang="pt-BR" label="Audiodescrição">
</video>

<!-- Áudio com transcrição -->
<audio controls>
  <source src="podcast.mp3" type="audio/mp3">
</audio>
<details>
  <summary>Transcrição</summary>
  <p>Texto completo…</p>
</details>
```

---

## Teclado (2.1.1)

Prefira elementos nativos — `<button>`, `<a href>` e controles de formulário já tratam ativação por Enter/Espaço, foco e semântica.

```html
<!-- ❌ Elemento não interativo só com clique: não recebe foco nem ativa por teclado -->
<div class="card" onclick="handleAction()">Abrir</div>

<!-- ✅ Melhor: botão nativo -->
<button type="button" onclick="handleAction()">Abrir</button>
```

```javascript
// ✅ Só quando PRECISAR usar elemento não interativo (ex.: div com role="button"):
// torne focável E trate a ativação por teclado.
// NÃO faça isso num <button> nativo — Enter/Espaço já disparam click,
// e a ação rodaria duas vezes.
element.setAttribute('role', 'button');
element.setAttribute('tabindex', '0');
element.addEventListener('click', handleAction);
element.addEventListener('keydown', (e) => {
  if (e.key === 'Enter' || e.key === ' ') {
    e.preventDefault();
    handleAction();
  }
});
```

---

## Foco visível (2.4.7) e foco não encoberto (2.4.11)

```css
/* ❌ Nunca remova o foco sem substituto */
*:focus { outline: none; }

/* ✅ :focus-visible mostra o anel só para teclado */
:focus { outline: none; }
:focus-visible {
  outline: 2px solid currentColor; /* herda a cor do texto → contraste já conferido */
  outline-offset: 2px;
}

/* ✅ Ou uma cor de marca — confira ≥ 3:1 contra todo fundo em que ela cair */
button:focus-visible {
  box-shadow: 0 0 0 3px rgba(0, 95, 204, 0.5);
}

/* ✅ 2.4.11: o elemento focado não pode sumir atrás de header/footer fixo */
:target,
:focus {
  scroll-margin-top: 80px;    /* altura do header fixo */
  scroll-margin-bottom: 60px; /* altura do footer fixo */
}
```

---

## Tamanho do alvo (2.5.8)

```css
/* ✅ Mínimo AA: 24×24 px CSS */
button,
[role="button"],
input[type="checkbox"] + label,
input[type="radio"] + label {
  min-width: 24px;
  min-height: 24px;
}

/* ✅ Confortável para toque (recomendado 44×44) */
.touch-target {
  min-width: 44px;
  min-height: 44px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
```

---

## Tempo (2.2.1) e movimento (2.3)

```javascript
// Avisar antes de expirar e permitir estender
function showSessionWarning() {
  createModal({
    title: 'Sua sessão vai expirar',
    content: 'Sua sessão expira em 2 minutos.',
    actions: [
      { label: 'Continuar conectado', action: extendSession },
      { label: 'Sair', action: logout }
    ],
    timeout: 120000
  });
}
```

```css
/* Respeitar a preferência de movimento reduzido */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

---

## Idioma e navegação consistente (3.1.1, 3.1.2, 3.2.3)

```html
<!-- ✅ Idioma da página -->
<html lang="pt-BR">

<!-- ✅ Trecho em outro idioma -->
<p>Em inglês, olá é <span lang="en">hello</span>.</p>

<!-- ✅ Navegação igual em todas as páginas, item atual marcado -->
<nav aria-label="Principal">
  <ul>
    <li><a href="/" aria-current="page">Início</a></li>
    <li><a href="/produtos">Produtos</a></li>
    <li><a href="/sobre">Sobre</a></li>
  </ul>
</nav>
```

---

## Entrada redundante (3.3.7) e autenticação acessível (3.3.8)

```html
<!-- ✅ 3.3.7: reaproveitar o endereço de cobrança -->
<fieldset>
  <legend>Endereço de entrega</legend>
  <label>
    <input type="checkbox" id="same-as-billing" checked>
    Igual ao endereço de cobrança
  </label>
  <!-- campos preenchidos automaticamente quando marcado -->
</fieldset>

<!-- ✅ 3.3.8: permitir colar/autopreencher a senha (nunca bloquear paste) -->
<input type="password" id="password" autocomplete="current-password">

<!-- ✅ 3.3.8: alternativas sem senha -->
<button type="button">Entrar com passkey</button>
<button type="button">Receber link de acesso por e-mail</button>
```

---

## HTML nativo antes de ARIA (4.1.2)

```html
<!-- ❌ Papel ARIA em div -->
<div role="button" tabindex="0">Clique</div>

<!-- ✅ Botão nativo -->
<button type="button">Clique</button>

<!-- ❌ Checkbox ARIA -->
<div role="checkbox" aria-checked="false">Opção</div>

<!-- ✅ Checkbox nativo -->
<label><input type="checkbox"> Opção</label>
```
