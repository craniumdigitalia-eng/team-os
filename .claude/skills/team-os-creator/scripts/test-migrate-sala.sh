#!/usr/bin/env bash
# test-migrate-sala.sh — teste hermético do migrate-sala-to-ct.sh (Sala de Controle de uma pasta
# antiga → CT/docs/smart-memory/sala-de-controle/ + pasta antiga para a Lixeira).
#
# Tudo numa pasta temporária, com HOME, TMPDIR e Lixeira falsos (TEAM_OS_TRASH_DIR); o CT é
# sintético (só o script, o trash.sh e um .gitignore) e a pasta antiga também.
#
# Cenários: dry-run não grava · --apply copia, pula PANORAMA/snapshot, leva o maestri para
# historico-maestri/, colisão vira -da-pasta-antiga, anota registry e dispatches, cria INDEX.md e
# manda a pasta para a Lixeira falsa · 2ª execução idempotente (SAME) · recusa pasta == CT, pasta
# sem Sala e CT sem docs/smart-memory/ no .gitignore · sessão aberta simulada → HOLD_TRASH, e depois
# de fechada o --apply termina o trabalho.
#
# Uso: bash test-migrate-sala.sh   (exit 0 = tudo passou). Bash 3.2-safe; precisa de python3.

set -u

SRC_SCRIPTS="$(cd "$(dirname "$0")" && pwd)"
CT_REAL="$(cd "$SRC_SCRIPTS/../../../.." && pwd)"
ORIG_TMP="${TMPDIR:-/tmp}"; ORIG_TMP="${ORIG_TMP%/}"
T="$(mktemp -d "$ORIG_TMP/team-os-test-sala.XXXXXX")" || exit 1
[ "${TEAM_OS_TEST_KEEP:-0}" = "1" ] && echo "(mantendo $T)" || trap 'rm -rf "$T"' EXIT

export HOME="$T/home"
export TMPDIR="$T/tmp"
export XDG_DATA_HOME="$T/home/.local/share"
export TEAM_OS_TRASH_DIR="$T/lixeira"
mkdir -p "$HOME/.claude/sessions" "$TMPDIR"

PASS=0; FAIL=0
ok()   { PASS=$((PASS + 1)); }
bad()  { FAIL=$((FAIL + 1)); echo "  ❌ $*"; }
check() { local d="$1"; shift; if "$@"; then ok; else bad "$d"; fi; }
treehash() {
  python3 - "$1" <<'PYEOF'
import hashlib, os, sys
root = sys.argv[1]; h = hashlib.sha256()
if os.path.isdir(root):
    for d, dirs, files in sorted(os.walk(root)):
        dirs.sort()
        for n in sorted(files):
            p = os.path.join(d, n)
            h.update(os.path.relpath(p, root).encode() + b"\0" + open(p, "rb").read())
print(h.hexdigest())
PYEOF
}

H_REAL="$(treehash "$CT_REAL/docs/smart-memory")"

# CT sintético mínimo
CT="$T/0 | Centro de Treinamento"
S=".claude/skills/team-os-creator/scripts"
mkdir -p "$CT/$S"
cp "$SRC_SCRIPTS/migrate-sala-to-ct.sh" "$SRC_SCRIPTS/trash.sh" "$CT/$S/"
printf '.DS_Store\ndocs/smart-memory/\n' > "$CT/.gitignore"
mig() {  # mig <saída> <args...> → rc em $RC
  local o="$1"; shift
  bash "$CT/$S/migrate-sala-to-ct.sh" "$@" > "$o" 2>&1; RC=$?
}
SM="$CT/docs/smart-memory"
SD="$SM/sala-de-controle"

mk_old() {  # mk_old <pasta> → pasta antiga sintética
  local o="$1"
  mkdir -p "$o/.claude/skills/sala-de-controle" "$o/docs/smart-memory/sala-de-controle" "$o/docs/smart-memory/maestri"
  printf -- '---\nname: sala-de-controle\n---\n' > "$o/.claude/skills/sala-de-controle/SKILL.md"
  printf '# Registro\n- Site → João | Site\n' > "$o/docs/smart-memory/sala-de-controle/registry.md"
  printf '# Despachos\n- 2026-10-01 site: atualizar home\n' > "$o/docs/smart-memory/sala-de-controle/dispatches.md"
  printf '# Organização\nraiz → negócios\n' > "$o/docs/smart-memory/sala-de-controle/organizacao.md"
  printf '# PANORAMA gerado\n' > "$o/docs/smart-memory/sala-de-controle/PANORAMA.md"
  printf '{"x":1}\n' > "$o/docs/smart-memory/sala-de-controle/snapshot.json"
  printf '# Terminais Maestri\n- site\n' > "$o/docs/smart-memory/maestri/registry.md"
}

# ═══ 1. dry-run ═════════════════════════════════════════════════════════════
echo "── 1. dry-run"
OLD="$T/1 | Sala de Controle"; mk_old "$OLD"
mkdir -p "$SD"; printf '# Organização do CT (diferente)\n' > "$SD/organizacao.md"   # colisão
H_OLD="$(treehash "$OLD")"; H_SM="$(treehash "$SM")"
mig "$T/1.out" "$OLD"
check "dry: rc=0" [ "$RC" = "0" ]
check "dry: COPY do registry" grep -q "^COPY=$OLD/docs/smart-memory/sala-de-controle/registry.md|$SD/registry.md$" "$T/1.out"
check "dry: maestri → historico-maestri" grep -q "^COPY=.*/maestri/registry.md|$SD/historico-maestri/registry.md$" "$T/1.out"
check "dry: SKIP_REGEN" grep -q '^SKIP_REGEN=PANORAMA.md|snapshot.json$' "$T/1.out"
check "dry: PANORAMA não é copiado" sh -c "! grep -q '^COPY=.*PANORAMA' '$T/1.out'"
check "dry: colisão vira RENAME" grep -q '^RENAME=organizacao-da-pasta-antiga.md|' "$T/1.out"
check "dry: SESSIONS_OPEN vazio" grep -qx 'SESSIONS_OPEN=' "$T/1.out"
check "dry: TRASH da pasta antiga" grep -qx "TRASH=$OLD" "$T/1.out"
check "dry: RESUMO em pt-BR" grep -q '^RESUMO:' "$T/1.out"
check "dry: pasta antiga intocada" [ "$(treehash "$OLD")" = "$H_OLD" ]
check "dry: smart-memory do CT intocada" [ "$(treehash "$SM")" = "$H_SM" ]
check "dry: nada na Lixeira" [ ! -e "$T/lixeira" ]

# ═══ 2. --apply ═════════════════════════════════════════════════════════════
echo "── 2. --apply"
mig "$T/2.out" "$OLD" --apply
check "apply: rc=0" [ "$RC" = "0" ]
check "apply: registry copiado" grep -q 'Site → João | Site' "$SD/registry.md"
check "apply: dispatches copiado" grep -q 'atualizar home' "$SD/dispatches.md"
check "apply: maestri em historico-maestri" grep -q 'Terminais Maestri' "$SD/historico-maestri/registry.md"
check "apply: PANORAMA não veio" [ ! -e "$SD/PANORAMA.md" ]
check "apply: snapshot não veio" [ ! -e "$SD/snapshot.json" ]
check "apply: original do CT intacto na colisão" grep -qx '# Organização do CT (diferente)' "$SD/organizacao.md"
check "apply: colisão copiada com sufixo" grep -q 'raiz → negócios' "$SD/organizacao-da-pasta-antiga.md"
check "apply: nota datada no registry" grep -q "^> \*\*Sala migrada para o CT em $(date +%Y-%m-%d):\*\* antes em \`$OLD\`\.$" "$SD/registry.md"
check "apply: linha de histórico no dispatches" grep -q "Sala migrada para o CT; antes em \`$OLD\`" "$SD/dispatches.md"
check "apply: INDEX.md criado" grep -q 'sala-de-controle/registry' "$SM/INDEX.md"
check "apply: pasta antiga saiu do lugar" [ ! -e "$OLD" ]
check "apply: pasta antiga na Lixeira falsa" [ -f "$T/lixeira/1 | Sala de Controle/docs/smart-memory/sala-de-controle/registry.md" ]
check "apply: TRASHED na saída" grep -q "^TRASHED=$OLD|" "$T/2.out"
check "apply: .claude do CT só tem o que já tinha" [ "$(cd "$CT/.claude" && find . -type f | sort | tr '\n' ' ')" = "./skills/team-os-creator/scripts/migrate-sala-to-ct.sh ./skills/team-os-creator/scripts/trash.sh " ]

# ═══ 3. 2ª execução (mesma memória numa pasta antiga recriada) → idempotente ════
echo "── 3. idempotência"
mk_old "$OLD"
H_SD="$(treehash "$SD")"
mig "$T/3.out" "$OLD" --apply
check "idem: rc=0" [ "$RC" = "0" ]
check "idem: nenhum COPY" sh -c "! grep -q '^COPY=' '$T/3.out'"
check "idem: registry SAME (apesar da nota)" grep -q '^SAME=docs/smart-memory/sala-de-controle/registry.md$' "$T/3.out"
check "idem: colisão já resolvida → SAME" grep -q '^SAME=docs/smart-memory/sala-de-controle/organizacao-da-pasta-antiga.md$' "$T/3.out"
check "idem: nota não duplicada" grep -q '^NOTE_SAME=docs/smart-memory/sala-de-controle/registry.md$' "$T/3.out"
check "idem: smart-memory do CT igual" [ "$(treehash "$SD")" = "$H_SD" ]
check "idem: pasta antiga foi para a Lixeira (nome com sufixo)" sh -c "[ ! -e '$OLD' ] && ls '$T/lixeira' | grep -q '^1 | Sala de Controle\.'"

# ═══ 4. recusas ═════════════════════════════════════════════════════════════
echo "── 4. recusas"
mig "$T/4a.out" "$CT" --apply
check "recusa pasta == CT (exit 2)" [ "$RC" = "2" ]
check "recusa pasta == CT: ERROR=" grep -q '^ERROR=old_is_ct' "$T/4a.out"
NOSALA="$T/Cliente | Site"; mkdir -p "$NOSALA/docs/smart-memory/agents"
mig "$T/4b.out" "$NOSALA" --apply
check "recusa pasta sem Sala (exit 2)" [ "$RC" = "2" ]
check "recusa pasta sem Sala: ERROR=" grep -q '^ERROR=not_a_sala_folder' "$T/4b.out"
check "pasta sem Sala intocada" [ -d "$NOSALA/docs/smart-memory/agents" ]
mig "$T/4c.out" "$T" --apply
check "recusa pasta que contém o CT (exit 2)" [ "$RC" = "2" ]
CT2="$T/ct-sem-ignore"; mkdir -p "$CT2"; printf '.DS_Store\n' > "$CT2/.gitignore"
OLD2="$T/sala-x"; mk_old "$OLD2"
mig "$T/4d.out" "$OLD2" --apply --ct "$CT2"
check "CT sem docs/smart-memory/ no .gitignore → ERROR" grep -q '^ERROR=smart_memory_not_ignored' "$T/4d.out"
check "CT sem ignore: nada gravado" [ ! -e "$CT2/docs" ]
check "CT sem ignore: pasta antiga fica" [ -d "$OLD2" ]

# ═══ 5. sessão aberta na pasta antiga → HOLD_TRASH ══════════════════════════
echo "── 5. sessões abertas"
OLD3="$T/2 | Sala Velha"; mk_old "$OLD3"
printf '# Registro\n- outro projeto\n' > "$OLD3/docs/smart-memory/sala-de-controle/registry.md"
sleep 300 & LIVE=$!
printf '{"pid":%s,"sessionId":"aaaa1111-x","cwd":"%s","name":"Sala antiga"}\n' "$LIVE" "$OLD3" > "$HOME/.claude/sessions/$LIVE.json"
printf '{"pid":999999,"sessionId":"bbbb2222-x","cwd":"%s","name":"Fantasma"}\n' "$OLD3" > "$HOME/.claude/sessions/999999.json"
printf '{"pid":%s,"sessionId":"cccc3333-x","cwd":"%s","name":"Outro"}\n' "$LIVE" "$T/outro" > "$HOME/.claude/sessions/1.json"
mig "$T/5a.out" "$OLD3"
check "sess dry: só a sessão viva da pasta" grep -qx 'SESSIONS_OPEN=Sala antiga' "$T/5a.out"
mig "$T/5b.out" "$OLD3" --apply
check "sess apply: rc=0" [ "$RC" = "0" ]
check "sess apply: HOLD_TRASH=sessions_open" grep -qx 'HOLD_TRASH=sessions_open' "$T/5b.out"
check "sess apply: pasta antiga fica" [ -d "$OLD3" ]
check "sess apply: memória copiada (colisão → sufixo)" grep -q 'outro projeto' "$SD/registry-da-pasta-antiga.md"
check "sess apply: orientação para fechar e rodar de novo" grep -q 'feche as sessões' "$T/5b.out"
kill "$LIVE" 2>/dev/null; wait "$LIVE" 2>/dev/null
mig "$T/5c.out" "$OLD3" --apply
check "sess fechada: 2ª execução sem COPY" sh -c "! grep -q '^COPY=' '$T/5c.out'"
check "sess fechada: pasta vai para a Lixeira" [ ! -e "$OLD3" ]
check "sess fechada: TRASHED" grep -q "^TRASHED=$OLD3|" "$T/5c.out"

# ═══ 6. pasta com agentes (projeto de verdade) nunca vai para a Lixeira ═════
echo "── 6. pasta com agentes"
OLD4="$T/Projeto com Sala"; mk_old "$OLD4"; mkdir -p "$OLD4/.claude/agents"; printf 'x\n' > "$OLD4/.claude/agents/dev-qa.md"
mig "$T/6.out" "$OLD4" --apply
check "agentes: HOLD_TRASH=not_sala_only" grep -qx 'HOLD_TRASH=not_sala_only' "$T/6.out"
check "agentes: pasta fica" [ -f "$OLD4/.claude/agents/dev-qa.md" ]

# ═══ 7. nada fora da pasta temporária ═══════════════════════════════════════
check "smart-memory do CT real intocada" [ "$(treehash "$CT_REAL/docs/smart-memory")" = "$H_REAL" ]

echo ""
if [ $FAIL -eq 0 ]; then
  echo "✅ test-migrate-sala: $PASS/$PASS verificações passaram."
  exit 0
fi
echo "❌ test-migrate-sala: $FAIL falha(s) de $((PASS + FAIL))."
exit 1
