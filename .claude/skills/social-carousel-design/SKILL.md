---
name: social-carousel-design
description: "Design de carrosséis para redes sociais — capa de até 6 palavras, slide 2 como segunda capa, uma ideia por slide, recap para print, CTA único, numeração, @ e alt text, produzidos no Stitch. Use ao criar carrossel para Instagram ou LinkedIn, estruturar a sequência de slides, definir capa e CTA final ou validar specs antes da produção."
version: "1.2"
updated: "2026-10-20"
---

# Social Carousel Design — Estrutura e Padrões

> Skill injetada no agente AEON (social-design). Núcleo comum a carrosséis; o que só vale para o Instagram está na seção **Instagram** no fim. Ferramenta de produção: **Google Stitch** (`/social-stitch-workflow`).

## 1. Carrossel ou vídeo?

Carrossel quando a ideia tem **sequência e vale ser relida**: passos, um método com partes, antes/depois, uma lista que dá vontade de printar. Vídeo quando a ideia tem movimento, rosto ou um resultado que precisa ser visto acontecendo. Se a ideia é uma frase só, não é nenhum dos dois — devolva para `/social-scriptwriting` ou para um post único e diga por quê.

## 2. Estrutura (6–10 slides)

```
1        CAPA       o gancho. ≤6 palavras, legível na miniatura do grid.
                    Uma linha de promessa embaixo, menor.
2        2ª CAPA    por que importa, em uma frase. A plataforma pode reapresentar
                    o carrossel a partir do slide 2 para quem não interagiu —
                    então ele precisa funcionar sozinho. Nunca é "introdução".
3 a N    UMA IDEIA POR SLIDE. Título de 3–7 palavras + no máximo 25 palavras.
                    Precisou de parágrafo? São dois slides.
N+1      RECAP      tudo em lista, legível sem contexto. É o slide que vira print
                    e é enviado — envio é o sinal mais forte que se ganha.
ÚLTIMO   CTA        UMA ação: salvar, comentar uma palavra ou seguir. Uma.
```

Menos de 5 slides e o deslize nem começa; mais de 10 vira livro que ninguém termina.

## 3. Regras de texto e layout

- **A capa decide o resultado.** ≤6 palavras, grande. Nada no resto salva capa que ninguém desliza.
- **≤25 palavras por slide** (título + corpo). Contraste mínimo 4,5:1 (WCAG AA).
- **Numeração visível** no formato **"3/8"** em todos os slides — saber onde termina aumenta a conclusão.
- **@ do perfil em todos os slides**, pequeno, canto fixo. Print viaja sem você.
- **CTA único** e igual ao da legenda (mesma keyword, se houver).
- **Alt text** no mínimo da capa (idealmente de todos): o que aparece + o texto principal do slide. Entregue junto com a arte.
- Tipografia: mesma família em todos os slides, variando só tamanho/peso; corpo nunca abaixo de ~32 px no quadro de 1080 de largura (é lido a um terço do tamanho real).
- Uma cor de destaque. Paleta, fontes e logo vêm do design system/KV do projeto — nunca inventar marca.
- Elemento recorrente (forma, linha, cor de fundo) para costurar a sequência.

## 4. Specs

| Plataforma | Formato padrão | Slides | Resolução |
|---|---|---|---|
| Instagram | **4:5** | 6–10 (técnico: até 20) | **1080×1350** |
| Facebook | 4:5 ou 1:1 | 6–10 | 1080×1350 / 1080×1080 |
| LinkedIn | documento (PDF) | 6–10 | 1080×1350 em PDF |

## 5. Modelos por objetivo

```
Educativo:   capa "N erros que…" → 2ª capa (o custo do erro) → 1 erro + correção por slide → recap → CTA salvar
Passo a passo: capa com o resultado → 2ª capa (por que esse método) → passos numerados → recap → CTA
Antes/depois: capa com o contraste → 2ª capa (o problema, sentido na pele) → antes → depois → alavanca → recap → CTA
```

## 6. Fluxo de produção

1. **Copy slide a slide primeiro**, como lista numerada que o usuário lê em 10 segundos e corrige antes de qualquer arte:
   ```
   CARROSSEL · 8 slides
   1 CAPA    A CLÁUSULA DE {{R$}}
             Uma linha que agora vai em todo contrato.
   2 2ªCAPA  Aprovei o trabalho. Nove dias depois pediram o dinheiro de volta.
   3         O QUE ELA DIZ — Pagamento na entrega, não na aprovação.
   …
   7 RECAP   As quatro linhas, em ordem.
   8 CTA     Comenta CONTRATO que eu te mando a cláusula.
   ```
2. Legenda pela `/social-copywriting` — carrossel é **Job B** (a capa já usou as 6 palavras).
3. Arte no **Stitch** (`/social-stitch-workflow`) a 1080×1350, uma tela por slide, só depois da copy aprovada.
4. Exportar, conferir numeração/@/contraste em cada slide e anexar alt text.

## Instagram

- 1080×1350 (4:5), JPEG ou PNG. O grid do perfil recorta a capa num retângulo vertical cuja proporção já mudou mais de uma vez: mantenha o texto da capa **no centro, longe de ~120 px de cada borda**, e o recorte deixa de importar.
- O Instagram pode reexibir o carrossel a partir do slide 2 para quem não interagiu — mais um motivo para a 2ª capa ser autônoma.
- Alt text: "Configurações avançadas → Acessibilidade" ao publicar (por imagem).
