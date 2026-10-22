#!/usr/bin/env bash
# migrate-sala-to-ct.sh — traz a Sala de Controle de uma pasta antiga (ex.: "1 | Sala de Controle",
# ou uma pasta do maestri-os) para dentro do CT: a memória passa a morar em
# CT/docs/smart-memory/sala-de-controle/ (ignorada pelo git) e a pasta antiga vai para a Lixeira.
#
# Uso: migrate-sala-to-ct.sh <pasta-antiga> [--apply] [--ct <CT>]   (padrão: o CT onde este script está)
#
# Padrão = DRY-RUN: imprime o plano (KEY=valor) + RESUMO em pt-BR e não grava nada.
#   COPY=<origem>|<destino>   cada .md de docs/smart-memory/sala-de-controle/ (menos PANORAMA.md) e de
#                             docs/smart-memory/maestri/ (→ sala-de-controle/historico-maestri/)
#   SKIP_REGEN=PANORAMA.md|snapshot.json   não são copiados: a Sala regenera os dois
#   SAME=<destino>            o CT já tem o arquivo igual (nada a fazer — 2ª execução é idempotente)
#   RENAME=<arquivo>-da-pasta-antiga.md   colisão: o CT já tem um arquivo diferente com esse nome
#   SESSIONS_OPEN=<nomes>     sessões do Claude Code abertas com cwd na pasta antiga (lê só
#                             ~/.claude/sessions/*.json e confere se o pid está vivo)
#   TRASH=<pasta-antiga>      vai para a Lixeira no --apply
# --apply: cria a pasta da Sala no CT, copia (nunca sobrescreve), anota a migração no registry.md e
#   no dispatches.md, garante um INDEX.md mínimo em CT/docs/smart-memory/ e manda a pasta antiga
#   para a Lixeira com trash.sh. Com sessão aberta na pasta antiga, copia a memória e NÃO manda para a
#   Lixeira (HOLD_TRASH=sessions_open) — feche as sessões e rode de novo com --apply.
# Nunca: git, rm, mexer em .claude/ do CT ou em qualquer outra pasta; gravar memória da Sala se
# docs/smart-memory/ não estiver no .gitignore do CT (ERROR).
# Saída: KEY=valor · exit 0 ok · 1 falha · 2 uso incorreto/recusa. Bash 3.2-safe; precisa de python3.

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
OLD=""
APPLY=0

usage() { echo "Uso: migrate-sala-to-ct.sh <pasta-antiga> [--apply] [--ct <CT>]" >&2; }
need_value() { if [ $# -lt 2 ] || [ -z "$2" ]; then echo "ERROR=missing_value|$1 exige um valor" >&2; exit 2; fi; }

while [ $# -gt 0 ]; do
  case "$1" in
    --ct)      need_value "$1" "${2:-}"; CT="$2"; shift 2 ;;
    --apply)   APPLY=1; shift ;;
    --dry-run) APPLY=0; shift ;;
    -h|--help) usage; exit 0 ;;
    -*)        echo "ERROR=unknown_flag|$1" >&2; usage; exit 2 ;;
    *)         if [ -z "$OLD" ]; then OLD="$1"; shift; else echo "ERROR=extra_arg|$1" >&2; usage; exit 2; fi ;;
  esac
done

[ -n "$OLD" ] || { echo "ERROR=missing_old_folder" >&2; usage; exit 2; }
[ -d "$OLD" ] || { echo "ERROR=old_not_found|$OLD"; exit 2; }
OLD="$(cd "$OLD" && pwd)"
CT="$(cd "$CT" 2>/dev/null && pwd)" || { echo "ERROR=ct_not_found"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "ERROR=python3_missing"; exit 1; }

# Recusas: a pasta antiga não pode ser o CT, estar dentro dele, contê-lo, nem ser HOME ou /
[ "$OLD" != "$CT" ] || { echo "ERROR=old_is_ct|a pasta antiga não pode ser o próprio CT"; exit 2; }
case "$OLD/" in "$CT/"*) echo "ERROR=old_inside_ct|a pasta antiga está dentro do CT"; exit 2 ;; esac
case "$CT/" in "$OLD/"*) echo "ERROR=old_contains_ct|a pasta antiga contém o CT — nunca vai para a Lixeira"; exit 2 ;; esac
[ "$OLD" != "/" ] && [ "$OLD" != "$(cd "$HOME" 2>/dev/null && pwd)" ] || { echo "ERROR=old_is_home_or_root"; exit 2; }
if [ ! -d "$OLD/.claude/skills/sala-de-controle" ] && [ ! -d "$OLD/.claude/skills/maestri-os" ] \
   && [ ! -d "$OLD/docs/smart-memory/sala-de-controle" ] && [ ! -d "$OLD/docs/smart-memory/maestri" ]; then
  echo "ERROR=not_a_sala_folder|$OLD não tem .claude/skills/sala-de-controle, .claude/skills/maestri-os nem docs/smart-memory/{sala-de-controle,maestri}"
  exit 2
fi

# A memória da Sala só pode ir para caminho ignorado pelo git
if ! grep -qE '^[[:space:]]*/?docs/smart-memory(/|/\*\*?)?[[:space:]]*$' "$CT/.gitignore" 2>/dev/null; then
  echo "ERROR=smart_memory_not_ignored|docs/smart-memory/ não está no .gitignore do CT — a memória da Sala não pode ir para caminho versionado"
  exit 1
fi
[ -f "$SCRIPT_DIR/trash.sh" ] || [ -f "$CT/.claude/skills/team-os-creator/scripts/trash.sh" ] || { echo "ERROR=trash_sh_missing"; exit 1; }
TRASH_SH="$CT/.claude/skills/team-os-creator/scripts/trash.sh"
[ -f "$TRASH_SH" ] || TRASH_SH="$SCRIPT_DIR/trash.sh"

echo "OLD=$OLD"
echo "CT=$CT"
echo "MODE=$([ $APPLY -eq 1 ] && echo apply || echo dry-run)"

PYOUT="$(python3 - "$OLD" "$CT" "$APPLY" "$HOME" <<'PYEOF'
import datetime, json, os, shutil, sys

OLD, CT, APPLY, HOME = sys.argv[1], sys.argv[2], sys.argv[3] == "1", sys.argv[4]
TODAY = datetime.date.today().isoformat()
REGEN = {"PANORAMA.md", "snapshot.json"}
SUFFIX = "-da-pasta-antiga"
NOTE_REG = "> **Sala migrada para o CT em "
NOTE_TAG = "(migrate-sala-to-ct)"
dst_root = os.path.join(CT, "docs", "smart-memory", "sala-de-controle")


def out(k, v=""):
    print(f"{k}={v}")


def read(p):
    with open(p, encoding="utf-8", errors="replace") as f:
        return f.read()


def strip_notes(text):
    """Conteúdo sem as linhas que esta migração acrescenta (para reconhecer o 'mesmo arquivo')."""
    keep = [ln for ln in text.splitlines() if not ln.startswith(NOTE_REG) and NOTE_TAG not in ln]
    return "\n".join(keep).rstrip()


def same(a, b):
    try:
        return strip_notes(read(a)) == strip_notes(read(b))
    except OSError:
        return False


# ── plano de cópia ──
plan = []  # (origem, destino-relativo-a-dst_root)
sources = [("sala-de-controle", ""), ("maestri", "historico-maestri")]
for sub, prefix in sources:
    base = os.path.join(OLD, "docs", "smart-memory", sub)
    if not os.path.isdir(base):
        continue
    for d, dirs, files in os.walk(base):
        dirs.sort()
        for fn in sorted(files):
            if not fn.endswith(".md"):
                continue
            rel = os.path.relpath(os.path.join(d, fn), base)
            if rel in REGEN:
                continue
            plan.append((os.path.join(d, fn), os.path.join(prefix, rel) if prefix else rel))
out("SKIP_REGEN", "PANORAMA.md|snapshot.json")

n_copy = n_same = n_ren = 0
copied = []
for src, rel in plan:
    dst = os.path.join(dst_root, rel)
    if os.path.exists(dst):
        if same(src, dst):
            out("SAME", os.path.relpath(dst, CT))
            n_same += 1
            continue
        stem, ext = os.path.splitext(rel)
        k, cand = 1, f"{stem}{SUFFIX}{ext}"
        while os.path.exists(os.path.join(dst_root, cand)) and not same(src, os.path.join(dst_root, cand)):
            k += 1
            cand = f"{stem}{SUFFIX}-{k}{ext}"
        if os.path.exists(os.path.join(dst_root, cand)):
            out("SAME", os.path.relpath(os.path.join(dst_root, cand), CT))
            n_same += 1
            continue
        out("RENAME", f"{os.path.basename(cand)}|o CT já tem um {os.path.basename(rel)} diferente")
        n_ren += 1
        dst = os.path.join(dst_root, cand)
    out("COPY", f"{src}|{dst}")
    n_copy += 1
    if APPLY:
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        if os.path.exists(dst):  # nunca sobrescreve
            print(f"ERROR=would_overwrite|{dst}")
            sys.exit(1)
        shutil.copy2(src, dst)
    copied.append(dst)

# ── notas de migração ──
reg = os.path.join(dst_root, "registry.md")
disp = os.path.join(dst_root, "dispatches.md")
reg_line = f"{NOTE_REG}{TODAY}:** antes em `{OLD}`."
disp_line = f"- {TODAY} — Sala migrada para o CT; antes em `{OLD}`. Histórico anterior acima. {NOTE_TAG}"


def note(path, line, header, marker):
    exists = os.path.exists(path)
    already = exists and any(marker in ln and OLD in ln for ln in read(path).splitlines())
    if already:
        out("NOTE_SAME", os.path.relpath(path, CT))
        return
    out("NOTE", f"{os.path.relpath(path, CT)}|{line}")
    if APPLY:
        os.makedirs(os.path.dirname(path), exist_ok=True)
        body = read(path) if exists else header
        sep = "" if body.endswith("\n") or not body else "\n"
        with open(path, "a" if exists else "w", encoding="utf-8") as f:
            f.write((sep if exists else body) + "\n" + line + "\n")


note(reg, reg_line, "# Registro da Sala de Controle\n", NOTE_REG)
note(disp, disp_line, "# Despachos da Sala de Controle\n", NOTE_TAG)

# ── INDEX.md mínimo do CT ──
idx = os.path.join(CT, "docs", "smart-memory", "INDEX.md")
if os.path.exists(idx):
    out("INDEX", "exists|docs/smart-memory/INDEX.md (não mexi)")
else:
    out("INDEX", "create|docs/smart-memory/INDEX.md")
    if APPLY:
        with open(idx, "w", encoding="utf-8") as f:
            f.write("# INDEX — smart-memory do CT\n\n"
                    "Local, ignorada pelo git. Hoje guarda só a Sala de Controle.\n\n"
                    "## Sala de Controle — `sala-de-controle/`\n"
                    "- [[sala-de-controle/registry]] — sessões e projetos conhecidos\n"
                    "- [[sala-de-controle/dispatches]] — histórico de despachos\n"
                    "- [[sala-de-controle/organizacao]] — mapa de pastas (negócios → projetos → squads)\n"
                    "- `sala-de-controle/PANORAMA.md` e `snapshot.json` — gerados a cada leitura (não editar)\n"
                    "- `sala-de-controle/historico-maestri/` — memória antiga do maestri-os (só consulta)\n")

# ── sessões abertas na pasta antiga ──
names = []
sdir = os.path.join(HOME, ".claude", "sessions")
OLD_REAL = os.path.realpath(OLD)
if os.path.isdir(sdir):
    for fn in sorted(os.listdir(sdir)):
        if not fn.endswith(".json"):
            continue
        try:
            j = json.load(open(os.path.join(sdir, fn), encoding="utf-8"))
        except (OSError, ValueError):
            continue
        cwd = j.get("cwd") or ""
        if not cwd:
            continue
        cwd = os.path.realpath(cwd)
        if not (cwd == OLD_REAL or cwd.startswith(OLD_REAL + "/")):
            continue
        pid = j.get("pid")
        try:
            os.kill(int(pid), 0)
        except PermissionError:
            pass
        except (OSError, TypeError, ValueError):
            continue  # pid morto: sessão fantasma
        names.append(j.get("name") or (j.get("sessionId") or fn)[:8])
out("SESSIONS_OPEN", ",".join(names))

# ── pasta antiga é só Sala? (proteção: nunca manda um projeto de verdade para a Lixeira) ──
agents_dir = os.path.join(OLD, ".claude", "agents")
has_agents = os.path.isdir(agents_dir) and any(f.endswith(".md") for f in os.listdir(agents_dir))
has_git = os.path.exists(os.path.join(OLD, ".git"))

hold = ""
if names:
    hold = "sessions_open"
elif has_agents or has_git:
    hold = "not_sala_only"
if hold:
    out("HOLD_TRASH", hold)
else:
    out("TRASH", OLD)

print("---")
verb = "copiados" if APPLY else "a copiar"
print("RESUMO:")
print(f"  • Arquivos da Sala {verb} para docs/smart-memory/sala-de-controle/: {n_copy} · já iguais no CT: {n_same} · renomeados por colisão (-da-pasta-antiga): {n_ren}")
print("  • PANORAMA.md e snapshot.json não vêm: a Sala regenera os dois na próxima leitura")
if names:
    print(f"  • Sessões abertas na pasta antiga: {', '.join(names)} — feche-as antes de mandar a pasta para a Lixeira")
if hold == "sessions_open":
    print("  • A pasta antiga NÃO vai para a Lixeira agora: feche as sessões e rode de novo com --apply")
elif hold == "not_sala_only":
    print("  • A pasta antiga NÃO vai para a Lixeira: ela tem agentes ou .git (parece um projeto, não só a Sala) — revise à mão")
else:
    print(f"  • Pasta antiga {'vai agora' if APPLY else 'iria'} para a Lixeira (recuperável): {OLD}")
if not APPLY:
    out("NEXT", "nada foi gravado (dry-run). Para aplicar: migrate-sala-to-ct.sh \"<pasta-antiga>\" --apply")
PYEOF
)"
PRC=$?
printf '%s\n' "$PYOUT"
[ $PRC -eq 0 ] || { echo "ERROR=migrate_failed|rc=$PRC"; exit 1; }

if [ $APPLY -eq 1 ]; then
  if printf '%s\n' "$PYOUT" | grep -q '^HOLD_TRASH=sessions_open'; then
    echo "NEXT=feche as sessões abertas na pasta antiga e rode de novo com --apply (a memória já copiada fica como SAME)"
  elif printf '%s\n' "$PYOUT" | grep -q '^HOLD_TRASH='; then
    echo "NEXT=a pasta antiga ficou onde estava — revise à mão antes de mandá-la para a Lixeira"
  else
    bash "$TRASH_SH" "$OLD" || { echo "ERROR=trash_failed|$OLD"; exit 1; }
    echo "NEXT=abra /sala-de-controle numa sessão no CT — ela regenera o PANORAMA a partir da memória migrada"
  fi
fi
echo "STATUS=done"
exit 0
