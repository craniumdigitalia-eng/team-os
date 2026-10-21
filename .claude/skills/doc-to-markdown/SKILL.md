---
name: doc-to-markdown
description: "Converter PDF, DOCX, XLSX, PPTX, ODT, RTF e HTML locais em Markdown na própria máquina — pandoc, pdftotext, openpyxl — para o agente ler pelo caminho sem gastar tokens com binário. Nada sai da máquina; PDF escaneado vira pendência de OCR local. Use ao receber extrato, nota, contrato, minuta, planilha ou deck de cliente."
version: "1.0"
updated: "2026-10-20"
---

# Documento → Markdown (local)

Agente não lê binário bem e paga caro por isso. Esta skill transforma o documento em um `.md` **na mesma máquina**, com tabelas preservadas e cabeçalho de origem, e o agente passa a trabalhar com o **caminho** do `.md` — nunca com o conteúdo colado no prompt.

## Regra zero — o documento não sai da máquina

Contrato, extrato, nota fiscal, holerite, documento com CPF/CNPJ: **nenhuma conversão usa serviço externo**.

- PROIBIDO `--ocr hosted`, API de "parse" na nuvem, upload para conversor online, MCP que envie o arquivo.
- PROIBIDO baixar ferramenta nova sem o usuário pedir. Use o que já está instalado (`command -v`).
- Se nenhuma ferramenta local resolve: **pare e peça ao usuário** (exportar CSV, instalar a ferramenta, mandar versão com texto). Pendência declarada vale mais que conversão vazada.

## Ordem de ferramentas

Verifique antes: `command -v pandoc pdftotext pdfinfo xlsx2csv ocrmypdf tesseract`.

| Entrada | 1ª escolha | Alternativa | Se nada servir |
|---|---|---|---|
| PDF pequeno (≤ ~10 páginas, só para ler) | **Read nativo** do Claude Code | `pdftotext -layout` | — |
| PDF de texto (maior, ou para guardar) | `pdftotext -layout` (poppler) | Read nativo em faixas de páginas | pedir `brew install poppler` |
| PDF escaneado (sem camada de texto) | `ocrmypdf` / `tesseract` **locais**, se instalados | — | `[DOC PENDENTE — precisa de OCR local]` |
| DOCX, ODT, RTF, HTML, EPUB | `pandoc -t gfm` | — | pedir ao usuário salvar como PDF de texto |
| PPTX | `pandoc -f pptx` (pandoc recente) | Read nativo do PDF exportado | pedir export em PDF |
| XLSX | `pandoc -f xlsx` **só se** `pandoc --list-input-formats` listar `xlsx` | `xlsx2csv`, ou `python3` com `openpyxl` se já instalado | **pedir ao usuário exportar CSV** |
| CSV / TSV | `pandoc -f csv` (vira tabela) | ler direto | — |
| `@firecrawl/anydoc` (opcional) | ver seção própria | — | — |

Observações:

- `python3` puro (stdlib) **não** lê xlsx de forma confiável — não improvise parser de XML.
- pandoc antigo não lê `xlsx` nem `pptx`; confira a lista de formatos antes de prometer.
- `.doc`, `.xls` e `.ppt` (formatos binários antigos): peça ao usuário salvar como `.docx`/`.xlsx`/`.pdf`.

## Script — `convert.sh`

Detecta a extensão, escolhe a ferramenta disponível, grava o `.md` e imprime só metadados (nunca o conteúdo):

```bash
bash "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/doc-to-markdown/scripts/convert.sh" "<arquivo>" ["<saida.md>"]
```

Saída, uma chave por linha:

| Chave | Significado |
|---|---|
| `OUT=` | caminho do `.md` gerado (padrão: `<arquivo>.md`, ao lado do original) |
| `TOOL=` | ferramenta usada (`pdftotext -layout`, `pandoc -f docx -t gfm`, `python3+openpyxl`…) |
| `PAGES=` | páginas do PDF (via `pdfinfo`) |
| `PENDING=ocr` | PDF sem texto — precisa de OCR local |
| `PENDING=csv` | planilha sem leitor local — pedir CSV |
| `OCR_LOCAL=` | `ocrmypdf` ou `tesseract` encontrado — oferecer ao usuário |

Código de saída: `0` gerou o `.md` (mesmo com pendência), `1` a ferramenta falhou, `2` arquivo inexistente ou extensão não suportada. O script não acessa rede.

## Onde salvar

- **Padrão:** ao lado do original — `extrato-2026-09.pdf` → `extrato-2026-09.pdf.md`.
- **Pasta do original é só leitura, compartilhada ou do cliente:** salve na pasta de trabalho da sua área (ex.: `docs/smart-memory/agents/finance/<área>/fontes/`) passando o 2º argumento.
- Nunca dentro de `_archive/`, nunca em pasta versionada pública se o documento tem dado pessoal.

## Cabeçalho obrigatório do `.md`

Todo `.md` convertido começa com um comentário que diz de onde veio:

```markdown
<!-- doc-to-markdown
origem: contratos/fornecedor-x.pdf
ferramenta: pdftotext -layout
data: 2026-10-20 14:32
páginas: 12
aviso: Extraído de PDF com layout: conferir números e tabelas contra o original.
-->
```

- O `aviso` é obrigatório em todo PDF: `pdftotext -layout` alinha colunas por espaço e pode quebrar tabela, juntar colunas ou trocar vírgula decimal de lugar.
- Converteu manualmente (Read nativo, outra ferramenta)? Escreva o mesmo cabeçalho à mão.

## Passo a passo

1. **Confirme o arquivo** e o objetivo: só ler uma cláusula? Read nativo pode bastar. Extrair valores ou reler várias vezes? Converta.
2. **Rode o `convert.sh`** (ou a ferramenta da tabela) e guarde `OUT=`.
3. **Trate pendências:**
   - `PENDING=ocr` com `OCR_LOCAL=ocrmypdf` → ofereça ao usuário: `ocrmypdf --skip-text <in.pdf> <out.pdf>` e reconverta o `out.pdf`. Com `tesseract`: `tesseract <página.png> - -l por`. Sem nenhum → registre `[DOC PENDENTE — precisa de OCR local]` na sua entrega e peça ao usuário.
   - `PENDING=csv` → peça ao usuário exportar a planilha como CSV (uma aba por arquivo).
4. **Confira amostra:** abra só o trecho que importa (`Read` com `offset`/`limit`, ou `grep -n` pelo termo) e compare 2–3 números com o original.
5. **Passe o caminho, não o texto:** na mensagem ao colega ou no DIGEST, cite `OUT=` + o trecho/linha relevante. Nunca cole o documento inteiro em mensagem, task ou prompt.

## Ler o `.md` gastando pouco

- `wc -l <arquivo>.md` antes de abrir; acima de ~400 linhas, leia por faixas.
- `grep -n -i "valor\|vencimento\|multa" <arquivo>.md` para achar a seção e ler só ela.
- Tabelas grandes de planilha: filtre a aba/linhas que interessam antes de levar ao raciocínio.

## Tabelas

- pandoc → tabela GFM (`| a | b |`) direto. Confira cabeçalho e alinhamento.
- `pdftotext -layout` → colunas por espaço. Se a tabela for usada em cálculo, reescreva só ela em GFM e marque `(transcrita de PDF — conferir)`.
- Número em pt-BR (`1.234,56`) fica como está no `.md`; converta só no cálculo, declarando a conversão.

## `@firecrawl/anydoc` — opcional, com versão fixa

Útil quando pandoc/poppler não estão instalados e há Node 20+. Só com versão fixa e sem OCR remoto:

```bash
npx --yes @firecrawl/anydoc@0.2.4 "<arquivo>" -o "<arquivo>.md"
```

- Versão fixa `0.2.4` (publicada em 27/08/2026). Nunca `npx -y @firecrawl/anydoc` sem versão.
- **Nunca** `--ocr hosted`, `--api-key` nem `FIRECRAWL_API_KEY`: isso envia o documento a serviço externo. Saída `3` do anydoc = PDF precisa de OCR → siga o passo 3 acima.
- O 1º uso baixa o pacote do npm: peça OK ao usuário antes.
- Escreva o cabeçalho obrigatório à mão depois.

## Checklist antes de entregar

- [ ] Nenhum serviço externo tocou no documento
- [ ] `.md` com cabeçalho (origem, ferramenta, data, páginas, aviso se PDF)
- [ ] Pendência marcada (`[DOC PENDENTE — …]`) em vez de conteúdo vazio
- [ ] 2–3 números conferidos contra o original
- [ ] Mensagem/entrega cita o caminho, não o conteúdo inteiro

## Anti-padrões

- Colar o texto do contrato inteiro na mensagem para o colega.
- "Resolver" PDF escaneado mandando para OCR online.
- Tratar `.md` de `pdftotext` como verdade sem conferir números.
- Inventar valor de célula que a conversão perdeu — marque pendência.
