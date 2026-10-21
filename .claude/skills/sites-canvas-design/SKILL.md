---
name: sites-canvas-design
description: "Design de componentes visuais complexos com Canvas HTML5 e SVG — gráficos, partículas, ilustrações e backgrounds custom. Use ao criar visual que CSS não resolve — animação de partículas, gráficos dinâmicos, ícones SVG otimizados ou backgrounds derivados da paleta da marca (tonal, textura, padrão da identidade)."
version: "1.1"
updated: "2026-10-20"
---

# Sites Canvas Design — HTML5 Canvas e SVG

## Quando usar Canvas vs SVG

| Canvas | SVG |
|---|---|
| Gráficos dinâmicos (dados em tempo real) | Ícones e ilustrações estáticas |
| Efeitos de partículas | Animações CSS/SMIL |
| Jogos e simulações | Logos e elementos de marca |
| Processamento de imagem | Diagramas e infográficos |

## SVG otimizado para web

```tsx
export function Icon({ className }: { className?: string }) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      className={cn("h-6 w-6", className)}
      aria-hidden="true"
    >
      <path ... />
    </svg>
  )
}
```

## Backgrounds CSS avançados

**Fundo deriva da paleta da marca; gradiente só se a marca pedir.** Mesh gradient azul/violeta/rosa e
grid de linhas finas cinza atrás do hero são o sinal nº 1 de "cara de IA" — não são padrão aqui. Antes
de qualquer fundo decorativo, pergunte o que ele diz sobre o assunto da página; se a resposta for
"nada", use cor sólida do token (`--color-background`, `--color-muted`) e deixe o conteúdo trabalhar.

```css
/* Fundo tonal da marca — duas paradas da PRÓPRIA paleta, contraste baixo.
   Só use se o sistema visual do projeto previr gradiente. */
.bg-marca {
  background: linear-gradient(180deg, var(--color-background) 0%, var(--color-muted) 100%);
}

/* Padrão geométrico só quando ele vem da identidade (ex.: grade de planta para arquitetura,
   pauta para educação) — traço e cor saem dos tokens, nunca cinza genérico fixo */
.bg-padrao-marca {
  background-image: linear-gradient(to right, var(--color-border) 1px, transparent 1px);
  background-size: var(--padrao-passo, 48px) 100%;
}

/* Noise texture */
.bg-noise::after {
  content: '';
  position: absolute;
  inset: 0;
  background-image: url("data:image/svg+xml,...");
  opacity: 0.04;
}
```

## Canvas — animação de partículas simples

```tsx
useEffect(() => {
  const canvas = canvasRef.current
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  if (!ctx) return

  let rafId: number
  const animate = () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    particles.forEach(p => { p.update(); p.draw(ctx) })
    rafId = requestAnimationFrame(animate)
  }
  rafId = requestAnimationFrame(animate)

  return () => cancelAnimationFrame(rafId)
}, [])
```

Regras: sempre null-check de `canvasRef.current` e `getContext`, guardar o id do `requestAnimationFrame` e cancelar no cleanup — sem isso o loop continua rodando após o unmount (memory leak e erro em strict mode).
