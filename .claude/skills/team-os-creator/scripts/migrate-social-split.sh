#!/usr/bin/env bash
# migrate-social-split.sh — leva um projeto destino da squad `social` antiga (strategist + content +
# publisher + estúdio) para o desenho novo: `social` = só o estúdio (design, photo, video) + uma
# squad por plataforma (instagram, tiktok, youtube, linkedin).
#
# Por que existe: o *propagate (--match-target-squads) deriva as squads dos agentes que JÁ estão
# no destino — então nunca instala `instagram` num projeto antigo, e os agentes que saíram do CT
# (social-strategist/content/publisher/analyst) ficam órfãos lá (risco de dois gates editoriais).
#
# Uso: migrate-social-split.sh <pasta-destino> [--platforms instagram,youtube,...] [--apply]
#        [--source <CT>]          (padrão: o CT onde este script está)
#
# Padrão = DRY-RUN: imprime o plano (KEY=valor) + resumo em pt-BR e não grava nada.
# --apply (exige --platforms — quem roda pergunta ao usuário quais plataformas):
#   (b) install-to-project.sh --squads social,<plataformas> (faz o backup .claude.bak-* de sempre)
#   (c) agentes/skill antigos (social-strategist/content/publisher/analyst, skill
#       social-meta-publishing): sem edição do usuário (hash = .team-os/installed.json, ou = uma
#       versão do histórico git do CT) → movidos para .team-os/removed/<data>/ (nunca apagados);
#       editados (ou de origem desconhecida) → ficam, com KEPT_EDITED=<arquivo>. installed.json
#       deixa de listar todos eles.
#   (d) smart-memory: agents/social/{strategy,strategist,content,publisher} →
#       agents/instagram/{strategy,content,publisher} (strategist funde em strategy; nome repetido
#       ganha o sufixo -de-strategist). Formato antigo sem squad (agents/content, agents/design…):
#       content/publisher/strategy → instagram, design/photo/video → social; o resto só reporta.
#       Área de destino que JÁ tem conteúdo não recebe nada (SM_CONFLICT). Cada pasta antiga fica
#       com um DIGEST.md curto apontando para a nova. Wikilinks antigos são só listados.
#   (e) stories que citam os agentes antigos são só listadas.
# Nunca: git no destino, apagar arquivo, mexer fora de .claude/, .team-os/ e docs/smart-memory/
# (o install-to-project.sh mantém o .gitignore do destino e o hook global de título, como sempre).
# Saída: KEY=valor · exit 0 ok · 1 falha · 2 uso incorreto. Bash 3.2-safe; precisa de python3.

set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
TARGET=""
PLATFORMS=""
APPLY=0
PLATFORM_SQUADS="instagram tiktok youtube linkedin"

usage() { echo "Uso: migrate-social-split.sh <pasta-destino> [--platforms instagram,youtube,...] [--apply] [--source <CT>]" >&2; }
need_value() { if [ $# -lt 2 ] || [ -z "$2" ]; then echo "ERROR=missing_value|$1 exige um valor" >&2; exit 2; fi; }

while [ $# -gt 0 ]; do
  case "$1" in
    --platforms) need_value "$1" "${2:-}"; PLATFORMS="$2"; shift 2 ;;
    --source)    need_value "$1" "${2:-}"; SOURCE="$2"; shift 2 ;;
    --apply)     APPLY=1; shift ;;
    --dry-run)   APPLY=0; shift ;;
    -h|--help)   usage; exit 0 ;;
    -*)          echo "ERROR=unknown_flag|$1" >&2; usage; exit 2 ;;
    *)           if [ -z "$TARGET" ]; then TARGET="$1"; shift; else echo "ERROR=extra_arg|$1" >&2; usage; exit 2; fi ;;
  esac
done

[ -n "$TARGET" ] || { echo "ERROR=missing_target" >&2; usage; exit 2; }
[ -d "$TARGET" ] || { echo "ERROR=target_not_found|$TARGET"; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"
SOURCE="$(cd "$SOURCE" 2>/dev/null && pwd)" || { echo "ERROR=source_not_found"; exit 1; }
[ "$SOURCE" != "$TARGET" ] || { echo "ERROR=same_path|o destino não pode ser o próprio CT"; exit 1; }
[ -d "$SOURCE/.claude/agents" ] || { echo "ERROR=no_source_agents|$SOURCE"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "ERROR=python3_missing"; exit 1; }
if [ -f "$TARGET/pack-manifest.json" ] && grep -q '"name": *"team-os"' "$TARGET/pack-manifest.json" 2>/dev/null; then
  echo "ERROR=target_is_pack|o destino é uma cópia do pack — lá se usa o *update"; exit 1
fi

# Plataformas: só squads de plataforma do pack
PLATFORMS="$(printf '%s' "$PLATFORMS" | tr -d ' ')"
for p in $(printf '%s' "$PLATFORMS" | tr ',' ' '); do
  case " $PLATFORM_SQUADS " in *" $p "*) ;; *)
    echo "ERROR=invalid_platform|$p (use: $(echo $PLATFORM_SQUADS | tr ' ' ','))" >&2; exit 2 ;;
  esac
  [ -f "$SOURCE/.claude/skills/team-os-creator/presets/$p.yaml" ] || { echo "ERROR=platform_not_in_pack|$p não tem preset no CT"; exit 1; }
done
if [ $APPLY -eq 1 ] && [ -z "$PLATFORMS" ]; then
  echo "ERROR=platforms_required|--apply exige --platforms (pergunte ao usuário quais plataformas o projeto usa: instagram, tiktok, youtube, linkedin)" >&2
  exit 2
fi

TS="$(date +%Y%m%d-%H%M%S)"
MODE="dry-run"; [ $APPLY -eq 1 ] && MODE="apply"
echo "STATUS=starting"
echo "MODE=$MODE"
echo "TARGET=$TARGET"

# Sugestão de plataforma (dry-run sem --platforms): a squad antiga era Instagram/Meta
SUGGESTED=""
for a in social-strategist social-content social-publisher; do
  [ -f "$TARGET/.claude/agents/$a.md" ] && { SUGGESTED="instagram"; break; }
done
if [ -n "$PLATFORMS" ]; then
  echo "PLATFORMS=$PLATFORMS"
else
  echo "PLATFORMS_SUGGESTED=${SUGGESTED:-}"
fi
for p in $PLATFORM_SQUADS; do
  ls "$TARGET/.claude/agents/$p-"*.md >/dev/null 2>&1 && echo "ALREADY_PLATFORM=$p"
done

# ── (b) install das squads (estúdio + plataformas) ───────────────────────────
INSTALL_PLATS="${PLATFORMS:-$SUGGESTED}"
INSTALL_KEYS='^(BACKUP|BACKUP_TRASHED|AGENTS_COPIED|AGENTS_UPDATED|AGENTS_LIST|SKILLS_COPIED|SKILLS_UPDATED|SKILLS_LIST|CHANGED_FILES|CONFLICT_FILES|CONFLICT|WARN|ERROR|BASELINE_CREATED|STATUS)='
if [ -n "$INSTALL_PLATS" ]; then
  echo "INSTALL_CMD=install-to-project.sh --source <CT> --target <destino> --squads social,$INSTALL_PLATS"
  INST_OUT="$(mktemp "${TMPDIR:-/tmp}/team-os-migrate.XXXXXX")" || exit 1
  trap 'rm -f "$INST_OUT"' EXIT
  if [ $APPLY -eq 1 ]; then
    bash "$SCRIPT_DIR/install-to-project.sh" --source "$SOURCE" --target "$TARGET" --squads "social,$INSTALL_PLATS" > "$INST_OUT" 2>&1
  else
    bash "$SCRIPT_DIR/install-to-project.sh" --source "$SOURCE" --target "$TARGET" --squads "social,$INSTALL_PLATS" --dry-run > "$INST_OUT" 2>&1
  fi
  IRC=$?
  grep -E "$INSTALL_KEYS" "$INST_OUT" | sed 's/^/INSTALL_/'
  if [ $IRC -ne 0 ] || ! grep -qx 'STATUS=done' "$INST_OUT"; then
    echo "ERROR=install_failed|install-to-project.sh falhou (rc=$IRC) — nada da migração foi movido"
    tail -5 "$INST_OUT" | sed 's/^/INSTALL_LOG: /'
    exit 1
  fi
else
  echo "INSTALL_SKIPPED=sem plataforma definida — passe --platforms para ver o que seria instalado"
fi

# ── (c) (d) (e) agentes antigos, smart-memory, stories ───────────────────────
python3 - "$MODE" "$TARGET" "$SOURCE" "$TS" <<'PYEOF'
import datetime, hashlib, json, os, re, shutil, subprocess, sys

mode, target, source, ts = sys.argv[1:5]
APPLY = mode == "apply"
JUNK = {"Icon\r", ".DS_Store"}
MARK = "<!-- team-os:migrate-social-split -->"
OLD_AGENTS = ["social-strategist", "social-content", "social-publisher", "social-analyst"]
OLD_SKILLS = ["social-meta-publishing"]
summary = []


def out(k, v=""):
    print(f"{k}={v}", flush=True)


def sha_bytes(b):
    return hashlib.sha256(b).hexdigest()


def sha(path):
    if os.path.islink(path) or not os.path.isfile(path):
        return None
    with open(path, "rb") as f:
        return sha_bytes(f.read())


def real_entries(d):
    try:
        return sorted(e for e in os.listdir(d) if e not in JUNK)
    except OSError:
        return []


# ── estado do destino ──
inst_path = os.path.join(target, ".team-os", "installed.json")
try:
    with open(inst_path, encoding="utf-8") as f:
        inst = json.load(f)
except (OSError, ValueError):
    inst = None
has_base = isinstance(inst, dict) and isinstance(inst.get("files"), dict)
base = inst["files"] if has_base else {}

_hist = {}


def history(rel):
    """sha256 de todas as versões de <rel> no histórico git do CT (HEAD). Só leitura, só no CT."""
    if rel in _hist:
        return _hist[rel]
    hs = set()
    try:
        r = subprocess.run(["git", "-C", source, "log", "HEAD", "--pretty=%H", "--", rel],
                           capture_output=True, text=True, timeout=60)
        if r.returncode == 0:
            for c in r.stdout.split():
                b = subprocess.run(["git", "-C", source, "cat-file", "blob", f"{c}:{rel}"],
                                   capture_output=True, timeout=60)
                if b.returncode == 0:
                    hs.add(sha_bytes(b.stdout))
    except (OSError, subprocess.SubprocessError):
        pass
    _hist[rel] = hs
    return hs


def pack_state(rel):
    """registered | history (arquivo do pack sem edição) · edited | unknown (fica)"""
    th = sha(os.path.join(target, rel))
    bh = base.get(rel)
    if bh is not None:
        return "registered" if th == bh else "edited"
    return "history" if th in history(rel) else "unknown"


REASON = {"registered": "igual ao registrado (sem edição)",
          "history": "igual a uma versão do pack (sem edição)",
          "edited": "editado no projeto",
          "unknown": "não é do pack ou foi editado (sem registro)"}

stamp = ts
n = 2
while os.path.exists(os.path.join(target, ".team-os", "removed", stamp)):
    stamp = f"{ts}-{n:02d}"
    n += 1
removed_root = os.path.join(target, ".team-os", "removed", stamp)


def move_to_removed(rel):
    dst = os.path.join(removed_root, rel)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    shutil.move(os.path.join(target, rel), dst)


drop_keys = set()   # entradas que saem do installed.json
n_removed = n_kept = 0

# ── (c) agentes antigos ──
for a in OLD_AGENTS:
    rel = f".claude/agents/{a}.md"
    if not os.path.isfile(os.path.join(target, rel)):
        continue
    if os.path.isfile(os.path.join(source, rel)):
        out("SKIP_STILL_IN_CT", f"{rel}|ainda existe no CT — não é removido")
        continue
    st = pack_state(rel)
    drop_keys.add(rel)
    if st in ("registered", "history"):
        if APPLY:
            move_to_removed(rel)
        out("REMOVED" if APPLY else "REMOVE", f"{rel}|{REASON[st]} → .team-os/removed/{stamp}/")
        n_removed += 1
    else:
        out("KEPT_EDITED", f"{rel}|{REASON[st]} — fica no projeto; revise e mova à mão se não usar mais")
        n_kept += 1

# ── (c) skill antiga ──
for s in OLD_SKILLS:
    srel = f".claude/skills/{s}"
    sdir = os.path.join(target, srel)
    if not os.path.isdir(sdir):
        continue
    if os.path.isdir(os.path.join(source, srel)):
        out("SKIP_STILL_IN_CT", f"{srel}/|ainda existe no CT — não é removida")
        continue
    files = []
    for d, dirs, fs in os.walk(sdir):
        dirs.sort()
        for fn in sorted(fs):
            if fn in JUNK:
                continue
            files.append(os.path.relpath(os.path.join(d, fn), target).replace(os.sep, "/"))
    states = {r: pack_state(r) for r in files}
    for k in list(base):
        if k.startswith(srel + "/"):
            drop_keys.add(k)
    movable = [r for r in files if states[r] in ("registered", "history")]
    kept = [r for r in files if r not in movable]
    if not kept:
        if APPLY:
            move_to_removed(srel)
        out("REMOVED" if APPLY else "REMOVE", f"{srel}/|{len(files)} arquivo(s) sem edição → .team-os/removed/{stamp}/")
        n_removed += 1
    else:
        for r in movable:
            if APPLY:
                move_to_removed(r)
            out("REMOVED" if APPLY else "REMOVE", f"{r}|{REASON[states[r]]} → .team-os/removed/{stamp}/")
            n_removed += 1
        for r in kept:
            out("KEPT_EDITED", f"{r}|{REASON[states[r]]} — fica no projeto")
            n_kept += 1

if APPLY and has_base and drop_keys:
    files_new = {k: v for k, v in base.items() if k not in drop_keys}
    if len(files_new) != len(base):
        inst["files"] = dict(sorted(files_new.items()))
        inst["pending"] = [p for p in inst.get("pending", []) if p not in drop_keys]
        tmp = f"{inst_path}.tmp.{os.getpid()}"
        with open(tmp, "w", encoding="utf-8") as f:
            json.dump(inst, f, ensure_ascii=False, indent=1)
            f.write("\n")
        os.replace(tmp, inst_path)
        out("INSTALLED_JSON_UPDATED", f"{len(base) - len(files_new)} registro(s) antigo(s) retirado(s)")
if not (n_removed or n_kept):
    out("OLD_AGENTS", "nenhum")

# ── (d) smart-memory ──
sm = os.path.join(target, "docs", "smart-memory")
agents_dir = os.path.join(sm, "agents")
moves = []          # (src_rel, dst_rel) relativos a agents/
unmapped = []
OLD_FORMAT_MAP = [("strategy", "instagram/strategy"), ("strategist", "instagram/strategy"),
                  ("content", "instagram/content"), ("publisher", "instagram/publisher"),
                  ("design", "social/design"), ("photo", "social/photo"), ("video", "social/video")]
NEW_FORMAT_MAP = [("social/strategy", "instagram/strategy"), ("social/strategist", "instagram/strategy"),
                  ("social/content", "instagram/content"), ("social/publisher", "instagram/publisher")]
STUDIO = {"design", "photo", "video"}


def pack_squads():
    names = set()
    pdir = os.path.join(source, ".claude", "skills", "team-os-creator", "presets")
    for fn in os.listdir(pdir) if os.path.isdir(pdir) else []:
        if fn.endswith(".yaml"):
            with open(os.path.join(pdir, fn), encoding="utf-8", errors="replace") as f:
                for line in f:
                    m = re.match(r"^name:\s*['\"]?([a-z][a-z0-9]*)['\"]?\s*$", line)
                    if m:
                        names.add(m.group(1))
                        break
    return names


def is_pointer(d):
    ents = real_entries(d)
    if ents != ["DIGEST.md"]:
        return False
    try:
        with open(os.path.join(d, "DIGEST.md"), encoding="utf-8", errors="replace") as f:
            return MARK in f.read()
    except OSError:
        return False


def has_content(d):
    return os.path.isdir(d) and bool(real_entries(d)) and not is_pointer(d)


old_format = False
if os.path.isdir(agents_dir):
    sq = pack_squads() | {"pm"}
    for src, dst in NEW_FORMAT_MAP:
        moves.append((src, dst))
    for src, dst in OLD_FORMAT_MAP:
        if os.path.isdir(os.path.join(agents_dir, src)):
            old_format = True
            moves.append((src, dst))
    known_social = {"design", "photo", "video", "strategy", "strategist", "content", "publisher"}
    for e in real_entries(os.path.join(agents_dir, "social")):
        if os.path.isdir(os.path.join(agents_dir, "social", e)) and e not in known_social:
            unmapped.append(f"social/{e}")
    if old_format:
        mapped = {s for s, _ in OLD_FORMAT_MAP}
        for e in real_entries(agents_dir):
            if os.path.isdir(os.path.join(agents_dir, e)) and e not in sq and e not in mapped and not e.startswith("_"):
                unmapped.append(e)
    out("SM_FORMAT", "antigo (sem squad)" if old_format else "squad/área")
else:
    out("SM_NONE", "projeto sem docs/smart-memory/agents — nada a mover")

pre_content = {}
for _, dst in moves:
    pre_content.setdefault(dst, has_content(os.path.join(agents_dir, dst)))
planned = {}        # dst → nomes que existirão lá (simulação, vale no dry-run e no apply)
moved_srcs = []
n_sm_moves = n_sm_conf = n_sm_ren = 0


def pointer_text(dst):
    squad = dst.split("/")[0]
    today = datetime.date.today().isoformat()
    return (f"# DIGEST — área movida\n\n"
            f"Esta área agora é da squad **{squad}**: → [[agents/{dst}/DIGEST]]\n\n"
            f"Movida por `migrate-social-split.sh` em {today}. Notas novas vão para "
            f"`docs/smart-memory/agents/{dst}/`.\n{MARK}\n")


for src, dst in moves:
    sabs, dabs = os.path.join(agents_dir, src), os.path.join(agents_dir, dst)
    if not os.path.isdir(sabs):
        continue
    if is_pointer(sabs):
        out("SM_ALREADY", f"agents/{src}|já migrada (ponteiro para agents/{dst})")
        moved_srcs.append(src)
        continue
    ents = real_entries(sabs)
    if not ents:
        continue
    if pre_content[dst]:
        out("SM_CONFLICT", f"agents/{src} → agents/{dst}|o destino já tem conteúdo — não mesclei; junte à mão")
        n_sm_conf += 1
        continue
    have = planned.setdefault(dst, set(real_entries(dabs)))
    tag = os.path.basename(src)
    for e in ents:
        new = e
        if new in have:
            stem, ext = os.path.splitext(e) if os.path.isfile(os.path.join(sabs, e)) else (e, "")
            new = f"{stem}-de-{tag}{ext}"
            k = 2
            while new in have:
                new = f"{stem}-de-{tag}-{k}{ext}"
                k += 1
            out("SM_RENAME", f"agents/{src}/{e} → agents/{dst}/{new}|já existe um {e} lá")
            n_sm_ren += 1
        if APPLY:
            os.makedirs(dabs, exist_ok=True)
            shutil.move(os.path.join(sabs, e), os.path.join(dabs, new))
        have.add(new)
    out("SM_MOVED" if APPLY else "SM_MOVE", f"agents/{src} → agents/{dst}|{len(ents)} item(ns)")
    n_sm_moves += 1
    moved_srcs.append(src)
    if APPLY:
        with open(os.path.join(sabs, "DIGEST.md"), "w", encoding="utf-8") as f:
            f.write(pointer_text(dst))
    out("SM_POINTER", f"agents/{src}/DIGEST.md → [[agents/{dst}/DIGEST]]")

for u in unmapped:
    out("SM_UNMAPPED", f"agents/{u}|não é da migração da social — fica como está (revise)")

# wikilinks antigos (só reporta)
n_links = 0
if moved_srcs and os.path.isdir(sm):
    alts = "|".join(re.escape(s) for s in sorted(set(moved_srcs), key=len, reverse=True))
    rx = re.compile(r"\[\[agents/(?:" + alts + r")(?=[/|\]#])[^\]]*\]\]")
    shown = 0
    for d, dirs, fs in os.walk(sm):
        dirs.sort()
        for fn in sorted(fs):
            if not fn.endswith(".md"):
                continue
            p = os.path.join(d, fn)
            try:
                with open(p, encoding="utf-8", errors="replace") as f:
                    lines = f.read().splitlines()
            except OSError:
                continue
            if any(MARK in ln for ln in lines):
                continue
            for i, ln in enumerate(lines, 1):
                for m in rx.finditer(ln):
                    n_links += 1
                    if shown < 40:
                        out("WIKILINK_OLD", f"{os.path.relpath(p, target)}:{i}|{m.group(0)}")
                        shown += 1
    if n_links > 40:
        out("WIKILINK_OLD_MORE", n_links - 40)
out("WIKILINKS_OLD_TOTAL", n_links)

# ── (e) stories que citam os agentes antigos (só reporta) ──
n_story = 0
sdir = os.path.join(sm, "stories")
rx_s = re.compile(r"\bsocial-(?:strategist|content|publisher|analyst)\b")
if os.path.isdir(sdir):
    for d, dirs, fs in os.walk(sdir):
        dirs.sort()
        for fn in sorted(fs):
            if not fn.endswith(".md"):
                continue
            p = os.path.join(d, fn)
            try:
                with open(p, encoding="utf-8", errors="replace") as f:
                    c = len(rx_s.findall(f.read()))
            except OSError:
                continue
            if c:
                n_story += 1
                out("STORY_REF", f"{os.path.relpath(p, target)}|{c} citação(ões) de social-strategist/content/publisher/analyst")
out("STORIES_WITH_OLD_AGENTS", n_story)

# ── resumo em pt-BR ──
print("---")
verb = "movidos" if APPLY else "a mover"
print("RESUMO:")
print(f"  • Agentes/skill antigos {verb} para .team-os/removed/{stamp}/: {n_removed} · mantidos no projeto (editados ou criados por você): {n_kept}")
print(f"  • Pastas da smart-memory {verb}: {n_sm_moves} · com nome repetido renomeado: {n_sm_ren} · não mescladas (destino já tinha conteúdo): {n_sm_conf}")
print(f"  • Links antigos [[agents/...]] para revisar: {n_links} · stories que citam os agentes antigos: {n_story}")
if APPLY:
    out("NEXT", "abra uma sessão do Claude Code nesse projeto e rode /team-os — a Discovery cria as áreas novas da smart-memory")
    out("NEXT", "nada foi commitado: o commit do projeto é seu, na sessão dele")
else:
    out("NEXT", "nada foi gravado (dry-run). Para aplicar: migrate-social-split.sh \"<destino>\" --platforms <lista> --apply")
out("STATUS", "done")
PYEOF
PRC=$?
[ $PRC -eq 0 ] || { echo "ERROR=migrate_failed|rc=$PRC"; exit 1; }
exit 0
