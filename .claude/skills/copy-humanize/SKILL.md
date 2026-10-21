---
name: copy-humanize
description: "Checklist para tirar a \"cara de IA\" de texto em pt-BR — tiques estruturais (\"não é X, é Y\", tríades, \"O resultado?\", iscas, emoji-lista, travessão), léxico de clichês, painel manual de 5 sinais, caracteres invisíveis e ajuste por canal (legenda, roteiro, LinkedIn, proposta, anúncio, institucional). Use antes de entregar qualquer texto que alguém vá ler ou ouvir."
version: "1.0"
updated: "2026-10-20"
---

# Copy Humanize — texto que soa como gente

Texto gerado tem sotaque. Não é um erro isolado: é a soma de estruturas de efeito, palavras de folheto e tipografia perfeita demais. O leitor não precisa de detector para perceber; ele sente que está lendo uma marca, e rola a tela.

Esta skill é a **última passada** sobre um texto já certo no conteúdo. Ela não cria argumento, não inventa prova e não muda a voz da marca — a voz vem da plataforma da squad brand ou de `docs/smart-memory/project/marketing-context.md`. Se a marca usa uma palavra que está no léxico abaixo, a marca vence.

> **Ressalva honesta:** nada aqui promete passar em detector de IA (GPTZero, Originality, Turnitin etc.) e nenhum agente deve prometer isso ao usuário. O objetivo é texto melhor — mais específico, mais falado, mais nosso. Detector é efeito colateral, não meta.

Design (cor, layout, tipografia de interface) não é daqui: é da `/ui-craft`. Esta skill cuida só do texto.

## Ordem de trabalho

1. **Caracteres invisíveis** — limpa primeiro (seção 4), porque eles quebram buscas e contagem.
2. **Tiques estruturais** — procura cada um da seção 1 e reescreve à mão. Não existe substituição automática para estrutura.
3. **Léxico** — troca ou corta cada termo da seção 2.
4. **Tipografia** — seção 3, conforme o padrão do canal.
5. **Painel de 5 sinais** — seção 5. Sinal fraco → volta ao passo correspondente.
6. **Ajuste de canal** — seção 7.
7. **Entrega com recibo**: texto final + o que mudou (uma linha por tipo de mudança) + nota do painel. Nunca entregar só a nota.

Duas passadas é normal. Se precisou de cinco, o rascunho nasceu de fórmula: peça outro ângulo, não mais polimento.

## 1. Tiques estruturais — procurar e reescrever

| Tique | Exemplo típico | O que fazer |
|---|---|---|
| Contraste encenado | "Não é sobre vender, é sobre conectar." | Diga só a parte que importa, com um fato: "A gente vende melhor quando responde a DM em 10 minutos." |
| "Não só… mas também" | "Não só economiza tempo, mas também dinheiro." | Escolha o benefício maior e prove. |
| Tríade de adjetivos | "Simples, rápido e eficiente." | Um adjetivo com prova vale mais que três sem. Troque por um número ou cena. |
| Tríade de frases em série | "Mais clientes. Mais vendas. Mais liberdade." | Quebre o ritmo; mantenha uma e concretize. |
| Pergunta de uma palavra | "O resultado? Vendas triplicadas." | Afirme direto: "As vendas triplicaram em 60 dias." |
| Preâmbulo | "Neste post vamos falar sobre…", "Hoje eu vou te mostrar…" | Comece pelo primeiro fato útil. |
| Abertura que anuncia | "Vamos entender como isso funciona." | Corte. O texto seguinte já é o entendimento. |
| Fecho que recapitula | "Em resumo, vimos que…", "Resumindo:" | Termine na ação ou na frase mais forte; não repita o corpo. |
| Isca reflexa | "Segue pra mais", "Marca alguém que precisa ver", "Comenta SIM", "Salva pra não perder" | Uma única ação, ligada ao conteúdo e à estratégia ("Comenta PLANILHA que eu te mando o modelo"). Isca genérica sai. |
| Emoji como marcador de lista | "✅ Rápido ✅ Barato ✅ Fácil" | Hífen ou frase corrida. Emoji só onde a voz da marca usa e no máximo um por bloco. |
| Gancho gritado | "PARE DE ROLAR!", "ATENÇÃO:" | Gancho com fato ou tensão concreta, em caixa normal. |
| Muro de hashtags | 25 hashtags no fim | Siga a regra do canal (ver `/social-copywriting`); poucas e relevantes. |
| Frase de efeito final | "E isso muda tudo." | Corte ou troque pelo próximo passo concreto. |
| Simetria perfeita | Todos os parágrafos com 2 frases do mesmo tamanho | Varie: uma frase curta. Outra mais longa, que respira e explica o porquê. |

## 2. Léxico pt-BR de "cara de IA"

Não é lista proibida: é lista de suspeitos. Cada ocorrência precisa de um motivo para ficar.

**Verbos de folheto** — mergulhar (em), desbloquear, potencializar, alavancar, impulsionar, elevar (o seu negócio), transformar (a sua vida), revolucionar, otimizar (sem dizer o quê), destravar, navegar (por desafios), explorar (sem explorar nada), fomentar, catalisar.
→ Troque pelo verbo do que acontece: vender, cortar, responder, ligar, entregar, cobrar, aprender.

**Substantivos inflados** — jornada, universo, ecossistema, cenário, panorama, trajetória, pilares (quando não há pilares), solução (como sujeito), sinergia, protagonismo, mindset, game changer.

**Bordões de abertura** — "No mundo de hoje", "Nos dias atuais", "Em um mundo cada vez mais conectado", "Na era digital", "Você já parou para pensar…?", "Imagine só…", "Vamos combinar…".

**Muletas de ênfase** — "É importante ressaltar que", "Vale destacar que", "Cabe salientar", "Sem dúvida", "Certamente", "De fato", "Literalmente", "Simplesmente", "Verdadeiramente", "Absolutamente".

**Conectivos de redação escolar** — "Além disso" em todo parágrafo, "Ademais", "Outrossim", "Dessa forma", "Nesse sentido", "Por fim, mas não menos importante", "Em suma", "Em conclusão".

**Adjetivos vazios** — incrível, poderoso, robusto, inovador, disruptivo, completo, essencial, fundamental, crucial, perfeito, único (sem dizer em quê), de alto nível, de excelência.

**Iscas de rede** — "Segue pra mais conteúdo", "Marca aquele amigo", "Comenta aqui embaixo", "Deixa o seu like", "O algoritmo ama", "Corre que é por tempo limitado" (quando não é).

**Fórmulas de fechamento** — "E aí, o que você achou?", "Me conta nos comentários!", "Bora juntos?", "O futuro é agora".

Regra de troca: se a palavra some e a frase perde **informação**, ela fica. Se perde só **volume**, sai.

## 3. Marcas tipográficas

- **Travessão (—)**: no máximo um por parágrafo em texto longo; zero em legenda curta, anúncio e roteiro falado. Troque por vírgula, ponto ou dois-pontos.
- **Aspas**: siga o padrão do canal. Redes e anúncio: aspas retas (`"`). Proposta e institucional: o padrão do documento da marca — o que não pode é misturar curvas e retas no mesmo texto.
- **Reticências**: três pontos (`...`) ou o caractere único (`…`), um só padrão por peça.
- **Marcadores**: hífen em texto de rede; nunca o caractere `•` colado de outro lugar.
- **Negrito e caixa alta**: no máximo uma ênfase por bloco. Três palavras gritadas seguidas é tique.
- **Dois-pontos de revelação** ("A verdade é: …") contam como pergunta de uma palavra. Reescreva.

## 4. Caracteres invisíveis

Espaço de largura zero, marcas de direção, hífen suave, BOM e caracteres de tag Unicode não saem do teclado; aparecem em texto colado de geradores e ferramentas. Não se veem no editor, quebram busca e contagem de caracteres e funcionam como impressão digital.

Com a squad seo instalada, use o script dela (o modo `--json` mostra `invisible_removed`; a tabela de frases do script é em inglês, então em texto pt-BR conta só a limpeza de invisíveis — o léxico é a seção 2):

```bash
"${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run content_humanize.py rascunho.md -o limpo.md
cat rascunho.md | "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run content_humanize.py --json
```

Sem a squad seo, só **detectar** (a remoção é manual, no editor):

```bash
perl -CSD -ne 'print "$.: $_" if /[\x{00AD}\x{200B}-\x{200F}\x{202A}-\x{202E}\x{2060}-\x{2064}\x{FEFF}\x{E0000}-\x{E007F}]/' rascunho.md
```

O script preserva as junções que fazem parte de emoji composto. Só limpe texto do próprio usuário; não use isto para apagar a origem de conteúdo de terceiros.

## 5. Painel manual de 5 sinais

Leia o texto inteiro uma vez para cada sinal. Nota de 0 a 2 por sinal; **8 ou mais, sem nenhum zero**, está pronto.

| Sinal | 0 — soa gerado | 2 — soa gente | Como medir rápido |
|---|---|---|---|
| **Variação de frase** | Todas as frases com o mesmo tamanho e o mesmo ritmo | Curtas e longas misturadas; uma frase de 3 palavras em algum lugar | Conte as palavras das 6 primeiras frases. Diferença menor que 5 entre a maior e a menor = 0 |
| **Especificidade** | Nenhum número, nome, lugar, prazo ou cena | Pelo menos um dado concreto a cada parágrafo | Sublinhe cada número, nome próprio e cena. Parágrafo sem nenhum = falha |
| **Densidade de clichê** | 3+ termos da seção 2 a cada 100 palavras | Zero ou um, com motivo | Conte as ocorrências |
| **Marcas tipográficas** | Travessão em toda frase, aspas misturadas, emoji-lista, invisíveis | Pontuação comum, um padrão só | Busque `—`, `“`, `•` e rode a detecção da seção 4 |
| **Voz** | Impessoal, sem "eu/a gente/você", tiques da seção 1 presentes | Alguém fala com alguém; dá para ler em voz alta sem tropeçar | Leia em voz alta. Onde você tropeça ou soa locutor, reescreva |

Um único sinal em zero já denuncia o texto, por isso a regra do "nenhum zero" vale mais que a soma.

## 6. Antes e depois

**Legenda de Instagram (clínica de fisioterapia)**
- Antes: "Você já parou para pensar no impacto da postura na sua jornada de bem-estar? 🤔 Não é só sobre dor, é sobre qualidade de vida! ✅ Mais disposição ✅ Menos dor ✅ Mais foco. Segue pra mais dicas!"
- Depois: "Quem passa 8 horas sentado sente primeiro no pescoço, não na lombar. Teste agora: encoste a nuca na parede sem tirar os ombros. Não deu? Comenta POSTURA que eu te mando os 3 exercícios que a gente usa aqui na clínica."

**Post de LinkedIn (consultoria B2B)**
- Antes: "No cenário atual, é importante ressaltar que a transformação digital não é uma opção, é uma necessidade. Empresas inovadoras estão potencializando resultados e desbloqueando novas oportunidades. O segredo? Dados."
- Depois: "Uma distribuidora de Campinas cortou 11 dias do fechamento mensal trocando três planilhas por um painel. Não compraram software novo: o ERP já tinha os dados. Faltava alguém perguntar qual número o diretor olhava na segunda de manhã."

**Proposta comercial**
- Antes: "Nossa solução robusta e completa vai alavancar sua operação, garantindo eficiência, escalabilidade e excelência."
- Depois: "Em 30 dias, o time de vocês para de digitar pedido duas vezes. O pedido entra pelo WhatsApp e cai direto no ERP."

## 7. Por canal

- **Legenda** — primeira linha é o gancho e precisa caber antes do "mais"; zero preâmbulo; uma ação só; emoji conforme a voz, nunca como lista. Leia no celular, não no editor.
- **Roteiro (Reels, TikTok, Shorts, YouTube)** — vai ser **falado**: frases curtas, contrações ("tá", "pra", "a gente") se a voz permitir, zero travessão e zero parêntese. Leia em voz alta cronometrando; onde o apresentador respira fora de hora, a frase está longa. Texto de tela segue separado (ver `/social-scriptwriting`).
- **Post de LinkedIn** — as 2–3 linhas antes do "ver mais" carregam um fato ou tensão, nunca "No mundo de hoje". Nada de linha única por frase em todo o post (o "texto escadinha" virou tique). Prova com nome, número ou caso.
- **Proposta comercial** — a régua da `/sales-proposal-copy` vem primeiro (voz declarativa, número só com `#id`). Daqui entram o léxico e a tipografia: proposta é onde "robusto", "completo" e "excelência" mais aparecem e menos convencem.
- **Anúncio** — limite de caracteres não justifica clichê: cada palavra precisa vender. Sem "Descubra", "Incrível", "Não perca". Um benefício concreto + uma ação. Siga as políticas da plataforma (ver `/traffic-paid-ads-optimization`).
- **Texto institucional (sobre, manifesto, site)** — maior risco de folheto. Troque cada adjetivo por um fato da empresa (ano, cidade, quantos clientes, como o trabalho é feito). Manifesto e tagline são da squad brand; aqui só se revisa o acabamento.

## Regras

- Nunca inventar número, nome ou caso para "ganhar especificidade". Sem dado real, peça ao strategist ou deixe `[DADO]`.
- Nunca mudar o sentido para limpar um tique. Se a reescrita muda a promessa, volte ao autor.
- A voz da marca vence o léxico desta skill. Registre exceções no `marketing-context.md` (seção de palavras) ou no guia de voz da brand.
- Não prometer "indetectável" nem citar nota de detector externo como garantia.
