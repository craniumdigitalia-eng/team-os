#!/usr/bin/env bash
# test-migrate-social.sh — teste hermético do migrate-social-split.sh (squad social antiga →
# estúdio social + squads de plataforma).
#
# Tudo numa pasta temporária, com HOME e TMPDIR falsos (Lixeira e ~/.claude reais nunca são
# tocados). A fonte é uma cópia leve deste CT com um git próprio só para simular "versão antiga
# do pack" (social-analyst no histórico). Os destinos são sintéticos.
#
# Cenários: dry-run não grava nada e sugere instagram · --apply sem --platforms / plataforma
# inválida → exit 2 · --apply: instala estúdio + instagram com backup .claude.bak-*, move os
# agentes/skill antigos sem edição para .team-os/removed/, mantém o editado e o arquivo do usuário,
# limpa o installed.json, move a smart-memory (strategist funde em strategy com sufixo
# -de-strategist), deixa ponteiro, reporta wikilinks, stories e áreas fora do mapa, não mexe fora
# de .claude/.team-os/docs/smart-memory · 2ª execução idempotente · propagate depois só acusa o
# órfão editado · formato antigo sem squad (várias plataformas) · área de destino com conteúdo
# (não mescla).
#
# Uso: bash test-migrate-social.sh   (exit 0 = tudo passou). Bash 3.2-safe; precisa de python3, rsync, git.

set -u

SRC_SCRIPTS="$(cd "$(dirname "$0")" && pwd)"
CT="$(cd "$SRC_SCRIPTS/../../../.." && pwd)"
ORIG_TMP="${TMPDIR:-/tmp}"
T="$(mktemp -d "$ORIG_TMP/team-os-test-migrate.XXXXXX")" || exit 1
[ "${TEAM_OS_TEST_KEEP:-0}" = "1" ] && echo "(mantendo $T)" || trap 'rm -rf "$T"' EXIT

export HOME="$T/home"
export TMPDIR="$T/tmp"
export XDG_DATA_HOME="$T/home/.local/share"
export COPYFILE_DISABLE=1
export GIT_CONFIG_NOSYSTEM=1
mkdir -p "$HOME" "$TMPDIR"
unset BACKUP_KEEP
if [ "$(uname -s)" != "Darwin" ]; then export TEAM_OS_TRASH_DIR="$T/trash"; fi

PASS=0; FAIL=0
ok()   { PASS=$((PASS + 1)); }
bad()  { FAIL=$((FAIL + 1)); echo "  ❌ $*"; }
check() { local d="$1"; shift; if "$@"; then ok; else bad "$d"; fi; }
kv()  { grep -m1 "^$1=" "$2" | cut -d= -f2-; }
h()   { python3 -c 'import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())' "$1"; }
treehash() {  # treehash <pasta> [prefixos a ignorar, separados por vírgula]
  python3 - "$1" "${2:-}" <<'PYEOF'
import hashlib, os, sys
root = sys.argv[1]
skip = [s for s in sys.argv[2].split(",") if s]
out = hashlib.sha256()
for d, dirs, files in sorted(os.walk(root)):
    dirs.sort()
    for n in sorted(files):
        p = os.path.join(d, n); rel = os.path.relpath(p, root)
        if any(rel == s or rel.startswith(s + "/") or rel.startswith(s + "-") for s in skip):
            continue
        out.update(rel.encode() + b"\0" + open(p, "rb").read())
print(out.hexdigest())
PYEOF
}
recorded() { python3 -c 'import json,sys; print((json.load(open(sys.argv[1])).get("files") or {}).get(sys.argv[2],""))' "$1/.team-os/installed.json" "$2" 2>/dev/null; }
register() {  # register <destino> <rel>... → grava o hash atual no installed.json (simula install antigo)
  local d="$1"; shift
  python3 - "$d" "$@" <<'PYEOF'
import hashlib, json, os, sys
d, rels = sys.argv[1], sys.argv[2:]
p = os.path.join(d, ".team-os", "installed.json")
j = json.load(open(p))
for r in rels:
    j["files"][r] = hashlib.sha256(open(os.path.join(d, r), "rb").read()).hexdigest()
json.dump(j, open(p, "w"), ensure_ascii=False, indent=1)
PYEOF
}
mig() {  # mig <saída> <args...> → rc em $RC
  local o="$1"; shift
  bash "$SRC/.claude/skills/team-os-creator/scripts/migrate-social-split.sh" "$@" --source "$SRC" > "$o" 2>&1; RC=$?
}

A=".claude/agents"
SMA="docs/smart-memory/agents"

# Cópia leve do CT + git só com o histórico de social-analyst e social-content (versões antigas do pack)
SRC="$T/ct-copia"
mkdir -p "$SRC"
rsync -a --exclude=.git --exclude=.venv --exclude=ms-playwright --exclude=__pycache__ \
  --exclude=docs --exclude=.team-os "$CT/" "$SRC/"
ANALYST_V1='---
name: social-analyst
description: analista antigo do pack
memory: project
---
# ANALISTA — versão antiga do pack
'
(
  cd "$SRC" || exit 1
  G="git -c user.name=teste -c user.email=teste@exemplo.invalid -c commit.gpgsign=false"
  git init -q . && printf '%s' "$ANALYST_V1" > "$A/social-analyst.md" \
    && printf -- '---\nname: social-content\n---\n# content do pack antigo\n' > "$A/social-content.md" \
    && $G add "$A/social-analyst.md" "$A/social-content.md" && $G commit -qm "pack antigo" \
    && $G rm -q "$A/social-analyst.md" "$A/social-content.md" && $G commit -qm "saem do pack"
) || { echo "❌ não consegui preparar o git da cópia do CT"; exit 1; }
[ ! -e "$SRC/$A/social-analyst.md" ] || { echo "❌ cópia do CT ainda tem social-analyst"; exit 1; }
for a in social-strategist social-content social-publisher; do
  [ ! -e "$SRC/$A/$a.md" ] || { echo "❌ o CT ainda tem $a.md — teste pressupõe a divisão da social"; exit 1; }
done

# ═══ 1. destino no formato squad/área ═══════════════════════════════════════
echo "── 1. projeto com a social antiga"
D1="$T/Cliente | Marketing"; mkdir -p "$D1"
bash "$SRC/.claude/skills/team-os-creator/scripts/install-to-project.sh" --source "$SRC" --target "$D1" --squads social > "$T/0.out" 2>&1
check "base: install inicial do estúdio" [ -f "$D1/$A/social-design.md" ]
# agentes e skill antigos (registrados como se um install antigo os tivesse gravado)
for a in social-strategist social-content social-publisher; do
  printf -- '---\nname: %s\nmemory: project\n---\n# %s — versão do pack\n' "$a" "$a" > "$D1/$A/$a.md"
done
mkdir -p "$D1/.claude/skills/social-meta-publishing/reference"
printf -- '---\nname: social-meta-publishing\n---\n# skill antiga\n' > "$D1/.claude/skills/social-meta-publishing/SKILL.md"
printf 'ref antiga\n' > "$D1/.claude/skills/social-meta-publishing/reference/x.md"
register "$D1" "$A/social-strategist.md" "$A/social-content.md" "$A/social-publisher.md" \
  .claude/skills/social-meta-publishing/SKILL.md .claude/skills/social-meta-publishing/reference/x.md
printf '\nMINHA EDIÇÃO no content\n' >> "$D1/$A/social-content.md"                       # editado → fica
printf 'minhas notas\n' > "$D1/.claude/skills/social-meta-publishing/minhas-notas.md"      # do usuário → fica
printf '%s' "$ANALYST_V1" > "$D1/$A/social-analyst.md"                                     # órfão antigo, sem registro
# smart-memory
mkdir -p "$D1/$SMA/social/strategy" "$D1/$SMA/social/strategist" "$D1/$SMA/social/content" \
  "$D1/$SMA/social/publisher" "$D1/$SMA/social/design" "$D1/$SMA/social/analyst" \
  "$D1/docs/smart-memory/stories/active"
printf '# DIGEST strategy\n' > "$D1/$SMA/social/strategy/DIGEST.md"
printf 'pauta da strategy\n' > "$D1/$SMA/social/strategy/pauta.md"
printf '# DIGEST strategist\n' > "$D1/$SMA/social/strategist/DIGEST.md"
printf 'pauta do strategist\n' > "$D1/$SMA/social/strategist/pauta.md"
printf 'notas do strategist\n' > "$D1/$SMA/social/strategist/notas.md"
printf '' > "$D1/$SMA/social/strategist/Icon"$'\r'
printf '' > "$D1/$SMA/social/strategy/Icon"$'\r'
printf '# DIGEST content\nver [[agents/social/strategy/pauta]] e [[agents/social/publisher/DIGEST|pub]]\n' > "$D1/$SMA/social/content/DIGEST.md"
printf 'roteiro\n' > "$D1/$SMA/social/content/roteiro.md"
printf '# DIGEST publisher\n' > "$D1/$SMA/social/publisher/DIGEST.md"
printf '# DIGEST design\nbrief em [[agents/social/content/roteiro]]\n' > "$D1/$SMA/social/design/DIGEST.md"
printf 'analise\n' > "$D1/$SMA/social/analyst/x.md"
printf '# 001\nDono: social-strategist. Revisa: social-strategist e social-publisher.\n' > "$D1/docs/smart-memory/stories/active/001-pauta.md"
mkdir -p "$D1/site"; printf '<h1>meu site</h1>\n' > "$D1/site/index.html"
STORY_H="$(h "$D1/docs/smart-memory/stories/active/001-pauta.md")"
DESIGN_H="$(h "$D1/$SMA/social/design/DIGEST.md")"

echo "── 1a. dry-run"
B0="$(treehash "$D1")"
mig "$T/1a.out" "$D1"
check "dry-run: rc=0 ($RC)" [ "$RC" = "0" ]
check "dry-run: árvore idêntica" [ "$(treehash "$D1")" = "$B0" ]
check "dry-run: sugere instagram" [ "$(kv PLATFORMS_SUGGESTED "$T/1a.out")" = "instagram" ]
check "dry-run: prévia do install (instagram-strategist)" grep -q '^INSTALL_AGENTS_LIST=.*instagram-strategist' "$T/1a.out"
check "dry-run: REMOVE social-strategist" grep -q "^REMOVE=$A/social-strategist.md|" "$T/1a.out"
check "dry-run: REMOVE social-analyst (versão do histórico do pack)" grep -q "^REMOVE=$A/social-analyst.md|.*versão do pack" "$T/1a.out"
check "dry-run: KEPT_EDITED social-content" grep -q "^KEPT_EDITED=$A/social-content.md|" "$T/1a.out"
check "dry-run: SM_MOVE strategy" grep -q '^SM_MOVE=agents/social/strategy → agents/instagram/strategy|' "$T/1a.out"
check "dry-run: SM_RENAME DIGEST-de-strategist" grep -q '^SM_RENAME=agents/social/strategist/DIGEST.md → agents/instagram/strategy/DIGEST-de-strategist.md' "$T/1a.out"
check "dry-run: SM_RENAME pauta-de-strategist" grep -q '^SM_RENAME=agents/social/strategist/pauta.md → agents/instagram/strategy/pauta-de-strategist.md' "$T/1a.out"
check "dry-run: Icon do Drive não vira conflito" sh -c "! grep -q '^SM_RENAME=.*Icon' '$T/1a.out'"
check "dry-run: SM_UNMAPPED social/analyst" grep -q '^SM_UNMAPPED=agents/social/analyst|' "$T/1a.out"
check "dry-run: STORY_REF da story" grep -q '^STORY_REF=docs/smart-memory/stories/active/001-pauta.md|3 ' "$T/1a.out"
check "dry-run: 3 wikilinks antigos" [ "$(kv WIKILINKS_OLD_TOTAL "$T/1a.out")" = "3" ]
check "dry-run: resumo em pt-BR" grep -q '^RESUMO:' "$T/1a.out"

echo "── 1b. --apply sem plataforma / plataforma inválida"
mig "$T/1b.out" "$D1" --apply
check "--apply sem --platforms: exit 2" [ "$RC" = "2" ]
check "--apply sem --platforms: ERROR=platforms_required" grep -q '^ERROR=platforms_required' "$T/1b.out"
mig "$T/1c.out" "$D1" --apply --platforms instagram,orkut
check "plataforma inválida: exit 2" [ "$RC" = "2" ]
check "nada gravado nas recusas" [ "$(treehash "$D1")" = "$B0" ]

echo "── 1c. --apply --platforms instagram"
OUT0="$(treehash "$D1" ".claude,.claude.bak,.team-os,docs/smart-memory")"
mig "$T/1d.out" "$D1" --apply --platforms instagram
check "apply: rc=0 ($RC)" [ "$RC" = "0" ]
check "apply: STATUS=done" grep -qx 'STATUS=done' "$T/1d.out"
check "apply: backup .claude.bak-* do install" sh -c "ls -d '$D1'/.claude.bak-* >/dev/null 2>&1"
check "apply: instagram-strategist instalado" [ -f "$D1/$A/instagram-strategist.md" ]
check "apply: instagram-publishing instalada" [ -f "$D1/.claude/skills/instagram-publishing/SKILL.md" ]
check "apply: estúdio mantido" [ -f "$D1/$A/social-design.md" ]
RM="$(ls -d "$D1"/.team-os/removed/*/ 2>/dev/null | tail -1)"
check "apply: social-strategist saiu de agents/" [ ! -e "$D1/$A/social-strategist.md" ]
check "apply: social-strategist guardado em .team-os/removed/" [ -f "${RM}$A/social-strategist.md" ]
check "apply: social-publisher guardado" [ -f "${RM}$A/social-publisher.md" ]
check "apply: social-analyst (histórico) guardado" [ -f "${RM}$A/social-analyst.md" ]
check "apply: social-content editado ficou" grep -q 'MINHA EDIÇÃO no content' "$D1/$A/social-content.md"
check "apply: SKILL.md antiga guardada" [ -f "${RM}.claude/skills/social-meta-publishing/SKILL.md" ]
check "apply: arquivo do usuário na skill antiga ficou" [ -f "$D1/.claude/skills/social-meta-publishing/minhas-notas.md" ]
check "apply: KEPT_EDITED minhas-notas" grep -q '^KEPT_EDITED=.claude/skills/social-meta-publishing/minhas-notas.md|' "$T/1d.out"
check "apply: installed.json sem os antigos" python3 -c 'import json,sys; f=json.load(open(sys.argv[1]))["files"]; sys.exit(1 if any(("social-strategist" in k) or ("social-content" in k) or ("social-meta-publishing" in k) for k in f) else 0)' "$D1/.team-os/installed.json"
check "apply: installed.json com instagram-strategist" [ -n "$(recorded "$D1" "$A/instagram-strategist.md")" ]
check "apply: strategy/DIGEST.md veio da strategy" grep -q 'DIGEST strategy' "$D1/$SMA/instagram/strategy/DIGEST.md"
check "apply: DIGEST-de-strategist.md" grep -q 'DIGEST strategist' "$D1/$SMA/instagram/strategy/DIGEST-de-strategist.md"
check "apply: pauta.md e pauta-de-strategist.md" sh -c "grep -q 'pauta da strategy' '$D1/$SMA/instagram/strategy/pauta.md' && grep -q 'pauta do strategist' '$D1/$SMA/instagram/strategy/pauta-de-strategist.md'"
check "apply: notas.md do strategist" [ -f "$D1/$SMA/instagram/strategy/notas.md" ]
check "apply: content e publisher movidos" sh -c "[ -f '$D1/$SMA/instagram/content/roteiro.md' ] && [ -f '$D1/$SMA/instagram/publisher/DIGEST.md' ]"
check "apply: ponteiro em social/strategist" grep -q '\[\[agents/instagram/strategy/DIGEST\]\]' "$D1/$SMA/social/strategist/DIGEST.md"
check "apply: ponteiro em social/content" grep -q '\[\[agents/instagram/content/DIGEST\]\]' "$D1/$SMA/social/content/DIGEST.md"
check "apply: pasta antiga só com ponteiro (e lixo do Drive)" [ "$(ls "$D1/$SMA/social/strategy" | grep -v '^Icon' | tr '\n' ' ')" = "DIGEST.md " ]
check "apply: estúdio da smart-memory intocado" [ "$(h "$D1/$SMA/social/design/DIGEST.md")" = "$DESIGN_H" ]
check "apply: área fora do mapa intocada" [ -f "$D1/$SMA/social/analyst/x.md" ]
check "apply: story intocada" [ "$(h "$D1/docs/smart-memory/stories/active/001-pauta.md")" = "$STORY_H" ]
check "apply: nada fora de .claude/.team-os/docs/smart-memory mudou" [ "$(treehash "$D1" ".claude,.claude.bak,.team-os,docs/smart-memory")" = "$OUT0" ]
check "apply: orienta /team-os" grep -q '^NEXT=.*/team-os' "$T/1d.out"
check "apply: sem .git criado no destino" [ ! -e "$D1/.git" ]

echo "── 1d. 2ª execução idempotente"
B2="$(treehash "$D1" ".claude.bak,.team-os")"
mig "$T/1e.out" "$D1" --apply --platforms instagram
check "2ª: rc=0" [ "$RC" = "0" ]
check "2ª: nada removido de novo" sh -c "! grep -q '^REMOVED=' '$T/1e.out'"
check "2ª: SM_ALREADY nas áreas migradas" grep -q '^SM_ALREADY=agents/social/strategy|' "$T/1e.out"
check "2ª: nenhuma pasta movida" sh -c "! grep -q '^SM_MOVED=' '$T/1e.out'"
check "2ª: agentes, skills e smart-memory iguais" [ "$(treehash "$D1" ".claude.bak,.team-os")" = "$B2" ]

echo "── 1e. propagate depois da migração"
bash "$SRC/.claude/skills/team-os-creator/scripts/install-to-project.sh" --source "$SRC" --target "$D1" --match-target-squads > "$T/1f.out" 2>&1
check "propagate: squads social e instagram derivadas" grep -q '^MATCH_TARGET_SQUADS=.*instagram' "$T/1f.out"
check "propagate: só o órfão editado (social-content, no histórico do CT) aparece" [ "$(grep '^ORPHAN_AGENT=' "$T/1f.out" | cut -d'|' -f1 | tr '\n' ' ')" = "ORPHAN_AGENT=social-content " ]

# ═══ 2. formato antigo da smart-memory (sem squad) + várias plataformas ═════
echo "── 2. formato antigo + instagram,youtube"
D2="$T/Pessoa | Marketing"; mkdir -p "$D2/$A" "$D2/$SMA"
printf -- '---\nname: social-content\n---\n# content antigo, sem registro\n' > "$D2/$A/social-content.md"
for d in content publisher design video automation traffic; do mkdir -p "$D2/$SMA/$d"; printf '# DIGEST %s\n' "$d" > "$D2/$SMA/$d/DIGEST.md"; done
printf 'post\n' > "$D2/$SMA/content/post.md"
printf 'ver [[agents/content/post]]\n' > "$D2/$SMA/design/ref.md"
mig "$T/2a.out" "$D2" --apply --platforms instagram,youtube
check "antigo: rc=0 ($RC)" [ "$RC" = "0" ]
check "antigo: SM_FORMAT antigo" grep -q '^SM_FORMAT=antigo' "$T/2a.out"
check "antigo: youtube-strategist instalado" [ -f "$D2/$A/youtube-strategist.md" ]
check "antigo: content → instagram/content" [ -f "$D2/$SMA/instagram/content/post.md" ]
check "antigo: publisher → instagram/publisher" [ -f "$D2/$SMA/instagram/publisher/DIGEST.md" ]
check "antigo: design/video → social/" sh -c "[ -f '$D2/$SMA/social/design/ref.md' ] && [ -f '$D2/$SMA/social/video/DIGEST.md' ]"
check "antigo: ponteiro em agents/design" grep -q '\[\[agents/social/design/DIGEST\]\]' "$D2/$SMA/design/DIGEST.md"
check "antigo: automation só reportada" sh -c "grep -q '^SM_UNMAPPED=agents/automation|' '$T/2a.out' && [ -f '$D2/$SMA/automation/DIGEST.md' ]"
check "antigo: traffic (squad do pack) não é tocada nem reportada" sh -c "! grep -q 'agents/traffic' '$T/2a.out' && grep -q 'DIGEST traffic' '$D2/$SMA/traffic/DIGEST.md'"
check "antigo: wikilink [[agents/content/post]] reportado" grep -q '^WIKILINK_OLD=.*\[\[agents/content/post\]\]' "$T/2a.out"
check "antigo: social-content sem registro nem histórico fica" sh -c "[ -f '$D2/$A/social-content.md' ] && grep -q '^KEPT_EDITED=$A/social-content.md|' '$T/2a.out'"

# ═══ 3. área de destino que já tem conteúdo ══════════════════════════════════
echo "── 3. destino com conteúdo: não mescla"
D3="$T/proj3"; mkdir -p "$D3/$SMA/social/content" "$D3/$SMA/instagram/content"
printf 'velho\n' > "$D3/$SMA/social/content/a.md"
printf 'novo\n' > "$D3/$SMA/instagram/content/a.md"
mig "$T/3a.out" "$D3" --apply --platforms instagram
check "conflito: rc=0" [ "$RC" = "0" ]
check "conflito: SM_CONFLICT" grep -q '^SM_CONFLICT=agents/social/content → agents/instagram/content|' "$T/3a.out"
check "conflito: nada movido nem sobrescrito" sh -c "grep -qx 'velho' '$D3/$SMA/social/content/a.md' && grep -qx 'novo' '$D3/$SMA/instagram/content/a.md' && [ ! -e '$D3/$SMA/social/content/DIGEST.md' ]"

# ═══ 4. nada fora da pasta temporária ═══════════════════════════════════════
check "CT real intocado (sem social-analyst recriado)" [ ! -e "$CT/$A/social-analyst.md" ]

echo ""
if [ $FAIL -eq 0 ]; then
  echo "✅ test-migrate-social: $PASS/$PASS verificações passaram."
  exit 0
fi
echo "❌ test-migrate-social: $FAIL falha(s) de $((PASS + FAIL))."
exit 1
