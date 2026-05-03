# Plano — Skill `sites-scroll-motion`

> Análise de duas fontes reais de produção:
> - **Fonte A:** `/agentes` page — `joaoguirunas/sites` (Next.js + React Three Fiber + Framer Motion)
> - **Fonte B:** `Verdana — Digital Oasis` — HTML vanilla com Three.js WebGPU + TSL + GPU Compute

---

## 1. Mapa Completo de Tecnologias Identificadas

### Fonte A — joaoguirunas/sites (`/agentes`)

| Técnica | Lib/API | Arquivo |
|---|---|---|
| Scroll progress sem re-render | `useRef` + `passive: true` | `use-scroll-progress.ts` |
| Câmera 3D keyframe path | Three.js `useFrame` | `CameraRig.tsx` |
| Mouse parallax dual-ref | `useRef` + `rAF` | `SolarSystemScene.tsx` |
| Planetas 3D com textura | Three.js `TextureLoader` + `meshStandardMaterial` | `Planet.tsx` |
| Starfield com mouse | Three.js `Points` + `BufferGeometry` | `Starfield.tsx` |
| Scroll-driven UI 2D | Framer Motion `useScroll + useTransform` | `SquadSection.tsx` |
| Seção sticky com parallax | CSS `sticky` + `min-h-[150vh]` | `SquadSection.tsx` |
| SSR-safe canvas | Next.js `dynamic({ ssr: false })` | `SolarSystemBackground.tsx` |
| Atmosfera aditiva | `AdditiveBlending` + `BackSide` | `Planet.tsx` |

### Fonte B — Verdana Digital Oasis (HTML vanilla)

| Técnica | Lib/API | Onde |
|---|---|---|
| **WebGPU Renderer** | `three/webgpu` (v0.183) | `import * as THREE` |
| **TSL — node materials** | `three/tsl` (`Fn`, `uniform`, `vec3`, `mix`, `select`…) | `grassMat.positionNode`, `colorNode` |
| **GPU Compute Shaders** | `instancedArray` + `.compute(N)` | `computeInit`, `computeUpdate` |
| **120k instâncias de grama** | `InstancedMesh` + TSL `positionNode` | `createBladeGeometry()` |
| **Vento simulado na GPU** | TSL `sin + mix + deltaTime` | `computeUpdate` |
| **Mouse → mundo 3D** | `Raycaster.intersectPlane()` | `mousemove` handler |
| **Mouse push em instâncias** | TSL `smoothstep + falloff + push` | `computeUpdate` |
| **Camera sphere push** | camSphereWorld uniform atualizado todo frame | `animate()` |
| **Depth of Field** | `dof` de `three/addons/tsl/display/DepthOfFieldNode.js` | `PostProcessing` |
| **Auto-focus DoF** | distância câmera→mouse via raycaster | `animate()` |
| **Post-processing MRT** | `pass()`, `mrt()`, `output`, `transformedNormalView` | `PostProcessing` |
| **Per-stage param interpolation** | `lerpCam()` + `stageParams[]` | `animate()` |
| **Scroll snap nativo** | `scroll-snap-type: y proximity` + `scroll-snap-align` | CSS |
| **Reveal via IntersectionObserver** | `new IntersectionObserver()` + CSS classes | `revealObserver` |
| **Sky gradient via CanvasTexture** | `document.createElement('canvas')` + `CanvasTexture` | `buildSkyTexture()` |
| **Import map** | `<script type="importmap">` | `<head>` |
| **Tone mapping** | `ACESFilmicToneMapping` | `renderer.toneMapping` |
| **FogExp2** | `THREE.FogExp2` | `scene.fog` |
| **Progress bar via scroll** | `div` com `width: currentScrollT * 100%` | `animate()` |
| **Canvas fade-in pré-aquecido** | render 3 frames com `opacity: 0` → fade | boot |
| **Editor in-browser** | settings panel com sliders + color pickers | `buildSettings()` |

---

## 2. Padrões Técnicos — Análise Profunda

### 2.1 — Two-tier scroll smoothing (padrão compartilhado pelas duas fontes)

Ambas as fontes usam o mesmo padrão: **valor bruto (target) + valor suavizado (current)** atualizados via animação, não via evento.

```js
// Vanilla (Verdana)
let currentScrollT = 0, targetScrollT = 0;
window.addEventListener('scroll', () => { _scrollDirty = true; }, { passive: true });

function animate() {
  if (_scrollDirty) { targetScrollT = getScrollProgress(); _scrollDirty = false; }
  currentScrollT += (targetScrollT - currentScrollT) * Math.min(1, dt * 6);
}

// React (CameraRig.tsx)
progressRef.current += (targetRef.current - progressRef.current) * Math.min(1, delta * 5);
```

**Por que `_scrollDirty` em vez de calcular todo frame?** `getBoundingClientRect()` e `scrollY` causam layout thrashing se chamados no rAF. Marcar dirty no evento e ler uma vez por frame é mais seguro.

---

### 2.2 — Keyframe Camera Path com lerp + smoothstep

Padrão reutilizável entre as duas fontes:

```js
// Formato de keyframe (mais completo na Verdana — 15 valores)
// [scrollT, posX, posY, posZ, lookX, lookY, lookZ, focusDist, autoFocus, dofOn, focalLen, bokeh, afSpeed, afMin, afMax]

function lerpCam(scrollT) {
  // 1. Achar segmento (A → B) que contém scrollT
  let i = 0;
  for (let j = 1; j < cameraPath.length; j++) {
    if (cameraPath[j][0] >= scrollT) { i = j - 1; break; }
  }
  const a = cameraPath[i], b = cameraPath[i + 1];
  
  // 2. localT dentro do segmento
  const t = (scrollT - a[0]) / (b[0] - a[0]);
  
  // 3. Suavizar com smoothstep (cubic ease-in-out)
  const ease = t * t * (3 - 2 * t);
  
  // 4. Lerp de todos os valores
  return { px: a[1] + (b[1] - a[1]) * ease, ... };
}
```

---

### 2.3 — Per-Stage Parameter Interpolation (EXCLUSIVO da Fonte B)

**O padrão mais sofisticado encontrado.** Não apenas a câmera muda entre seções — TODOS os parâmetros da cena (fog, cor da grama, vento, densidade) fazem lerp suave entre os valores de cada stage.

```js
// Cada section tem seu próprio conjunto de params
const stageParams = cameraPath.map(() => ({
  fogStart: 6.5, fogEnd: 12.0,
  windSpeed: 1.3, windAmplitude: 0.21,
  bladeBaseR: 0.055, bladeBaseG: 0.118, bladeBaseB: 0.016,
  // ... 30+ parâmetros por stage
}));

// Em lerpCam(): faz lerp de TODOS os params junto com a câmera
const pA = stageParams[i], pB = stageParams[i + 1];
const lerpedParams = {};
Object.keys(pA).forEach(k => {
  lerpedParams[k] = pA[k] + (pB[k] - pA[k]) * ease;
});

// No animate(): todos os uniforms da GPU recebem o valor interpolado todo frame
fogStart.value = cam.params.fogStart;
bladeBaseColor.value.setRGB(cam.params.bladeBaseR, cam.params.bladeBaseG, cam.params.bladeBaseB);
// ...
```

**Resultado visual:** a paleta de cores da grama muda imperceptivelmente de stage para stage. Na seção Pillars a grama é rosa-quente; em Stats é dourada; na CTA é baixa e compacta. A transição acontece durante o scroll, não de repente.

**Versão React Three Fiber (equivalente):**
```ts
// Uniforms como useRef, atualizados no useFrame
const fogStartRef = useRef(6.5);
useFrame(() => {
  const cam = lerpCam(progressRef.current);
  fogMaterial.uniforms.fogStart.value = cam.params.fogStart;
});
```

---

### 2.4 — Three.js WebGPU + TSL (Fonte B — bleeding edge)

**WebGPU** substitui WebGL. O renderer é `THREE.WebGPURenderer` em vez de `THREE.WebGLRenderer`. Requer `await renderer.init()`.

**TSL (Three.js Shading Language)** substitui GLSL para materiais e compute shaders. Em vez de escrever código de shader em string, usa-se JavaScript com a API funcional do TSL:

```js
// GLSL (old)
// varying vec2 vUv;
// void main() { gl_FragColor = mix(colorA, colorB, vUv.y); }

// TSL (new)
import { Fn, vec3, mix, uv } from 'three/tsl';
const colorA = uniform(new THREE.Color('#0e1e04'));
const colorB = uniform(new THREE.Color('#c8b840'));

material.colorNode = Fn(() => {
  return mix(colorA, colorB, uv().y); // mesmo resultado, mas é JavaScript puro
})();
```

**GPU Compute Shaders via TSL:**

```js
import { Fn, instancedArray, instanceIndex, deltaTime, time, sin, mix } from 'three/tsl';

// Buffer na GPU: 120000 vec4 (x, z, rotY, clump)
const bladeData = instancedArray(BLADE_COUNT, 'vec4');
const bendState = instancedArray(BLADE_COUNT, 'vec4');

// Compute shader: roda NA GPU, uma vez por instância
const computeUpdate = Fn(() => {
  const bend = bendState.element(instanceIndex); // acessa a instância atual
  const windX = sin(time.mul(1.3)).mul(0.21);    // vento baseado em tempo
  const lw = deltaTime.mul(4.0).saturate();       // lerp weight frame-rate independent
  bend.x.assign(mix(bend.x, windX, lw));          // suaviza o bend
})().compute(BLADE_COUNT); // compila e retorna handle

// Rodar o compute a cada frame:
renderer.compute(computeUpdate);
```

**Quando usar WebGPU vs WebGL:**
- WebGPU: compute shaders (simulação na GPU), materiais complexos sem GLSL, >10k instâncias com física
- WebGL (padrão): todos os outros casos — melhor compatibilidade de browser

---

### 2.5 — Depth of Field Post-Processing (Fonte B)

DoF com bokeh real usando o pipeline de post-processing do Three.js WebGPU:

```js
import { dof } from 'three/addons/tsl/display/DepthOfFieldNode.js';
import { pass, mrt, output, transformedNormalView } from 'three/tsl';

// Multi-render target: renderiza cor + normals num pass
const scenePass = pass(scene, camera);
scenePass.setMRT(mrt({ output, normal: transformedNormalView }));

// DoF node: precisa da cor e da profundidade da cena
const sceneColor = scenePass.getTextureNode('output');
const sceneViewZ = scenePass.getViewZNode();
const dofOutput = dof(sceneColor, sceneViewZ, focusDistanceU, focalLengthU, bokehScaleU);

// Switch entre com/sem DoF (mobile sem, desktop com)
postProcessing.outputNode = isMobile ? sceneColor : dofOutput;

// Auto-focus: raycaster encontra onde o mouse está no mundo, mede distância à câmera
raycaster.setFromCamera(mouseNDC, camera);
raycaster.ray.intersectPlane(grassPlane, hitPoint);
mouseFocusDist = camera.position.distanceTo(hitPoint);

// Suaviza o foco
autoFocusSmoothed += (mouseFocusDist - autoFocusSmoothed) * Math.min(1, dt * afSpeed);
focusDistanceU.value += (autoFocusSmoothed - focusDistanceU.value) * Math.min(1, dt * 8);
```

---

### 2.6 — Mouse → World 3D via Raycasting (Fonte B)

Converter posição do mouse em 2D (viewport) para posição 3D no mundo usando raycast contra um plano horizontal:

```js
const raycaster = new THREE.Raycaster();
const mouseNDC = new THREE.Vector2(); // Normalized Device Coordinates (-1..1)
const grassPlane = new THREE.Plane(new THREE.Vector3(0, 1, 0), 0); // plano y=0
const hitPoint = new THREE.Vector3();

window.addEventListener('mousemove', (e) => {
  // Normalizar para NDC
  mouseNDC.set((e.clientX / innerWidth) * 2 - 1, -(e.clientY / innerHeight) * 2 + 1);
  
  // Raycasting: lança raio da câmera na direção do mouse
  raycaster.setFromCamera(mouseNDC, camera);
  
  // Intersectar com o plano do chão
  if (raycaster.ray.intersectPlane(grassPlane, hitPoint)) {
    mouseWorld.value.copy(hitPoint); // uniform da GPU recebe a posição mundo
  }
});
```

**Uso:** `mouseWorld` é um uniform TSL que o compute shader da grama lê para calcular o push. Grama próxima ao mouse se inclina para longe.

---

### 2.7 — IntersectionObserver Reveal (Fonte B — sem JS de animação)

Revelar elementos sem Framer Motion, sem GSAP — apenas CSS + `IntersectionObserver`:

```js
// Observa todos os elementos com data-reveal
const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const el = entry.target;
      const delay = el.dataset.delay || '0';
      el.classList.add('revealed', `delay-${delay}`); // CSS faz o trabalho
      revealObserver.unobserve(el); // never re-triggers
    }
  });
}, { threshold: 0.1, rootMargin: '0px 0px -18% 0px' }); // 18% de baixo = animação antes de atingir a viewport

document.querySelectorAll('[data-reveal]').forEach(el => revealObserver.observe(el));
```

```css
/* Estado inicial: invisível */
[data-reveal] {
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.7s ease, transform 0.7s ease;
}

/* Estado revelado: transição CSS faz o trabalho */
[data-reveal].revealed {
  opacity: 1;
  transform: translateY(0);
}

/* Delays via classes */
.delay-1 { transition-delay: 0.1s; }
.delay-2 { transition-delay: 0.25s; }
.delay-3 { transition-delay: 0.4s; }
```

**HTML:**
```html
<h1 data-reveal data-delay="2">Título</h1>
<p data-reveal data-delay="3">Subtítulo</p>
```

---

### 2.8 — Sky Gradient via CanvasTexture (Fonte B)

Gerar textura de céu dinamicamente com canvas, sem arquivo de imagem:

```js
function buildSkyTexture() {
  const canvas = document.createElement('canvas');
  canvas.width = 2; canvas.height = 512; // só precisa de altura para o gradiente
  const ctx = canvas.getContext('2d');
  const grad = ctx.createLinearGradient(0, 0, 0, 512);
  grad.addColorStop(0.0,  '#0a0a1a'); // zenith
  grad.addColorStop(0.65, '#1a0a05'); // horizon cálido
  grad.addColorStop(1.0,  '#050505'); // base
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, 2, 512);
  
  const tex = new THREE.CanvasTexture(canvas);
  tex.mapping = THREE.EquirectangularReflectionMapping; // use como environment map
  tex.colorSpace = THREE.SRGBColorSpace;
  return tex;
}

scene.background = buildSkyTexture();
// Atualizar ao vivo: skyColor.set(newHex); scene.background = buildSkyTexture();
```

---

### 2.9 — Import Map (Fonte B — sem bundler)

Resolver módulos NPM direto no browser sem Webpack/Vite/Next.js:

```html
<script type="importmap">
{
  "imports": {
    "three": "https://unpkg.com/three@0.183.0/build/three.webgpu.js",
    "three/webgpu": "https://unpkg.com/three@0.183.0/build/three.webgpu.js",
    "three/tsl": "https://unpkg.com/three@0.183.0/build/three.tsl.js",
    "three/addons/": "https://unpkg.com/three@0.183.0/examples/jsm/"
  }
}
</script>
<script type="module">
  import * as THREE from 'three';           // resolve para unpkg.com/...
  import { Fn } from 'three/tsl';           // resolve para unpkg.com/...
  import { dof } from 'three/addons/...';   // resolve para unpkg.com/...
</script>
```

**Quando usar:** protótipos, demos, páginas estáticas sem build step.

---

### 2.10 — CSS Scroll Snap Nativo (Fonte B)

```css
html {
  scroll-snap-type: y proximity; /* "proximity": snap apenas se estiver perto */
}

.section {
  scroll-snap-align: start; /* cada section snapa no topo */
  min-height: 100vh;
}
```

Valores de `scroll-snap-type`:
- `mandatory` — força snap sempre (experiência mais abrupta)
- `proximity` — só snapa se o usuário parar perto de um snap point (mais natural)

---

### 2.11 — Canvas Push para Cima no Footer (Fonte B)

Canvas fixo tem que sair de trás quando o footer aparece:

```js
// Cache o elemento fora do loop
const _siteFooter = document.querySelector('.site-footer');

function animate() {
  if (_siteFooter) {
    const footerTop = _siteFooter.getBoundingClientRect().top;
    if (footerTop < window.innerHeight) {
      // Footer está visível — empurra o canvas para cima
      renderer.domElement.style.transform = `translateY(-${window.innerHeight - footerTop}px)`;
    } else {
      renderer.domElement.style.transform = '';
    }
  }
}
```

---

## 3. Hierarquia de Técnicas — Árvore de Decisão

```
Objetivo de movimento
    │
    ├── Revelar elemento ao entrar na viewport
    │     ├── Simples → IntersectionObserver + CSS classes (zero deps)
    │     └── Física/spring → Framer Motion whileInView
    │
    ├── Transformar valor com scroll (opacity, x, y, scale)
    │     ├── 1 elemento → Framer Motion useScroll + useTransform
    │     └── Múltiplos com timeline → useScroll + useTransform multi-keyframe
    │
    ├── Parallax de fundo
    │     ├── Suave sem interação → CSS background-attachment: fixed
    │     └── Com mouse → dual-ref pattern (targetRef + smoothedRef via rAF)
    │
    ├── Seção com efeito sticky + scroll-driven
    │     └── min-h-[150vh] + sticky child + Framer Motion useScroll
    │
    ├── CSS nativo de scroll snapping
    │     └── scroll-snap-type y proximity + scroll-snap-align start
    │
    ├── Câmera 3D com scroll (cena decorativa)
    │     ├── React project → React Three Fiber + CameraRig keyframe pattern
    │     └── Vanilla HTML → Three.js WebGL + importmap + lerpCam()
    │
    ├── Cena 3D com objetos interativos (mouse, física)
    │     ├── Simples (planetas, starfield) → Three.js WebGL + useFrame
    │     └── Complexo (>10k instâncias, simulação) → Three.js WebGPU + TSL + GPU Compute
    │
    └── Post-processing (bokeh, glow, bloom)
          ├── React → @react-three/postprocessing (Bloom, DepthOfField)
          └── Vanilla → Three.js PostProcessing + TSL dof node
```

---

## 4. A Skill a Criar — `sites-scroll-motion`

### Objetivo

Injetar nos agentes `sites-ux`, `sites-dev-alpha` e `sites-dev-gamma` o conhecimento de como criar scroll cinematográfico, parallax, movimentos avançados e cenas 3D interativas — do CSS simples ao WebGPU.

### Onde vai morar

```
.claude/skills/sites-scroll-motion/
└── SKILL.md
```

---

## 5. Estrutura de Conteúdo da Skill (10 seções)

### Seção 1 — Árvore de Decisão
A árvore completa do item 3 acima. Sempre a primeira coisa a ler — determina qual das técnicas abaixo aplicar.

### Seção 2 — IntersectionObserver + CSS Reveal (Zero deps)
- Pattern `data-reveal` + `data-delay`
- CSS com `opacity: 0; transform: translateY()` → `.revealed`
- `rootMargin: '0px 0px -18% 0px'` — animação antes de atingir a viewport
- Quando usar vs Framer Motion

### Seção 3 — CSS Scroll Snap Nativo
- `scroll-snap-type y proximity` vs `mandatory`
- Layout de sections com snap points
- Combinação com scroll-driven animations

### Seção 4 — Dual-ref Scroll (Sem re-render)
- `useScrollProgress()` hook completo (React) e equivalente vanilla
- Por que refs em vez de state para animações de alta frequência
- `_scrollDirty` pattern para evitar layout thrashing
- `passive: true` em todos os listeners

### Seção 5 — Framer Motion Scroll Avançado
- `useScroll` com `offset` configurável
- `useTransform` com multi-keyframe arrays
- Padrão sticky: `min-h-[150vh]` + `sticky top-Xvh`
- Coordenar múltiplos elementos (header antes, cards depois)

### Seção 6 — Keyframe Camera Path
- Formato do array de keyframes
- `lerpCam()` reutilizável (com snap threshold)
- `smoothstep` vs `linear` — quando usar cada
- Sincronizar keyframes com posição DOM real (`syncCameraPathToDOM`)

### Seção 7 — Per-Stage Parameter Interpolation
- `stageParams[]` — um objeto de params por seção
- Interpolação de todos os params junto com a câmera
- Aplicar a uniforms GPU todo frame
- Como criar paletas diferentes por section com transição suave

### Seção 8 — Three.js/R3F — Cenas 3D
- Setup mínimo (React Three Fiber):
  - `<Canvas fixed behind content>` + `pointerEvents: none`
  - `dynamic({ ssr: false })` para Next.js
- Mouse parallax (dual-ref)
- Mouse → mundo 3D via `Raycaster.intersectPlane()`
- Objetos com `useFrame` (rotação, drift)
- Canvas push no footer

### Seção 9 — Three.js WebGPU + TSL (Avançado)
- Quando usar WebGPU vs WebGL
- `WebGPURenderer` setup + `await renderer.init()`
- TSL: `Fn`, `uniform`, `instancedArray`, `instanceIndex`
- GPU Compute shaders: física, wind, simulações em massa
- Depth of Field com `dof` node + auto-focus via raycaster
- Sky gradient via `CanvasTexture`
- `ACESFilmicToneMapping` + `FogExp2`
- Import map para vanilla (sem bundler)

### Seção 10 — Performance Rules (Não-negociáveis)
1. Scroll listeners sempre `{ passive: true }`
2. Animações de scroll = refs/rAF, nunca `useState`
3. `_scrollDirty` flag — não ler scroll no rAF, marcar e ler uma vez
4. `will-change: transform` só em elementos realmente animados
5. Canvas Three.js decorativo: `pointerEvents: none`
6. `dpr={[1, 2]}` ou `renderer.setPixelRatio(Math.min(dpr, 2))`
7. `dynamic({ ssr: false })` para qualquer import de `three` ou `window`
8. WebGPU: cap de instâncias (~120k grama OK, acima disso dividir em chunks)
9. DoF desligado em mobile — performance crítica
10. Fog é mais barato que frustum culling para objetos distantes
11. `renderer.setAnimationLoop()` em vez de `requestAnimationFrame` loop manual no WebGPU

---

## 6. Receitas Copy-Paste

| Receita | Técnica | Complexidade |
|---|---|---|
| Fade-in ao entrar na viewport | IntersectionObserver + CSS | ⬤○○ |
| Scroll snap entre sections | CSS nativo | ⬤○○ |
| Progress bar de scroll | `div` width = `scrollY / scrollHeight` | ⬤○○ |
| Cards que deslizam com scroll | Framer Motion useScroll + useTransform | ⬤⬤○ |
| Seção sticky + scroll-driven | Framer Motion + min-h-[150vh] | ⬤⬤○ |
| Mouse parallax (CSS vars) | `--mx`, `--my` + translate | ⬤⬤○ |
| Câmera 3D com scroll | CameraRig keyframe pattern (R3F) | ⬤⬤⬤ |
| Planetas com atmosfera | Planet.tsx completo (Three.js R3F) | ⬤⬤⬤ |
| Starfield com mouse | Starfield.tsx completo (Three.js R3F) | ⬤⬤⬤ |
| Per-stage color palette | stageParams + lerpCam | ⬤⬤⬤ |
| Grama GPU com vento | WebGPU + TSL compute (vanilla) | ⬤⬤⬤ |
| Depth of Field bokeh | PostProcessing + dof node (WebGPU) | ⬤⬤⬤ |

---

## 7. Plano de Implementação

### Fase 1 — Criar a skill
- [ ] Criar `.claude/skills/sites-scroll-motion/SKILL.md`
- [ ] Escrever seções 1-5 (CSS, Framer Motion, IntersectionObserver)
- [ ] Escrever seções 6-8 (Camera path, per-stage, Three.js/R3F)
- [ ] Escrever seção 9 (WebGPU + TSL — seção avançada, auto-contida)
- [ ] Seção 10 (Performance rules)
- [ ] Todas as receitas copy-paste

### Fase 2 — Registrar nos agentes
- [ ] Injetar skill em `sites-ux` (spec de movimento, escolher técnica)
- [ ] Injetar skill em `sites-dev-alpha` (implementação CSS/Framer)
- [ ] Injetar skill em `sites-dev-gamma` (integração fullstack + Three.js)

### Fase 3 — Registrar em settings.json como user-invocable
- [ ] Adicionar `/sites-scroll-motion` como skill invocável
- [ ] Verificar que aparece na lista de skills disponíveis

---

## 8. Decisões de Design

**Por que WebGPU numa skill de sites?**
A Fonte B prova que é possível criar grama com 120k instâncias com física de vento e DoF em tempo real, sem GSAP, sem dependências além de Three.js — em um único HTML. É uma técnica real e viável, não apenas teórica. A skill cobre WebGPU numa seção separada e avançada, bem sinalizada — agentes sem esse contexto não vão usar na hora errada.

**Por que IntersectionObserver em vez de sempre Framer Motion?**
Framer Motion é ótimo, mas pesa ~40kb. Para um reveal simples de "fade in quando entrar na tela", IntersectionObserver + CSS é zero dependência, mais performático, e roda nos mesmos browsers. A skill ensina os dois e quando escolher cada um.

**Por que per-stage params como seção própria?**
É o padrão mais sofisticado e mais raro — agentes nunca vão descobrir isso sozinhos. A ideia de que **a paleta de cores da cena faz lerp junto com a câmera** é não-óbvia e cria efeitos visuais incríveis. Vale documentar explicitamente.

---

## 9. Referências

- **Fonte A (React Three Fiber):** `/Users/joaoramos/Desktop/Projetos/Projetos/joao-guirunas-site/src/app/agentes/`
- **Fonte B (WebGPU/TSL):** `/Users/joaoramos/Downloads/remix-3d-website-the-digital-o/index.html`
- Three.js WebGPU docs: https://threejs.org/docs/#api/en/renderers/WebGPURenderer
- Three.js TSL (nós de material): https://github.com/mrdoob/three.js/wiki/Three.js-Shading-Language
- Framer Motion useScroll: https://www.framer.com/motion/use-scroll/
