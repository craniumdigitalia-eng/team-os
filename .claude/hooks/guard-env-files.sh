#!/usr/bin/env bash
# .claude/hooks/guard-env-files.sh
# PreToolUse hook (matcher "Edit|Write|MultiEdit") — OPCIONAL: protege segredos e lockfiles.
# NÃO é registrado por padrão. Só entra no projeto com OK do usuário:
#   install-to-project.sh --with-env-guard   (copia o hook e registra no .claude/settings.json)
# A ideia vem das "Automações sugeridas" que o discovery.sh escreve em project/tech-stack.md.
#
# O que BLOQUEIA (exit 2 + motivo em stderr):
#   • .env e .env.* (ex.: .env.local, .env.production) — segredo real nunca é escrito por agente;
#   • lockfiles: package-lock.json, pnpm-lock.yaml, yarn.lock, bun.lockb, poetry.lock, Cargo.lock
#     — lockfile muda pelo gerenciador de pacotes (npm/pnpm/yarn/bun/poetry/cargo), nunca à mão.
# O que LIBERA: .env.example, .env.sample, .env.template (modelos sem segredo) e qualquer outro
#   arquivo. Ferramentas que não sejam Edit/Write/MultiEdit (ex.: Bash) passam sem análise.
#
# Entrada: JSON do Claude Code via stdin — {"tool_name":"Write","tool_input":{"file_path":"..."}}.
# Defensivo: JSON inválido ou sem file_path → exit 0 (nunca quebra o fluxo).
# bash 3.2-safe. python3 no caminho principal; se faltar/falhar, aviso ⚠️ em stderr e fallback sed.
# Desligar pontualmente: TEAM_OS_ENV_GUARD=0 no ambiente da sessão.

INPUT=$(cat)

[ "${TEAM_OS_ENV_GUARD:-1}" = "0" ] && exit 0

TOOL=""
FILE=""
PARSED=""
if command -v python3 >/dev/null 2>&1; then
  PARSED=$(printf '%s' "$INPUT" | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    print("NOPARSE"); sys.exit(0)
ti = d.get("tool_input") or {}
if not isinstance(ti, dict):
    ti = {}
fp = ti.get("file_path") or ""
if not isinstance(fp, str):
    fp = ""
print("OK\t" + (d.get("tool_name") or "") + "\t" + fp.replace("\n", " "))
' 2>/dev/null)
  [ $? -eq 0 ] || PARSED=""
fi

case "$PARSED" in
  NOPARSE) exit 0 ;;
  OK*)
    TOOL=$(printf '%s' "$PARSED" | cut -f2)
    FILE=$(printf '%s' "$PARSED" | cut -f3-)
    ;;
  *)
    echo "⚠️ guard-env-files.sh: python3 indisponível ou falhou — usando fallback sed." >&2
    FLAT=$(printf '%s' "$INPUT" | tr '\n' ' ')
    TOOL=$(printf '%s' "$FLAT" | sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
    FILE=$(printf '%s' "$FLAT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
    ;;
esac

case "$TOOL" in
  Edit|Write|MultiEdit) ;;
  *) exit 0 ;;
esac
[ -n "$FILE" ] || exit 0

BASE="${FILE##*/}"

block() {
  echo "🚫 BLOQUEADO: $1" >&2
  echo "" >&2
  echo "Arquivo: $FILE" >&2
  echo "" >&2
  echo "$2" >&2
  echo "Este bloqueio é o hook opcional guard-env-files.sh (instalado com o seu OK)." >&2
  echo "Se a edição for mesmo necessária, peça ao usuário para fazê-la à mão." >&2
  exit 2
}

case "$BASE" in
  .env.example|.env.sample|.env.template) exit 0 ;;
  .env|.env.*)
    block "edição de arquivo .env." \
      "Arquivos .env guardam segredos reais. Documente a variável nova em .env.example (sem valor) e peça ao usuário para preencher o .env."
    ;;
  package-lock.json|pnpm-lock.yaml|yarn.lock|bun.lockb|poetry.lock|Cargo.lock)
    block "edição manual de lockfile." \
      "Lockfile só muda pelo gerenciador de pacotes (npm install, pnpm add, yarn add, bun add, poetry add, cargo update) — rode o comando em vez de editar o arquivo."
    ;;
esac

exit 0
