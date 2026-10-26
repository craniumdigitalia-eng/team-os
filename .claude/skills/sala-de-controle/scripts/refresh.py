#!/usr/bin/env python3
"""refresh.py — a "rodada de contexto" completa da Sala de Controle, num comando só.

Junta, a cada invocação da skill:
  1. org-map.py        → negócios, projetos, squads e o que está fora do padrão
  2. project-context.py (por projeto) → etapa de cada um, lida da smart-memory
  3. scan-sessions.py  → sessões reais abertas agora (sem fantasmas, sem a própria Sala)
  4. session-tail.py   → últimas falas de cada sessão aberta (o que ela está fazendo agora)
  5. carteira.py       → empresa × clientes: setores da empresa e o que cada cliente contratou
e casa sessão ↔ projeto pela pasta (cwd). Relatório: empresa primeiro (por setor), depois os
clientes da carteira, depois os outros negócios.

A Sala mora no CT (0 | Centro de Treinamento): rode a partir da raiz do CT. A raiz dos projetos
é a pasta-mãe do CT. Rodando fora do CT, a rodada funciona mas emite WARN=sala_fora_do_ct.

READ-ONLY em tudo que é de outro projeto. Única escrita: o snapshot da Sala em
<CT>/docs/smart-memory/sala-de-controle/snapshot.json (fora do git; sobrescrito a cada rodada).

Usage: refresh.py [--root <raiz>] [--days 7] [--turns 6] [--no-write]
  --root default: pai da pasta atual (no CT = pasta-mãe do CT).
Saída: relatório legível, projeto a projeto, agrupado por negócio.
"""
import json, os, subprocess, sys, time, unicodedata

# macOS: nomes de pasta vêm do disco em NFD ('ã' decomposto) e o cwd das sessões em NFC.
# Tudo que é comparado ou exibido passa por nfc() — senão sessão e projeto nunca batem.
def nfc(s):
    return unicodedata.normalize("NFC", s or "")


def same_dir(a, b):
    return nfc(os.path.abspath(a or "/")).rstrip("/") == nfc(os.path.abspath(b or "/")).rstrip("/")

HERE = os.path.dirname(os.path.abspath(__file__))
ARGS = sys.argv[1:]


def opt(name, default):
    if name in ARGS:
        try:
            return ARGS[ARGS.index(name) + 1]
        except IndexError:
            pass
    return default


ROOT = os.path.abspath(opt("--root", os.path.dirname(os.getcwd())))
DAYS = opt("--days", "7")
TURNS = opt("--turns", "6")
WRITE = "--no-write" not in ARGS
SELF_DIR = os.getcwd()
# Casa da Sala = o CT (tem a skill team-os-creator). Fora dele: avisa, não bloqueia.
HOME_IS_CT = os.path.isdir(os.path.join(SELF_DIR, ".claude", "skills", "team-os-creator"))


def run_json(script, *a):
    try:
        out = subprocess.run([sys.executable, os.path.join(HERE, script), *a, "--json"],
                             capture_output=True, text=True, timeout=120).stdout
        return json.loads(out)
    except Exception as e:
        return {"error": str(e)}


def tail(path):
    if not path:
        return [], "(sem conversa ainda)"
    try:
        out = subprocess.run([sys.executable, os.path.join(HERE, "session-tail.py"), path, TURNS, "220"],
                             capture_output=True, text=True, timeout=60).stdout.splitlines()
    except Exception:
        return [], "?"
    last = next((l.split("=", 1)[1] for l in out if l.startswith("LAST_ACTIVITY=")), "?")
    return [l for l in out if l.startswith("[")], last


org = run_json("org-map.py", ROOT)
cart = run_json("carteira.py", ROOT)
if not isinstance(cart, dict) or "error" in cart:
    cart = {"found": False, "clientes": [], "achados": [], "empresa": None}
sess = run_json("scan-sessions.py")
sessions = sess.get("sessions", []) if isinstance(sess, dict) else []
self_name = sess.get("self", "") if isinstance(sess, dict) else ""

projects = []
for n in org.get("nodes", []):
    if n.get("kind") not in ("projeto", "ct"):
        continue
    ctx = run_json("project-context.py", n["path"], "--days", DAYS)
    here = [s for s in sessions if s.get("IS_SELF") != "1" and same_dir(s.get("CWD", ""), n["path"])]
    for s in here:
        s["TAIL"], s["LAST_ACTIVITY"] = tail(s.get("TRANSCRIPT", ""))
    projects.append({"node": n, "context": ctx, "sessions": here})

others = [s for s in sessions if s.get("IS_SELF") != "1"
          and not any(same_dir(s.get("CWD", ""), p["node"]["path"]) for p in projects)]
for s in others:
    s["TAIL"], s["LAST_ACTIVITY"] = tail(s.get("TRANSCRIPT", ""))

snapshot = {"generated_at": time.strftime("%Y-%m-%d %H:%M"), "root": ROOT, "self": self_name,
            "home": "CT" if HOME_IS_CT else "",
            "projects": projects, "other_sessions": others, "findings": org.get("findings", []),
            "carteira": cart,
            "summary": org.get("summary", {})}

if WRITE:
    d = os.path.join(SELF_DIR, "docs", "smart-memory", "sala-de-controle")
    try:
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, "snapshot.json"), "w", encoding="utf-8") as f:
            json.dump(snapshot, f, ensure_ascii=False, indent=1)
    except Exception as e:
        print(f"WARN=snapshot_not_written|{e}")

# ── Relatório legível ────────────────────────────────────────────────────────
if not HOME_IS_CT:
    print(f"WARN=sala_fora_do_ct|a Sala de Controle mora no CT (0 | Centro de Treinamento); "
          f"esta sessão está em {nfc(SELF_DIR)} — abra a sessão da Sala no CT")
print(f"RODADA {snapshot['generated_at']} · raiz: {ROOT} · esta sessão: {self_name or '?'}")
print(f"Sessões abertas (fora esta): {sum(1 for s in sessions if s.get('IS_SELF') != '1')}")
print()
# Ordem: empresa (por setor) → clientes da carteira → outros negócios → soltos na raiz.
EMPRESA = nfc(cart.get("empresa") or "")
CLIENTES = {nfc(c.get("pasta", "")): c for c in cart.get("clientes", []) if c.get("pasta")}


def rank(x):
    b = nfc(x["node"].get("business") or "")
    return (0 if b and b == EMPRESA else 1 if b in CLIENTES else 2 if b else 3, b or "~", x["node"]["name"])


def header(b):
    if not b:
        return "━━ (sem negócio) ━━"
    if b == EMPRESA:
        return f"━━ {b} · EMPRESA (setores) ━━"
    c = CLIENTES.get(b)
    if c:
        serv = ", ".join(c.get("servicos") or []) or "—"
        nxt = f" · próxima: {c['proxima_entrega']}" if c.get("proxima_entrega") else ""
        return f"━━ {b} · cliente {c.get('status') or '?'} · contratou: {serv}{nxt} ━━"
    return f"━━ {b}{' · fora da carteira' if cart.get('found') else ''} ━━"


if cart.get("found"):
    print(f"Carteira: {len(cart['clientes'])} cliente(s) · empresa {EMPRESA}")
else:
    print("Carteira: ausente (a squad de Operações da empresa cria — formato em reference/carteira.md)")
print()
biz = None
for p in sorted(projects, key=rank):
    n, c = p["node"], p["context"]
    b = nfc(n.get("business") or "")
    if b != biz:
        biz = b
        print(header(b))
    shown = f"{n['name']} (casa da Sala)" if n.get("kind") == "ct" else n["name"]
    agents_txt = (f"{n['agents']} agentes-modelo do pack (não é equipe; trabalho no pack → /team-os-creator)"
                  if n.get("kind") == "ct" else f"{n['agents']} agentes ({','.join(n['squads']) or 'sem squad'})")
    print(f"■ {shown}  ·  {agents_txt}"
          f"  ·  smart-memory: {'sim' if n['smart_memory'] else 'NÃO'}  ·  última atividade: {c.get('LAST_TOUCH', '?')}")
    print(f"  o que é: {c.get('SUMMARY', '?')}")
    if c.get("LEDGER_FILE"):
        print(f"  ledger: {c['LEDGER_FILE']} ({c.get('LEDGER_UPDATED', '')}) — {c.get('LEDGER_TITLE', '')}")
        for l in c.get("LEDGER", [])[-8:]:
            print(f"    · {l}")
    for key, label in (("STORY_ACTIVE", "story ativa"), ("STORY_IN_REVIEW", "story em revisão"),
                       ("BACKLOG", "backlog"), ("INBOX", "inbox"), ("DIGEST", "digest"), ("DECISION", "decisão")):
        for v in c.get(key, [])[:5]:
            print(f"  {label}: {v}")
    if p["sessions"]:
        for s in p["sessions"]:
            st = "PARADA — ler a última fala (pergunta/permissão = aguardando você)" if s.get("STATE") == "blocked" else s.get("STATUS", "?")
            ns = s.get("NAME_STANDARD")
            if ns == "1" or (ns == "2" and len(p["sessions"]) == 1):
                flag = ""
            elif ns == "2":
                flag = f"  (várias sessões nesta pasta — dar título: '{s.get('SUGGESTED_NAME')}')"
            else:
                flag = f"  (nome fora do padrão → sugerir '{s.get('SUGGESTED_NAME')}')"
            print(f"  ▶ sessão \"{s['NAME']}\" · {s.get('KIND')} · {st} · última fala {s.get('LAST_ACTIVITY')}"
                  f"{' · id ' + s['SHORT_ID'] if s.get('SHORT_ID') else ''}{flag}")
            for t in s.get("TAIL", []):
                print(f"      {t}")
    else:
        print("  ▷ nenhuma sessão aberta")
    print()
if others:
    print("━━ Sessões fora dos projetos mapeados ━━")
    for s in others:
        why = "PASTA NÃO EXISTE MAIS (órfã)" if s.get("ORPHAN") == "1" else (s.get("CWD") or "sem pasta")
        print(f"  ▶ \"{s['NAME']}\" · {s.get('STATUS')} · {why}")
        for t in s.get("TAIL", [])[-3:]:
            print(f"      {t}")
    print()
ca = cart.get("achados", [])
if ca:
    print(f"━━ Carteira: {len(ca)} ponto(s) a conferir ━━")
    for x in ca:
        print(f"  • [{x['code']}] {x['where']} — {x['what']}")
    print()
f = org.get("findings", [])
print(f"━━ Organização: {len(f)} ponto(s) fora do padrão ━━")
for x in f:
    print(f"  • [{x['code']}] {x['where']} — {x['what']} → {x['suggestion']}")
