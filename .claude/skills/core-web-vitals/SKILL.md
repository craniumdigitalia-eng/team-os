---
name: core-web-vitals
description: "Diagnosticar e corrigir Core Web Vitals (LCP, INP, CLS) com evidência — campo (CrUX, PageSpeed, Search Console) × laboratório (Lighthouse, trace), subpartes do LCP, fases do INP (long tasks, handlers, hidratação), causas de CLS e correção genérica por framework. Use ao 'melhorar Core Web Vitals', 'corrigir LCP', 'reduzir CLS', 'otimizar INP' ou ao especificar o fix de performance de uma página."
version: "1.0"
updated: "2026-10-20"
---

# Core Web Vitals — medir, achar a causa, corrigir, medir de novo

As três métricas de experiência de página do Google: **LCP** (carregamento), **INP** (resposta à interação) e **CLS** (estabilidade visual). Esta skill é o método de diagnóstico e correção. Para o contexto de SEO (peso no ranking, estatísticas do CrUX, mitos como "CWV 2.0") a referência é `seo/references/cwv-thresholds.md` (skill `/seo`) — não repetimos aquilo aqui.

## Limiares

| Métrica | Bom | Precisa melhorar | Ruim |
|---|---|---|---|
| **LCP** | ≤ 2,5 s | 2,5 – 4 s | > 4 s |
| **INP** | ≤ 200 ms | 200 – 500 ms | > 500 ms |
| **CLS** | ≤ 0,1 | 0,1 – 0,25 | > 0,25 |

A régua é o **p75 de campo**: 75% das visitas reais precisam ficar em "bom", por página e por origem, separando mobile e desktop. INP é a única métrica de interatividade — FID foi aposentado em 2024, nunca o cite.

## Campo × laboratório — nunca na mesma frase

| Fonte | Tipo | Para quê |
|---|---|---|
| CrUX (API ou BigQuery), relatório CWV do Search Console, bloco "dados reais" do PageSpeed Insights | **Campo** (usuários reais do Chrome, janela de 28 dias, p75) | Decidir **se** há problema e priorizar |
| RUM próprio (biblioteca `web-vitals` com build de atribuição) | **Campo** (seus usuários, por rota, device, release) | Segmentar e atribuir a causa em produção |
| Trace do navegador (DevTools → Performance, ou navegador headless) | **Laboratório** (uma carga, condições declaradas) | Diagnosticar **por que** |
| Lighthouse / bloco "diagnóstico" do PageSpeed | **Laboratório** (simulado, throttling fixo) | Fallback controlado e comparação antes/depois |
| `PerformanceObserver` no console | Sessão única | Depurar uma página aberta |

Regras:
- **Campo decide, laboratório explica.** Um valor de Lighthouse não é comparável a um p75 de campo — são amostras diferentes. Rotule sempre: "LCP campo p75 mobile 3,4 s (CrUX, 28 dias até DD/MM)" e "LCP lab 2,1 s (Lighthouse mobile, Moto G simulado)".
- **Lighthouse não mede INP** (não há interação); o proxy de laboratório é o **TBT** (Total Blocking Time). INP real só vem de campo ou de trace de uma interação gravada.
- Página sem volume no CrUX: use o dado de **origem**, rotulado como tal, ou RUM próprio. Nunca invente o p75 de página.
- Quando a squad **seo** existe no projeto, o número de campo é da **SESHAT** (`seo-google`), com `#id` — peça a ela em vez de consultar por conta própria. Sem a squad seo, cite a fonte e a data da consulta.
- **Sem runtime não há veredicto.** Só com código-fonte dá para apontar causa provável; não afirme que "o LCP está ruim" sem medição.
- **Depois do fix:** meça de novo no laboratório nas mesmas condições. Melhora de campo só aparece com novas visitas (CrUX leva até 28 dias) — nunca declare "CWV corrigido" no mesmo dia; declare "lab melhorou de X para Y; campo a confirmar em DD/MM".

## Sequência de trabalho

1. **Campo:** quais métricas reprovam, em qual device, em quais páginas/templates (p75).
2. **Trace** da página reprovada, em condição representativa (mobile, CPU 4× mais lenta, rede 4G) — anote as condições.
3. Leia **só os insights da métrica que reprova** e vá ao código/recurso implicado.
4. Hipótese → correção mínima → **mesmo trace de novo** → compare a subparte/fase, não só o total.
5. Registre: métrica, fonte, subparte dominante, causa, fix, antes/depois de lab, data para conferir o campo.

## LCP — o maior elemento visível

O elemento LCP costuma ser imagem de destaque (hero), pôster de vídeo, imagem de fundo via CSS ou um bloco grande de texto. Descubra qual é antes de otimizar — o trace mostra, ou o observer em `references/LCP.md`.

**Subpartes** (o total é a soma; ataque a que domina):

| Subparte | O que é | Causa típica | Correção típica |
|---|---|---|---|
| **TTFB** | Até o 1º byte do HTML | Servidor lento, sem cache/CDN, redirects, cold start | Cache na borda, `stale-while-revalidate`, cortar redirects, otimizar a consulta |
| **Atraso de carga do recurso** | Do TTFB até o navegador *pedir* o recurso LCP | Imagem descoberta tarde (fundo em CSS, injetada por JS, `loading="lazy"` no hero) | `<img>` no HTML inicial com `fetchpriority="high"`; `preload` só se o trace mostrar descoberta tardia |
| **Tempo de carga do recurso** | Download do recurso LCP | Imagem pesada, tamanho errado, formato antigo | Redimensionar, `srcset`/`sizes`, AVIF/WebP, CDN de imagem |
| **Atraso de renderização** | Do recurso pronto até a pintura | CSS/JS bloqueando renderização, LCP montado no cliente, fonte bloqueando texto | Cortar CSS bloqueante, `defer` em JS, renderizar no servidor (SSR/SSG/streaming), `font-display: swap` |

Nunca `loading="lazy"` no elemento LCP. Não prometa "economia de X ms" genérica: meça a subparte antes e depois. Detalhes, código e Speculation Rules (prerender da próxima navegação) em `references/LCP.md`.

## INP — a pior interação da visita (aprox.)

INP mede o tempo de um clique, toque ou tecla até o próximo quadro pintado. Divida em três fases e otimize só a que o trace apontar:

| Fase | Evidência | Correção típica |
|---|---|---|
| **Atraso de entrada** | *Long tasks* (> 50 ms) já ocupando a thread principal quando o usuário interage — script de terceiro, inicialização, **hidratação** | Quebrar tarefas longas, adiar terceiros, reduzir/fatiar a hidratação (ilhas, componentes de servidor, carregar sob demanda) |
| **Processamento** | O próprio *event handler* e o trabalho síncrono que ele dispara (re-render grande, cálculo) | Tirar trabalho do handler, dar feedback visual antes, ceder a thread (`scheduler.yield()`), Web Worker para CPU pesada |
| **Atraso de apresentação** | Estilo, layout e pintura depois do handler | Reduzir o DOM afetado, evitar layout forçado (ler e escrever geometria intercalados), `content-visibility` em listas longas |

Hidratação é causa frequente em sites React/Vue: a página *parece* pronta, mas a thread está ocupada e o primeiro clique espera. Grave o trace **interagindo durante o carregamento**, não só depois. Padrões de código (ceder a thread, feedback antes do trabalho, observer de interações lentas) em `references/INP.md`.

## CLS — nada mexe sem o usuário pedir

CLS soma deslocamentos inesperados de layout durante a visita (cada um = fração de impacto × fração de distância). O elemento que *se moveu* costuma ser vítima — procure o que foi **inserido ou redimensionado acima** dele.

| Causa | Correção |
|---|---|
| Imagem, vídeo ou iframe sem dimensão | `width`/`height` no HTML ou `aspect-ratio` no contêiner |
| Anúncio, embed, componente assíncrono | Contêiner com altura mínima realista reservada |
| Banner de cookies, aviso, mensagem de validação inserido no topo | Sobreposição (overlay) ou espaço reservado antes do conteúdo chegar |
| Troca de fonte (fallback → web font com métrica diferente) | Fallback com `size-adjust`/`ascent-override` calculados para o par real de fontes; `font-display: optional` quando couber |
| Animação de `top`/`left`/`height`/`width` | Animar `transform` e `opacity` |
| Skeleton com altura diferente do conteúdo final | Skeleton com as mesmas dimensões |

Teste os estados que mudam layout (scroll, abrir menu, carregar mais, consentimento), não só a carga inicial, e em mais de uma largura. Código e checklist em `references/CLS.md`.

## Correção por framework (genérica)

| Problema | Princípio, em qualquer stack |
|---|---|
| Hero lento | Componente de imagem do framework com prioridade/eager no LCP, `sizes` correto, lazy em todo o resto |
| Conteúdo acima da dobra montado no cliente | Renderizar no servidor ou estático; streaming para o resto |
| JS demais na carga | Dividir por rota, importar sob demanda o que está abaixo da dobra ou atrás de interação |
| Hidratação travando o primeiro clique | Menos componentes interativos no cliente; hidratar sob demanda/visibilidade |
| Terceiros (chat, analytics, pixel) | Carregar depois da interação ou da ociosidade; medir o custo de cada um |
| Fontes | Auto-hospedar, `preload` só da fonte do LCP, subset, `font-display` |

Correções específicas de **React/Next.js** (`next/image` com `priority`, Server Components, `dynamic()`, `useTransition`, Suspense/streaming, `next/font`) estão em `/nextjs-react-best-practices` — use aquela skill, não duplique aqui.

## Quem faz o quê no pack

- **seo-performance (SHU)** mede, aponta a subparte/fase e a causa e escreve a especificação do fix; não altera código.
- **seo-google (SESHAT)** é a fonte dos números de campo (CrUX/GSC/PSI) quando a squad seo existe.
- **sites-dev-delta / dev-dev-delta** implementam a correção e provam com o mesmo trace antes/depois (`/verify-before-done`).

## Checklist de entrega

- [ ] Métrica reprovada identificada com fonte de campo, device e data (ou "sem dado de campo" declarado)
- [ ] Campo e laboratório rotulados separadamente
- [ ] Subparte do LCP / fase do INP / nó e gatilho do CLS identificados no trace
- [ ] Uma correção por vez, ligada à causa
- [ ] Mesmo trace, mesmas condições, antes e depois
- [ ] Data para reler o campo registrada; nenhuma afirmação de melhora de campo antes disso

## Referências

- `references/LCP.md` — subpartes, imagens, CSS crítico, SSR/streaming, Speculation Rules, observer
- `references/INP.md` — fases, ceder a thread, feedback antes do trabalho, terceiros, observer, atribuição em produção
- `references/CLS.md` — reserva de espaço, conteúdo dinâmico, fontes, animação, observer
- `/seo` → `references/cwv-thresholds.md` — fatos de SEO sobre CWV (ranking, CrUX, mitos)
- web.dev: artigos "LCP", "INP", "CLS" e "Optimize INP"

---

Adaptado de addyosmani/web-quality-skills → skills/core-web-vitals (MIT, commit afa8da9) — 2026-10-20; texto em pt-BR, reorganizado para o pack.
