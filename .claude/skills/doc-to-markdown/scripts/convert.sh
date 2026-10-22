#!/usr/bin/env bash
# doc-to-markdown — converte um documento local em Markdown, sem rede.
# Uso: convert.sh <arquivo> [saida.md]
# Saída (stdout, uma por linha): OUT=<caminho>  TOOL=<ferramenta>  PAGES=<n>  PENDING=ocr|csv  OCR_LOCAL=<ferramenta>
# Nunca imprime o conteúdo convertido: o agente lê o .md pelo caminho.
set -uo pipefail

in="${1:-}"
[ -n "$in" ] && [ -f "$in" ] || { echo "ERRO=arquivo não encontrado: ${in:-<vazio>}" >&2; exit 2; }
out="${2:-$in.md}"
ext="$(printf '%s' "${in##*.}" | tr '[:upper:]' '[:lower:]')"
has() { command -v "$1" >/dev/null 2>&1; }
pandoc_reads() { has pandoc && pandoc --list-input-formats 2>/dev/null | grep -qx "$1"; }

tool=""; pages=""; pending=""; ocr_local=""; aviso=""
body="$(mktemp "${TMPDIR:-/tmp}/d2m.XXXXXX")"
trap 'rm -f "$body"' EXIT

case "$ext" in
  pdf)
    has pdfinfo && pages="$(pdfinfo "$in" 2>/dev/null | awk '/^Pages:/{print $2}')"
    if has pdftotext; then
      tool="pdftotext -layout"
      pdftotext -layout -enc UTF-8 "$in" "$body" 2>/dev/null || true
      aviso="Extraído de PDF com layout: conferir números e tabelas contra o original."
      # PDF escaneado: quase nenhum caractere visível por página
      chars="$(tr -d '[:space:]' < "$body" | wc -c | tr -d ' ')"
      if [ "${chars:-0}" -lt $(( ${pages:-1} * 20 )) ]; then
        pending="ocr"
        for t in ocrmypdf tesseract; do has "$t" && { ocr_local="$t"; break; }; done
        printf '[DOC PENDENTE — precisa de OCR local]\n' > "$body"
      fi
    else
      pending="tool"; echo "ERRO=pdftotext ausente (instale poppler) ou use o Read nativo em PDF pequeno" >&2
    fi ;;
  docx|odt|rtf|html|htm|epub|pptx)
    fmt="$ext"; [ "$ext" = "htm" ] && fmt="html"
    if pandoc_reads "$fmt"; then
      tool="pandoc -f $fmt -t gfm"
      pandoc -f "$fmt" -t gfm --wrap=none "$in" -o "$body" 2>/dev/null || { echo "ERRO=pandoc falhou" >&2; exit 1; }
    else
      pending="tool"; echo "ERRO=pandoc ausente ou sem leitor $fmt" >&2
    fi ;;
  xlsx|xlsm)
    if pandoc_reads xlsx; then
      tool="pandoc -f xlsx -t gfm"
      pandoc -f xlsx -t gfm --wrap=none "$in" -o "$body" 2>/dev/null || pending="csv"
    elif has xlsx2csv; then
      tool="xlsx2csv"
      { echo '```csv'; xlsx2csv --all "$in"; echo '```'; } > "$body" 2>/dev/null || pending="csv"
    elif python3 -c 'import openpyxl' 2>/dev/null; then
      tool="python3+openpyxl"
      python3 -I - "$in" > "$body" <<'PY' || pending="csv"
import sys, openpyxl
wb = openpyxl.load_workbook(sys.argv[1], read_only=True, data_only=True)
for ws in wb.worksheets:
    print(f"## {ws.title}\n")
    rows = [["" if c is None else str(c).replace("|", "\\|") for c in r] for r in ws.iter_rows(values_only=True)]
    rows = [r for r in rows if any(r)]
    if not rows: print("_(vazia)_\n"); continue
    w = max(len(r) for r in rows)
    rows = [r + [""] * (w - len(r)) for r in rows]
    print("| " + " | ".join(rows[0]) + " |"); print("|" + " --- |" * w)
    for r in rows[1:]: print("| " + " | ".join(r) + " |")
    print()
PY
    else
      pending="csv"
    fi
    [ "$pending" = "csv" ] && printf '[DOC PENDENTE — exportar a planilha como CSV]\n' > "$body" ;;
  csv|tsv)
    if pandoc_reads "$ext"; then tool="pandoc -f $ext -t gfm"; pandoc -f "$ext" -t gfm "$in" -o "$body"
    else tool="cat"; { echo '```'"$ext"; cat "$in"; echo '```'; } > "$body"; fi ;;
  txt|md)
    tool="cat"; cat "$in" > "$body" ;;
  *)
    echo "ERRO=extensão não suportada: .$ext" >&2; exit 2 ;;
esac

{
  echo "<!-- doc-to-markdown"
  echo "origem: $in"
  echo "ferramenta: ${tool:-nenhuma}"
  echo "data: $(date '+%Y-%m-%d %H:%M')"
  [ -n "$pages" ] && echo "páginas: $pages"
  [ -n "$aviso" ] && echo "aviso: $aviso"
  [ -n "$pending" ] && echo "pendente: $pending"
  echo "-->"
  echo
  cat "$body"
} > "$out"

echo "OUT=$out"
echo "TOOL=${tool:-nenhuma}"
[ -n "$pages" ] && echo "PAGES=$pages"
[ -n "$pending" ] && echo "PENDING=$pending"
[ -n "$ocr_local" ] && echo "OCR_LOCAL=$ocr_local"
exit 0
