#!/usr/bin/env bash
# test-propagate.sh — teste hermético do *install / *propagate (install-to-project.sh +
# propagate-sync.py): propagar sem perder o que o usuário editou no projeto destino.
#
# Tudo acontece numa pasta temporária, com HOME e TMPDIR falsos (a Lixeira e o ~/.claude reais
# nunca são tocados). A fonte é ESTE repositório (CT real, via --source); para simular "o CT
# mudou" e agentes próprios usa-se uma cópia leve dele (sem .git, .venv, ms-playwright).
#
# Cenários: destino sem installed.json (sobrescreve como antes e grava a base) · 2ª propagação
# idempotente · agente editado no destino + CT mudou (conflito, .new, nada perdido) · edição
# sem mudança no CT (mantida em silêncio) · --on-conflict new (backup do usuário) · --only ·
# --on-conflict keep decidido (não pergunta de novo) · agente/skill/arquivo criados no destino
# intocados · arquivo que saiu do pack · hook editado · agente próprio com/sem --custom ·
# --dry-run não escreve nada · Sala de Controle mora no CT (install recusa, pasta de Sala antiga e
# skill de Sala num projeto só avisam — LEGACY_CONTROL_ROOM / LEGACY_SKILL) ·
# backup .claude.bak-* só no *install, guarda 3, o resto na Lixeira · .gitignore preservado ·
# scan/diff contam conflito à parte · squad de plataforma (instagram-*) derivada no propagate e
# aviso do estúdio social sem plataforma · aviso de agente órfão (ORPHAN_AGENT) no propagate.
#
# Uso: bash test-propagate.sh   (exit 0 = tudo passou). Bash 3.2-safe; precisa de python3, rsync.

set -u

SRC_SCRIPTS="$(cd "$(dirname "$0")" && pwd)"
CT="$(cd "$SRC_SCRIPTS/../../../.." && pwd)"
INST="$SRC_SCRIPTS/install-to-project.sh"
ORIG_TMP="${TMPDIR:-/tmp}"
T="$(mktemp -d "$ORIG_TMP/team-os-test-propagate.XXXXXX")" || exit 1
[ "${TEAM_OS_TEST_KEEP:-0}" = "1" ] && echo "(mantendo $T)" || trap 'rm -rf "$T"' EXIT

export HOME="$T/home"
export TMPDIR="$T/tmp"
export XDG_DATA_HOME="$T/home/.local/share"
export COPYFILE_DISABLE=1
mkdir -p "$HOME" "$TMPDIR"
unset BACKUP_KEEP
if [ "$(uname -s)" = "Darwin" ]; then
  TRASH="$HOME/.Trash"; unset TEAM_OS_TRASH_DIR
else
  TRASH="$T/trash"; export TEAM_OS_TRASH_DIR="$TRASH"
fi

PASS=0; FAIL=0
ok()   { PASS=$((PASS + 1)); }
bad()  { FAIL=$((FAIL + 1)); echo "  ❌ $*"; }
check() { local d="$1"; shift; if "$@"; then ok; else bad "$d"; fi; }
kv()  { grep -m1 "^$1=" "$2" | cut -d= -f2-; }
has() { grep -qxF "$1" "$2"; }                     # linha exata no arquivo
h()   { python3 -c 'import hashlib,sys; print(hashlib.sha256(open(sys.argv[1],"rb").read()).hexdigest())' "$1"; }
treehash() {  # treehash <pasta> [x] — hash de nomes+conteúdo+bit x; x: ignora o carimbo do installed.json
  python3 - "$1" "${2:-}" <<'PYEOF'
import hashlib, os, sys
root, skip = sys.argv[1], sys.argv[2] == "x"
out = hashlib.sha256()
for d, dirs, files in sorted(os.walk(root)):
    dirs.sort()
    for n in sorted(files):
        p = os.path.join(d, n); rel = os.path.relpath(p, root)
        if skip and rel == os.path.join(".team-os", "installed.json"):
            continue
        out.update(rel.encode() + b"\0" + open(p, "rb").read() + (b"x" if os.access(p, os.X_OK) else b"-"))
print(out.hexdigest())
PYEOF
}
inst() {  # inst <saída> <args...>  → rc em $RC
  local o="$1"; shift
  bash "$INST" "$@" > "$o" 2>&1; RC=$?
}
recorded() {  # recorded <destino> <rel> → hash registrado no installed.json (vazio se não há)
  python3 -c 'import json,sys; print((json.load(open(sys.argv[1])).get("files") or {}).get(sys.argv[2],""))' \
    "$1/.team-os/installed.json" "$2" 2>/dev/null
}
files_json() { python3 -c 'import json,sys; print(json.dumps(json.load(open(sys.argv[1]))["files"], sort_keys=True))' "$1/.team-os/installed.json"; }
pending() { python3 -c 'import json,sys; print(" ".join(json.load(open(sys.argv[1])).get("pending", [])))' "$1/.team-os/installed.json"; }

VERSION="$(sed -n 1p "$CT/VERSION" | tr -d '[:space:]')"
A=".claude/agents"

# Cópia leve do CT (para mudar arquivos "do CT" sem tocar no CT real)
SRC2="$T/ct-copia"
mkdir -p "$SRC2"
rsync -a --exclude=.git --exclude=.venv --exclude=ms-playwright --exclude=__pycache__ \
  --exclude=docs --exclude=.team-os "$CT/" "$SRC2/"

# ═══ 1. destino sem installed.json (instalação anterior à proteção) ══════════
echo "── 1. destino antigo, sem installed.json"
P1="$T/proj | antigo"
mkdir -p "$P1/$A" "$P1/.claude/skills/team-os"
cp "$CT/$A/dev-architect.md" "$P1/$A/"
{ cat "$CT/$A/dev-qa.md"; printf '\nlinha velha de uma versão antiga do pack\n'; } > "$P1/$A/dev-qa.md"
printf 'node_modules/\nminha-linha-sem-quebra' > "$P1/.gitignore"
inst "$T/1a.out" --source "$CT" --target "$P1" --match-target-squads
check "rc=0 ($RC)" [ "$RC" = "0" ]
check "BASELINE_CREATED=1" [ "$(kv BASELINE_CREATED "$T/1a.out")" = "1" ]
check "sem base: agente diferente foi sobrescrito (como antes)" cmp -s "$CT/$A/dev-qa.md" "$P1/$A/dev-qa.md"
check "installed.json existe" [ -f "$P1/.team-os/installed.json" ]
check "installed.json: versão do pack = $VERSION" [ "$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$P1/.team-os/installed.json")" = "$VERSION" ]
check "installed.json: hash do agente" [ "$(recorded "$P1" "$A/dev-qa.md")" = "$(h "$CT/$A/dev-qa.md")" ]
check "installed.json: hash por arquivo de skill" [ "$(recorded "$P1" .claude/skills/team-os/SKILL.md)" = "$(h "$CT/.claude/skills/team-os/SKILL.md")" ]
check "installed.json: hook" [ "$(recorded "$P1" .claude/hooks/block-git-push.sh)" = "$(h "$CT/.claude/hooks/block-git-push.sh")" ]
check ".gitignore: linhas do usuário preservadas" sh -c "grep -qx 'node_modules/' '$P1/.gitignore' && grep -qx 'minha-linha-sem-quebra' '$P1/.gitignore'"
check ".gitignore: .team-os/ acrescentado" grep -qx '.team-os/' "$P1/.gitignore"
check "propagate não faz backup .claude.bak-*" sh -c "! ls -d '$P1'/.claude.bak-* >/dev/null 2>&1"
check "hook com bit de execução" [ -x "$P1/.claude/hooks/block-git-push.sh" ]

# ═══ 2. segunda propagação idempotente ═══════════════════════════════════════
echo "── 2. segunda propagação: nada muda"
F1="$(files_json "$P1")"; B1="$(treehash "$P1" x)"
inst "$T/2a.out" --source "$CT" --target "$P1" --match-target-squads
check "2ª: rc=0" [ "$RC" = "0" ]
check "2ª: CHANGED_FILES=0" [ "$(kv CHANGED_FILES "$T/2a.out")" = "0" ]
check "2ª: CONFLICT_FILES=0" [ "$(kv CONFLICT_FILES "$T/2a.out")" = "0" ]
check "2ª: AGENTS_UPDATED=0 e SKILLS_UPDATED=0" [ "$(kv AGENTS_UPDATED "$T/2a.out")|$(kv SKILLS_UPDATED "$T/2a.out")" = "0|0" ]
check "2ª: sem BASELINE_CREATED" sh -c "! grep -q '^BASELINE_CREATED=' '$T/2a.out'"
check "2ª: installed.json com os mesmos arquivos" [ "$(files_json "$P1")" = "$F1" ]
check "2ª: .gitignore sem linha repetida" [ "$(grep -cx '.team-os/' "$P1/.gitignore")" = "1" ]
check "2ª: árvore igual (fora o carimbo do installed.json)" [ "$(treehash "$P1" x)" = "$B1" ]

# ═══ 3. edição no destino + CT mudou → conflito ══════════════════════════════
echo "── 3. conflito: o usuário editou e o CT também mudou"
P2="$T/proj2"; mkdir -p "$P2"
inst "$T/3a.out" --source "$SRC2" --target "$P2" --squads dev
check "install inicial rc=0" [ "$RC" = "0" ]
QA_ORIG="$(h "$P2/$A/dev-qa.md")"
printf '\nMINHA EDIÇÃO no qa\n' >> "$P2/$A/dev-qa.md"
printf '\nMINHA EDIÇÃO no ux\n' >> "$P2/$A/dev-ux.md"          # o CT não muda o ux
printf '\nMINHA NOTA na skill\n' >> "$P2/.claude/skills/team-os/SKILL.md"
printf '\n# meu ajuste\n' >> "$P2/.claude/hooks/task-quality.sh"
# arquivos que só o usuário criou
printf -- '---\nname: dev-meu\n---\nmeu agente\n' > "$P2/$A/dev-meu.md"
printf -- '---\nname: zz-solo\n---\noutro\n' > "$P2/$A/zz-solo.md"
mkdir -p "$P2/.claude/skills/minha-skill"; printf 'minha\n' > "$P2/.claude/skills/minha-skill/SKILL.md"
printf 'meu arquivo dentro da skill do pack\n' > "$P2/.claude/skills/team-os/meu-arquivo.md"
USERH="$(h "$P2/$A/dev-meu.md")|$(h "$P2/$A/zz-solo.md")|$(h "$P2/.claude/skills/minha-skill/SKILL.md")|$(h "$P2/.claude/skills/team-os/meu-arquivo.md")"
# o "CT" muda o qa e o architect, e ganha um arquivo novo numa skill
printf '\nnova versão do CT (qa)\n' >> "$SRC2/$A/dev-qa.md"
printf '\nnova versão do CT (architect)\n' >> "$SRC2/$A/dev-architect.md"
printf 'arquivo novo do pack\n' > "$SRC2/.claude/skills/team-os/extra-do-pack.md"
inst "$T/3b.out" --source "$SRC2" --target "$P2" --match-target-squads
check "conflito: rc=0 ($RC)" [ "$RC" = "0" ]
check "CONFLICT_FILES=1" [ "$(kv CONFLICT_FILES "$T/3b.out")" = "1" ]
check "CONFLICT=$A/dev-qa.md" has "CONFLICT=$A/dev-qa.md" "$T/3b.out"
check "edição do usuário intacta" grep -q 'MINHA EDIÇÃO no qa' "$P2/$A/dev-qa.md"
check ".new ao lado = versão do CT" cmp -s "$SRC2/$A/dev-qa.md" "$P2/$A/dev-qa.md.new"
check "registro do qa continua o antigo (segue 'editado')" [ "$(recorded "$P2" "$A/dev-qa.md")" = "$QA_ORIG" ]
check "pendência registrada" [ "$(pending "$P2")" = "$A/dev-qa.md" ]
check "architect (sem edição) atualizado" cmp -s "$SRC2/$A/dev-architect.md" "$P2/$A/dev-architect.md"
check "ux editado e CT igual: mantido em silêncio" sh -c "grep -q 'MINHA EDIÇÃO no ux' '$P2/$A/dev-ux.md' && [ ! -e '$P2/$A/dev-ux.md.new' ]"
check "CUSTOMIZED lista o ux" has "CUSTOMIZED=$A/dev-ux.md" "$T/3b.out"
check "skill editada (CT igual) mantida" grep -q 'MINHA NOTA na skill' "$P2/.claude/skills/team-os/SKILL.md"
check "hook editado (CT igual) mantido" grep -q '# meu ajuste' "$P2/.claude/hooks/task-quality.sh"
check "arquivo novo do pack chegou" cmp -s "$SRC2/.claude/skills/team-os/extra-do-pack.md" "$P2/.claude/skills/team-os/extra-do-pack.md"
check "arquivos do usuário intocados" [ "$(h "$P2/$A/dev-meu.md")|$(h "$P2/$A/zz-solo.md")|$(h "$P2/.claude/skills/minha-skill/SKILL.md")|$(h "$P2/.claude/skills/team-os/meu-arquivo.md")" = "$USERH" ]
check "agente do usuário não entrou no installed.json" [ -z "$(recorded "$P2" "$A/dev-meu.md")" ]

echo "── 3b. repetir sem decidir: conflito continua, nada é reescrito"
inst "$T/3c.out" --source "$SRC2" --target "$P2" --match-target-squads
check "repetição: CONFLICT_FILES=1" [ "$(kv CONFLICT_FILES "$T/3c.out")" = "1" ]
check "repetição: CHANGED_FILES=0" [ "$(kv CHANGED_FILES "$T/3c.out")" = "0" ]
check "repetição: edição intacta" grep -q 'MINHA EDIÇÃO no qa' "$P2/$A/dev-qa.md"

# ═══ 4. --dry-run não escreve nada ═══════════════════════════════════════════
echo "── 4. --dry-run"
printf '\nnova versão do CT (alpha)\n' >> "$SRC2/$A/dev-dev-alpha.md"
B4="$(treehash "$P2")"
inst "$T/4a.out" --source "$SRC2" --target "$P2" --match-target-squads --dry-run
check "dry-run: rc=0" [ "$RC" = "0" ]
check "dry-run: árvore idêntica" [ "$(treehash "$P2")" = "$B4" ]
check "dry-run: mostra o conflito" has "CONFLICT=$A/dev-qa.md" "$T/4a.out"
check "dry-run: mostra a atualização" grep -q '^AGENTS_LIST=.*dev-dev-alpha' "$T/4a.out"
P4="$T/proj4 vazio"; mkdir -p "$P4"
inst "$T/4b.out" --source "$CT" --target "$P4" --squads dev --dry-run
check "dry-run em pasta vazia: nada criado" [ -z "$(ls -A "$P4")" ]
check "dry-run: avisa que a base seria criada" grep -q '^BASELINE=missing' "$T/4b.out"

# ═══ 5. decisões: --only + --on-conflict new / keep ══════════════════════════
echo "── 5. --only e --on-conflict"
printf '\nnova versão do CT (ux)\n' >> "$SRC2/$A/dev-ux.md"      # agora o ux também é conflito
inst "$T/5a.out" --source "$SRC2" --target "$P2" --match-target-squads --only dev-dev-beta
check "--only outro agente: alpha NÃO atualizado" sh -c "! grep -q 'nova versão do CT (alpha)' '$P2/$A/dev-dev-alpha.md'"
check "--only: conflitos fora do filtro nem aparecem" [ "$(kv CONFLICT_FILES "$T/5a.out")" = "0" ]
check "--only: pendência antiga preservada" [ "$(pending "$P2")" = "$A/dev-qa.md" ]
inst "$T/5b.out" --source "$SRC2" --target "$P2" --match-target-squads
check "agora 2 conflitos (qa, ux)" [ "$(kv CONFLICT_FILES "$T/5b.out")" = "2" ]
inst "$T/5c.out" --source "$SRC2" --target "$P2" --match-target-squads --only dev-qa --on-conflict new
check "new: qa = versão do CT" cmp -s "$SRC2/$A/dev-qa.md" "$P2/$A/dev-qa.md"
BK="$(ls -d "$P2"/.team-os/backups/*/ 2>/dev/null | tail -1)"
check "new: o do usuário guardado em .team-os/backups/" grep -q 'MINHA EDIÇÃO no qa' "${BK}$A/dev-qa.md"
check "new: .new do qa foi para a Lixeira" sh -c "[ ! -e '$P2/$A/dev-qa.md.new' ] && ls '$TRASH' | grep -q '^dev-qa.md.new'"
check "new: REPLACED=$A/dev-qa.md" has "REPLACED=$A/dev-qa.md" "$T/5c.out"
check "new: ux intocado (fora do --only)" sh -c "grep -q 'MINHA EDIÇÃO no ux' '$P2/$A/dev-ux.md' && [ -f '$P2/$A/dev-ux.md.new' ]"
inst "$T/5d.out" --source "$SRC2" --target "$P2" --match-target-squads --only dev-ux --on-conflict keep
check "keep decidido: ux do usuário mantido" grep -q 'MINHA EDIÇÃO no ux' "$P2/$A/dev-ux.md"
check "keep decidido: .new do ux foi para a Lixeira" [ ! -e "$P2/$A/dev-ux.md.new" ]
check "keep decidido: KEPT=$A/dev-ux.md" has "KEPT=$A/dev-ux.md" "$T/5d.out"
inst "$T/5e.out" --source "$SRC2" --target "$P2" --match-target-squads
check "depois das decisões: 0 conflitos" [ "$(kv CONFLICT_FILES "$T/5e.out")" = "0" ]
check "depois das decisões: alpha atualizado" grep -q 'nova versão do CT (alpha)' "$P2/$A/dev-dev-alpha.md"
check "depois das decisões: sem pendências" [ -z "$(pending "$P2")" ]
inst "$T/5f.out" --source "$SRC2" --target "$P2" --match-target-squads
check "propagação seguinte: 0 alterações, 0 conflitos" [ "$(kv CHANGED_FILES "$T/5f.out")|$(kv CONFLICT_FILES "$T/5f.out")" = "0|0" ]
check "arquivos do usuário ainda intocados" [ "$(h "$P2/$A/dev-meu.md")|$(h "$P2/$A/zz-solo.md")|$(h "$P2/.claude/skills/minha-skill/SKILL.md")|$(h "$P2/.claude/skills/team-os/meu-arquivo.md")" = "$USERH" ]

# ═══ 6. arquivo que saiu do pack ═════════════════════════════════════════════
echo "── 6. arquivo de skill que saiu do pack"
rm "$SRC2/.claude/skills/team-os/extra-do-pack.md"
inst "$T/6a.out" --source "$SRC2" --target "$P2" --match-target-squads
check "saiu do pack: REMOVED" has "REMOVED=.claude/skills/team-os/extra-do-pack.md" "$T/6a.out"
check "saiu do pack: guardado em .team-os/removed/" sh -c "ls '$P2'/.team-os/removed/*/.claude/skills/team-os/extra-do-pack.md >/dev/null 2>&1"
check "saiu do pack: arquivo do usuário na mesma skill fica" [ -f "$P2/.claude/skills/team-os/meu-arquivo.md" ]

# ═══ 7. agentes próprios (origin: custom) ════════════════════════════════════
echo "── 7. agentes próprios"
awk 'NR==1{print; next} !d && /^name:/{print "name: acme-writer"; next} !d && /^memory:/{print; print "origin: custom"; d=1; next} {print}' \
  "$CT/$A/dev-qa.md" > "$SRC2/$A/acme-writer.md"
inst "$T/7a.out" --source "$SRC2" --target "$P2" --match-target-squads
check "sem --custom: próprio NÃO instalado" [ ! -e "$P2/$A/acme-writer.md" ]
inst "$T/7b.out" --source "$SRC2" --target "$P2" --match-target-squads --custom acme-writer,nao-existe
check "--custom: instalado" cmp -s "$SRC2/$A/acme-writer.md" "$P2/$A/acme-writer.md"
check "--custom: CUSTOM_AGENTS" [ "$(kv CUSTOM_AGENTS "$T/7b.out")" = "acme-writer" ]
check "--custom: avisa nome inexistente" grep -q '^CUSTOM_NOT_FOUND=nao-existe' "$T/7b.out"
check "--custom: dev-* do pack não foi re-instalado nem perdido" grep -q 'MINHA EDIÇÃO no ux' "$P2/$A/dev-ux.md"
printf '\nmeu agente, versão 2\n' >> "$SRC2/$A/acme-writer.md"
inst "$T/7c.out" --source "$SRC2" --target "$P2" --match-target-squads
check "próprio já no destino: atualizado pelo propagate" grep -q 'meu agente, versão 2' "$P2/$A/acme-writer.md"
check "próprio já no destino: squad acme derivada" grep -q '^MATCH_TARGET_SQUADS=.*acme' "$T/7c.out"
P7="$T/proj7"; mkdir -p "$P7"
inst "$T/7d.out" --source "$SRC2" --target "$P7" --squads sites --custom all
check "--custom all num install: próprio entra" [ -f "$P7/$A/acme-writer.md" ]
check "--custom all: squads do pack fora do filtro não entram" [ ! -e "$P7/$A/dev-qa.md" ]

# ═══ 8. scan / diff contam conflito à parte ══════════════════════════════════
echo "── 8. drift"
printf '\nMINHA EDIÇÃO 2 no qa\n' >> "$P2/$A/dev-qa.md"
printf '\nnova versão 2 do CT (qa)\n' >> "$SRC2/$A/dev-qa.md"
D="$(python3 "$SRC_SCRIPTS/propagate-sync.py" drift --source "$SRC2" --target "$P2")"
check "drift: qa é conflito, ux (customizado) não é desatualizado" sh -c "printf '%s' '$D' | grep -q 'DRIFT_OUTDATED=0' && printf '%s' '$D' | grep -q 'DRIFT_CONFLICT=1'"
DA="$(bash "$SRC_SCRIPTS/diff-agents.sh" "$SRC2" "$P2" | grep '^TARGET=')"
check "diff-agents: CONFLICT_LIST=dev-qa" sh -c "printf '%s' '$DA' | tr '\t' '\n' | grep -qx 'CONFLICT_LIST=dev-qa'"
check "diff-agents: ux não aparece como desatualizado" sh -c "! printf '%s' '$DA' | tr '\t' '\n' | grep -q '^OUTDATED_LIST=.*dev-ux'"

# ═══ 9. Sala de Controle mora no CT (nunca é instalada em projeto) ══════════
echo "── 9. Sala de Controle mora no CT"
S9="$T/1 | Sala de Controle"; mkdir -p "$S9"
inst "$T/9a.out" --source "$CT" --target "$S9" --extra-skills sala-de-controle --squads dev
check "sala: --extra-skills sala-de-controle → rc≠0" [ "$RC" != "0" ]
check "sala: ERROR=sala_mora_no_ct" grep -q '^ERROR=sala_mora_no_ct|' "$T/9a.out"
check "sala: mensagem pt-BR aponta o CT e a migração" sh -c "grep -q 'mora no Centro de Treinamento' '$T/9a.out' && grep -q 'migrate-sala-to-ct.sh' '$T/9a.out'"
check "sala: nada gravado na recusa" [ -z "$(ls -A "$S9")" ]
inst "$T/9b.out" --source "$CT" --target "$S9" --squads none
check "sala: --squads none → rc≠0" [ "$RC" != "0" ]
check "sala: --squads none → ERROR=sala_mora_no_ct" grep -q '^ERROR=sala_mora_no_ct|' "$T/9b.out"
# pasta de Sala antiga sintética: skill de Sala, nenhum agente
mkdir -p "$S9/.claude/skills/sala-de-controle"
printf -- '---\nname: sala-de-controle\n---\nversão antiga da Sala\n' > "$S9/.claude/skills/sala-de-controle/SKILL.md"
B9="$(treehash "$S9")"
inst "$T/9c.out" --source "$CT" --target "$S9" --match-target-squads
check "sala antiga propagate: rc=0" [ "$RC" = "0" ]
check "sala antiga propagate: LEGACY_CONTROL_ROOM=1" grep -q '^LEGACY_CONTROL_ROOM=1' "$T/9c.out"
check "sala antiga propagate: NEXT= com migrate-sala-to-ct.sh" grep -q '^NEXT=bash .*migrate-sala-to-ct.sh' "$T/9c.out"
check "sala antiga propagate: nada gravado" [ "$(treehash "$S9")" = "$B9" ]
check "sala antiga propagate: sem installed.json" [ ! -e "$S9/.team-os" ]
# projeto comum que ainda tem a skill sala-de-controle (versão antiga): não atualiza, avisa
P9="$T/proj9 | comum"; mkdir -p "$P9/$A" "$P9/.claude/skills/sala-de-controle"
cp "$CT/$A/dev-architect.md" "$P9/$A/"
printf -- '---\nname: sala-de-controle\n---\nversão antiga da Sala\n' > "$P9/.claude/skills/sala-de-controle/SKILL.md"
SK9="$(treehash "$P9/.claude/skills/sala-de-controle")"
inst "$T/9d.out" --source "$CT" --target "$P9" --match-target-squads
check "projeto com skill de Sala: rc=0" [ "$RC" = "0" ]
check "projeto com skill de Sala: LEGACY_SKILL=sala-de-controle" grep -q '^LEGACY_SKILL=sala-de-controle|' "$T/9d.out"
check "projeto com skill de Sala: skill não atualizada" [ "$(treehash "$P9/.claude/skills/sala-de-controle")" = "$SK9" ]
check "projeto com skill de Sala: fora do installed.json" sh -c "! grep -q 'skills/sala-de-controle/' '$P9/.team-os/installed.json'"
check "projeto com skill de Sala: team-os-creator não vai" [ ! -e "$P9/.claude/skills/team-os-creator" ]

# ═══ 10. backup .claude.bak-* só no *install, guarda 3, resto na Lixeira ═════
echo "── 10. backup do *install"
P10="$T/proj10"; mkdir -p "$P10/.claude"; printf '{}\n' > "$P10/.claude/settings.json"
for i in 1 2 3 4; do
  inst "$T/10-$i.out" --source "$CT" --target "$P10" --squads dev
  [ $i -lt 4 ] && sleep 1.1
done
check "install: BACKUP= nas execuções" grep -q '^BACKUP=' "$T/10-1.out"
check "install: guarda 3 .claude.bak-*" [ "$(ls -d "$P10"/.claude.bak-* 2>/dev/null | wc -l | tr -d ' ')" = "3" ]
check "install: BACKUP_TRASHED=1 na 4ª" grep -q '^BACKUP_TRASHED=1' "$T/10-4.out"
check "install: o mais antigo foi para a Lixeira (portável)" sh -c "ls -a '$TRASH' | grep -q '^\.claude\.bak-'"
check "install repetido: 0 conflitos (nada editado)" [ "$(kv CONFLICT_FILES "$T/10-4.out")" = "0" ]

# ═══ 12. squads derivadas dos presets (squad de plataforma, estúdio social) ═══
echo "── 12. squad de plataforma (instagram) e estúdio social"
# Hermético: agente, skill e preset sintéticos na cópia do CT (não depende do que já existe no pack)
mkdir -p "$SRC2/.claude/skills/instagram-teste-skill"
printf -- '---\nname: instagram-teste-skill\ndescription: skill de teste\n---\n# teste\n' > "$SRC2/.claude/skills/instagram-teste-skill/SKILL.md"
printf -- '---\nname: instagram-teste\ndescription: agente de teste\n---\n# TESTE — Teste\n**Área na smart-memory:** `docs/smart-memory/agents/instagram/content/`\nversão nova do CT\n' > "$SRC2/$A/instagram-teste.md"
PR2="$SRC2/.claude/skills/team-os-creator/presets"
[ -f "$PR2/instagram.yaml" ] || printf 'name: instagram\ndescription: teste\nagents:\n  - name: instagram-teste\n    archetype: implementer\n' > "$PR2/instagram.yaml"
P12="$T/proj12"; mkdir -p "$P12/$A"
printf -- '---\nname: instagram-teste\n---\n# TESTE — versão antiga\n' > "$P12/$A/instagram-teste.md"
inst "$T/12a.out" --source "$SRC2" --target "$P12" --match-target-squads
check "plataforma: rc=0" [ "$RC" = "0" ]
check "plataforma: agente instagram-* reconhecido como squad instagram" grep -qx 'MATCH_TARGET_SQUADS=instagram' "$T/12a.out"
check "plataforma: agente instagram atualizado" grep -q 'versão nova do CT' "$P12/$A/instagram-teste.md"
check "plataforma: skill instagram-* entra pelo prefixo da squad" [ -f "$P12/.claude/skills/instagram-teste-skill/SKILL.md" ]
check "plataforma: estúdio social não entra sozinho" sh -c "! ls '$P12/$A'/social-*.md >/dev/null 2>&1"
check "plataforma: sem aviso de estúdio" sh -c "! grep -q '^WARN=studio_without_platform' '$T/12a.out'"
inst "$T/12b.out" --source "$SRC2" --target "$T/proj12b" --squads social --dry-run
check "estúdio sem plataforma: WARN=studio_without_platform (não bloqueia)" sh -c "[ '$RC' = '0' ] && grep -q '^WARN=studio_without_platform' '$T/12b.out'"
inst "$T/12c.out" --source "$SRC2" --target "$T/proj12c" --squads social,instagram --dry-run
check "estúdio + instagram: sem aviso" sh -c "! grep -q '^WARN=studio_without_platform' '$T/12c.out'"

# ═══ 13. agente órfão (saiu do pack) no *propagate ═══════════════════════════
echo "── 13. aviso de agente órfão"
P13="$T/proj13 | social antigo"; mkdir -p "$P13"
inst "$T/13a.out" --source "$SRC2" --target "$P13" --squads social
check "órfão: install inicial rc=0" [ "$RC" = "0" ]
# agente próprio (origin: custom) registrado + agente criado pelo usuário (sem registro)
awk 'NR==1{print; next} !d && /^name:/{print "name: social-proprio"; next} !d && /^memory:/{print; print "origin: custom"; d=1; next} {print}' \
  "$CT/$A/social-design.md" > "$P13/$A/social-proprio.md"
printf -- '---\nname: social-meu\n---\nmeu agente\n' > "$P13/$A/social-meu.md"
python3 - "$P13/.team-os/installed.json" "$A/social-proprio.md" "$(h "$P13/$A/social-proprio.md")" <<'PYEOF'
import json, sys
p, rel, hh = sys.argv[1:4]
d = json.load(open(p)); d["files"][rel] = hh
json.dump(d, open(p, "w"), ensure_ascii=False, indent=1)
PYEOF
mv "$SRC2/$A/social-photo.md" "$T/social-photo.fora-do-ct.md"     # o "CT" deixa de ter o social-photo
PHOTO_H="$(h "$P13/$A/social-photo.md")"
inst "$T/13b.out" --source "$SRC2" --target "$P13" --match-target-squads
check "órfão: rc=0" [ "$RC" = "0" ]
check "órfão: ORPHAN_AGENT=social-photo" grep -q '^ORPHAN_AGENT=social-photo|' "$T/13b.out"
check "órfão social-*: manda rodar migrate-social-split.sh" grep -q '^ORPHAN_AGENT=social-photo|.*migrate-social-split.sh' "$T/13b.out"
check "órfão: ORPHAN_AGENTS=1 (próprio e criado pelo usuário não contam)" [ "$(kv ORPHAN_AGENTS "$T/13b.out")" = "1" ]
check "órfão: agente próprio (origin: custom) não é órfão" sh -c "! grep -q '^ORPHAN_AGENT=social-proprio' '$T/13b.out'"
check "órfão: agente criado pelo usuário não é órfão" sh -c "! grep -q '^ORPHAN_AGENT=social-meu' '$T/13b.out'"
check "órfão: nada removido (social-photo intacto)" [ "$(h "$P13/$A/social-photo.md")" = "$PHOTO_H" ]
check "órfão: agente do usuário em outro destino (dev-meu) nunca foi órfão" sh -c "! grep -q '^ORPHAN_AGENT=dev-meu' '$T/5f.out'"
inst "$T/13c.out" --source "$SRC2" --target "$P13" --squads social --dry-run
check "órfão: *install (sem --match-target-squads) não avisa" sh -c "! grep -q '^ORPHAN_AGENT=' '$T/13c.out'"
mv "$T/social-photo.fora-do-ct.md" "$SRC2/$A/social-photo.md"

# ═══ 14. hook opcional guard-env-files.sh (--with-env-guard) ═════════════════
echo "── 14. hook opcional guard-env-files.sh"
P14="$T/proj14 | env"; mkdir -p "$P14"
inst "$T/14a.out" --source "$SRC2" --target "$P14" --squads dev
check "env-guard: install sem a flag rc=0" [ "$RC" = "0" ]
check "env-guard: sem a flag o hook não é copiado" [ ! -e "$P14/.claude/hooks/guard-env-files.sh" ]
check "env-guard: sem a flag não é registrado" sh -c "! grep -q guard-env-files '$P14/.claude/settings.json'"
inst "$T/14b.out" --source "$SRC2" --target "$P14" --match-target-squads --with-env-guard
check "env-guard: com a flag rc=0" [ "$RC" = "0" ]
check "env-guard: ENV_GUARD_HOOK=installed" [ "$(kv ENV_GUARD_HOOK "$T/14b.out")" = "installed" ]
check "env-guard: hook copiado e executável" [ -x "$P14/.claude/hooks/guard-env-files.sh" ]
check "env-guard: registrado em Edit|Write|MultiEdit" python3 -c 'import json,sys; s=json.load(open(sys.argv[1])); sys.exit(0 if any(e.get("matcher")=="Edit|Write|MultiEdit" and "guard-env-files.sh" in str(e) for e in s["hooks"]["PreToolUse"]) else 1)' "$P14/.claude/settings.json"
inst "$T/14c.out" --source "$SRC2" --target "$P14" --match-target-squads
check "env-guard: propagate sem a flag mantém o hook (ENV_GUARD_HOOK=kept)" [ "$(kv ENV_GUARD_HOOK "$T/14c.out")" = "kept" ]
check "env-guard: propagate sem a flag não remove o registro" grep -q guard-env-files "$P14/.claude/settings.json"

# ═══ 11. nada fora da pasta temporária ═══════════════════════════════════════
check "Lixeira usada é a do HOME falso/da pasta do teste" sh -c "case '$TRASH' in '$T'/*) exit 0;; esac; exit 1"
check "CT real sem .team-os/ criado pelo teste em .claude" [ ! -e "$CT/.claude/agents/acme-writer.md" ]

echo ""
if [ $FAIL -eq 0 ]; then
  echo "✅ test-propagate: $PASS/$PASS verificações passaram."
  exit 0
fi
echo "❌ test-propagate: $FAIL falha(s) de $((PASS + FAIL))."
exit 1
