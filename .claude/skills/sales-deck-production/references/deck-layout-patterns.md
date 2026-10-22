# Padrões de layout de slide (deck 16:9)

Catálogo de layouts para a variante deck (§6 da SKILL). Cada slide é uma `<section class="page">` 16:9; o layout organiza **o que já está na copy aprovada** — não cria texto, número nem asserção. Cor, tipografia, raio e sombra vêm do design system do projeto (`docs/smart-memory/project/brand.md`); as classes abaixo só dão a estrutura.

## Escolha do layout pelo objetivo do slide

| Layout | Quando usar | Componente da SKILL |
|---|---|---|
| Capa | Abertura, nome do cliente e da proposta | `cover` |
| Abertura (asserção grande) | Aberturas I/II/III do arco | `opener` |
| Diagnóstico | A dor na linguagem do cliente (ficha de intake) | `content` |
| Visão da solução | O que muda, em uma frase-asserção + 3 apoios | `content` |
| Grade de entregas (3–6 cards) | Escopo, módulos, capacidades | `content` |
| Painel de métricas (3–4 números) | Números da ficha, cada um com `#id` | `content` |
| Número único em destaque | Um número que carrega o slide (payback, economia) | `content` |
| Comparativo / tabela | Alternativas, antes × depois | `table` |
| Linha do tempo | Roadmap com marcos e critério de aceite | `content` |
| Duas colunas | Contraste, problema × proposta | `content` |
| Depoimento / caso | Prova de terceiro, com fonte | `content` |
| Tela do produto | Captura real (nunca mock com dado inventado) | `content` |
| Investimento | Estrutura comercial — **sempre depois do slide de valor** | `table` |
| Próximo passo | Uma ação, com data e responsável | `closing` |

## Estruturas CSS (dentro da `.page` 16:9, unidades em mm)

```css
/* Capa e abertura: conteúdo centralizado */
.slide-center { display: flex; flex-direction: column; justify-content: center; align-items: flex-start; height: 100%; padding: 18mm 22mm; box-sizing: border-box; }

/* Duas colunas */
.slide-split { display: grid; grid-template-columns: 1fr 1fr; gap: 14mm; align-items: center; height: 100%; padding: 16mm 20mm; box-sizing: border-box; }

/* Grade de entregas (3 colunas; 6 cards = 2 linhas) */
.slide-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 7mm; }

/* Painel de métricas (até 4) */
.slide-metrics { display: grid; grid-template-columns: repeat(4, 1fr); gap: 6mm; }
.metric-value { font-size: 40pt; line-height: 1; font-variant-numeric: tabular-nums; }
.metric-label { font-size: 14pt; }
.metric-source { font-size: 10pt; opacity: .7; } /* origem do número, quando o slide pede */

/* Linha do tempo horizontal */
.slide-timeline { display: grid; grid-auto-flow: column; grid-auto-columns: 1fr; gap: 5mm; border-top: 0.6mm solid currentColor; padding-top: 6mm; }
```

Sem breakpoints de celular: o deck é exportado em 16:9 fixo e apresentado em tela cheia. Corpo nunca abaixo de 18 pt (§6 da SKILL).

## Variações de componente

| Componente | Uso |
|---|---|
| Card com ícone à esquerda | Entregas com ícone (SVG do design system) |
| Card com barra de acento | A entrega que o slide destaca — no máximo uma por slide |
| Card de métrica | Número + rótulo + origem |
| Card de pessoa | Time responsável (foto real, nome, papel) |
| Card de plano | Opções de investimento — destaque só se a estrutura comercial aprovada indicar uma recomendada |

## Tratamentos visuais

| Tratamento | Quando |
|---|---|
| Fundo cheio da cor de marca | Capa, aberturas e próximo passo — quebra o ritmo |
| Borda discreta | Diagnóstico e tabelas |
| Sombra em captura de tela | Tela do produto |
| Par de contraste | Antes × depois |
| Logos em escala de cinza | Clientes/parceiros, só com autorização registrada |
| Imagem de fundo com sobreposição | Só imagem **local** com direito de uso; nunca URL de banco de imagens no export |

Evitar: texto com gradiente, animação de entrada, contagem animada de número (o PDF não anima e o número precisa ser lido parado).

## Fluxo de decisão do layout

1. **Qual é a asserção do slide?** (vem da copy) → escolha o layout pela tabela acima.
2. **Quanto conteúdo cabe?** Uma ideia por slide; se não cabe, é overflow — volta para a redatora (§5 da SKILL), não se reduz a fonte abaixo do mínimo.
3. **Precisa quebrar o ritmo?** Perto de 1/3 e 2/3 do deck, um slide de fundo cheio ou número único em destaque renova a atenção.
4. **Gráfico?** SVG inline gerado a partir da ficha de números (ver `deck-navigation.md` §Gráficos).
