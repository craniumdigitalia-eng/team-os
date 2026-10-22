---
name: sites-ux-interaction
description: "Padrões de UX e interação para websites — header sticky, nav mobile, micro-interações, animações de entrada e scroll-triggered. Use ao implementar navegação, hover states, animações com Motion ou comportamento de scroll em Next.js ou Astro."
version: "1.2"
updated: "2026-10-20"
---

# Sites UX Interaction — Padrões de Interação

## Navegação

### Header sticky
```tsx
const [scrolled, setScrolled] = useState(false)
useEffect(() => {
  const handleScroll = () => setScrolled(window.scrollY > 20)
  window.addEventListener('scroll', handleScroll, { passive: true })
  return () => window.removeEventListener('scroll', handleScroll)
}, [])

<header className={cn(
  "fixed top-0 w-full z-50 transition-[background-color,box-shadow,backdrop-filter] duration-300",
  scrolled ? "bg-white/95 backdrop-blur shadow-sm" : "bg-transparent"
)}>
```

**Astro nativo** (sem hooks — `<script>` roda uma vez no client, escopado ao componente):
```astro
<header id="site-header">…</header>
<script>
  const header = document.getElementById('site-header')
  const onScroll = () => header?.classList.toggle('scrolled', window.scrollY > 20)
  window.addEventListener('scroll', onScroll, { passive: true })
</script>
```

### Mobile nav (Sheet)
```tsx
<Sheet>
  <SheetTrigger asChild>
    <Button variant="ghost" size="icon" aria-label="Menu">
      <Menu className="h-5 w-5" />
    </Button>
  </SheetTrigger>
  <SheetContent side="right">...</SheetContent>
</Sheet>
```

**Em Astro**, duas opções — escolher conforme o projeto já tiver React instalado ou não:
- **Nativo, sem framework:** `<details>`/`<summary>` com CSS, zero JS enviado ao navegador.
- **Ilha React do `Sheet` acima**, hidratada só no breakpoint mobile: `<Sheet client:media="(max-width: 768px)">…</Sheet>` — vale quando o projeto já usa React em outras ilhas e não compensa reescrever o componente em CSS puro.

## Animações com Motion (`motion/react`, ex-Framer Motion)

### Enter animations

**Um momento de assinatura por página, não em toda seção.** Fade-up repetido em cada bloco é um dos
sinais mais claros de "cara de IA": cansa, atrasa a leitura e não diz nada. Escolha **um** momento que
carrega a ideia da página (o hero, a revelação do produto, o número principal) e deixe o resto entrar
sem animação ou com um fade curto de opacidade. Toda animação de entrada precisa de versão reduzida
(ver **Reduced motion** abaixo e `/sites-scroll-motion` — seção `prefers-reduced-motion`).

```tsx
// Fade in up (elemento)
<motion.div initial={{ opacity: 0, y: 24 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.4 }}>

// Stagger em lista
<motion.div variants={{ animate: { transition: { staggerChildren: 0.1 } } }} initial="initial" animate="animate">
  {items.map(item => <motion.div key={item} variants={fadeInUp}>{item}</motion.div>)}
</motion.div>
```

### Scroll-triggered (Intersection Observer)
```tsx
const { ref, inView } = useInView({ threshold: 0.1, triggerOnce: true })
<motion.div ref={ref} initial={{ opacity: 0 }} animate={inView ? { opacity: 1 } : {}} />
```

**Em Astro**, sem Motion/hooks, o equivalente nativo é `IntersectionObserver` puro + classes CSS (ver
`/sites-scroll-motion` Seção 2 para o padrão completo). Quando o projeto já usa React em outras ilhas e
precisa da física do Motion (spring, stagger), o componente acima vira uma ilha com `client:visible` —
a API do Motion não muda, só a forma como ela é hidratada.

## Micro-interações

```css
/* Hover em card clicável — feedback sutil na borda/cor, sem levantar o card inteiro.
   "translate-y + shadow-lg" em todo card é padrão de template; só use elevação se o
   sistema visual do projeto tiver elevação como linguagem. */
.card { @apply border border-border transition-colors duration-150 hover:border-foreground/30 focus-visible:outline-2 focus-visible:outline-offset-2; }

/* Button press — escala mínima, só transform (nunca transition-all) */
.btn { @apply active:scale-[0.96] transition-transform duration-100 motion-reduce:active:scale-100; }

/* Link underline animado — anima só a largura do traço */
.link { @apply relative after:absolute after:bottom-0 after:left-0 after:h-0.5 after:w-0 after:bg-current hover:after:w-full after:transition-[width] after:duration-300 motion-reduce:after:transition-none; }
```

**Regra:** sempre listar as propriedades que transicionam (`transition-colors`, `transition-transform`,
`transition-[width]`). `transition-all` anima o que não deveria (layout, cor de texto ao trocar tema) e
custa performance.

## Reduced motion

Em App Router/SSR, `window` não existe no servidor — nunca chamar `matchMedia` no corpo do componente. Ler dentro de `useEffect` (ou usar o hook `useReducedMotion` do `motion/react`):

```tsx
const [prefersReducedMotion, setPrefersReducedMotion] = useState(false)
useEffect(() => {
  const mq = window.matchMedia('(prefers-reduced-motion: reduce)')
  setPrefersReducedMotion(mq.matches)
  const onChange = (e: MediaQueryListEvent) => setPrefersReducedMotion(e.matches)
  mq.addEventListener('change', onChange)
  return () => mq.removeEventListener('change', onChange)
}, [])

const transition = prefersReducedMotion ? { duration: 0 } : { duration: 0.4 }
```

**Astro nativo:** sem `useEffect` (não existe em `.astro`) e sem re-render para gerenciar — o `<script>`
roda uma vez no load:
```astro
<script>
  const mq = matchMedia('(prefers-reduced-motion: reduce)')
  document.documentElement.classList.toggle('reduce-motion', mq.matches)
</script>
```
mais simples que a versão Next porque não há hidratação de UI para sincronizar.
