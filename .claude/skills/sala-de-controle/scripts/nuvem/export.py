#!/usr/bin/env python3
"""export.py — gera os arquivos do painel da Sala na nuvem (dashboard no claude.ai). READ-ONLY.

Reaproveita o coletor do painel local (painel/collect.py) e a carteira (carteira.py) e grava
cinco JSON pequenos, um por quadro do painel, em <CT>/docs/smart-memory/sala-de-controle/nuvem/
(fora do git). Quem sobe os arquivos para o dashboard é a sessão da Sala (Artifact asset +
ArtifactData), a cada rodada — este script não fala com a rede.

  resumo.json    1 linha: contadores do momento (sessões, agentes, aguardando você, tokens…)
  projetos.json  1 linha por projeto: grupo (empresa/cliente/outro), negócio, área, etapa
  sessoes.json   1 linha por sessão aberta: estado, agentes, tokens, contexto
  carteira.json  1 linha por cliente: status, serviços, próxima entrega, situação
  alertas.json   1 linha por ponto de atenção: aguardando você, entrega vencida, organização
  pedidos.json   1 linha por despacho da Sala (dispatches.md): pedido, sessão, status
  agentes.json   1 linha por agente trabalhando agora (+ o líder de cada sessão): quem é,
                 onde está (grupo → negócio → projeto), estado e o que faz — é o "prédio"

O que NÃO sai daqui: falas das conversas, comandos, conteúdo de nota, valores de contrato, dado
pessoal. O "o que faz" do agente é só o tipo de ação (+ nome do arquivo ou do colega).
Etapa e resumo vão cortados em 140 caracteres.

Usage: export.py [--root <raiz>] [--out <pasta>] [--wait 20]
       export.py --sent <nome>=<asset_id> [<nome>=<asset_id> …]   (depois de subir: registra o envio)
Saída: OUT=<pasta>, URL=<dashboard> (de <out>/enviado.json), uma linha
FILE=<nome>|<linhas>|changed|same|<asset_id anterior> por arquivo. Só os `changed` precisam
subir; o asset anterior de cada um é apagado depois que o dataset aponta para o novo.
"""
import json, os, re, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
SCRIPTS = os.path.dirname(HERE)
sys.path.insert(0, os.path.join(SCRIPTS, "painel"))
import collect  # noqa: E402
import tokens   # noqa: E402

ARGS = sys.argv[1:]


def opt(name, default):
    if name in ARGS:
        try:
            return ARGS[ARGS.index(name) + 1]
        except IndexError:
            pass
    return default


import hashlib

CT = os.getcwd()
ROOT = os.path.abspath(opt("--root", os.path.dirname(CT)))
OUT = os.path.abspath(opt("--out", os.path.join(CT, "docs", "smart-memory", "sala-de-controle", "nuvem")))
WAIT = float(opt("--wait", "20"))
NOW = time.strftime("%Y-%m-%dT%H:%M:%S")
TODAY = time.strftime("%Y-%m-%d")


def cut(s, n=140):
    s = re.sub(r"\s+", " ", s or "").strip()
    return s if len(s) <= n else s[: n - 1].rstrip() + "…"


def carteira():
    try:
        out = subprocess.run([sys.executable, os.path.join(SCRIPTS, "carteira.py"), ROOT, "--json"],
                             capture_output=True, text=True, timeout=120).stdout
        return json.loads(out)
    except Exception:
        return {"found": False, "clientes": [], "achados": [], "empresa": None}


SENT = os.path.join(OUT, "enviado.json")


def load_sent():
    try:
        return json.load(open(SENT, encoding="utf-8"))
    except Exception:
        return {"url": "", "files": {}}


if "--sent" in ARGS:  # registra o que acabou de subir: nome=asset_id
    sent = load_sent()
    for pair in ARGS[ARGS.index("--sent") + 1:]:
        if "=" not in pair or pair.startswith("--"):
            continue
        name, asset = pair.split("=", 1)
        f = os.path.join(OUT, name + ".json")
        h = hashlib.sha256(open(f, "rb").read()).hexdigest() if os.path.isfile(f) else ""
        sent["files"][name] = {"asset": asset, "sha": h, "at": time.strftime("%Y-%m-%dT%H:%M:%S")}
        print(f"SENT={name}|{asset}")
    json.dump(sent, open(SENT, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    sys.exit(0)

st = collect.collect(ROOT)
# os tokens são lidos numa thread de fundo: espera ficarem prontos (ou desiste após --wait s)
deadline = time.time() + WAIT
trs = {}
for s in st["sessions"]:
    found = [p for p in collect.glob.glob(os.path.join(collect.PROJ_DIR, "*", s["id"] + ".jsonl"))] if s["id"] else []
    if found:
        trs[s["id"]] = found[0]
while time.time() < deadline and not all((tokens.summary(p) or {}).get("ready") for p in trs.values()):
    time.sleep(0.5)
for s in st["sessions"]:
    if s["id"] in trs:
        s["tokens"] = tokens.summary(trs[s["id"]])

cart = carteira()
EMPRESA = collect.nfc(cart.get("empresa") or "")
if not EMPRESA:  # sem carteira ainda: a empresa é o negócio que tem o setor de Operações
    EMPRESA = next((p["business"] for p in st["projects"]
                    if p.get("business") and p["name"].endswith(" | Operações")), "")
CLIENTES = {collect.nfc(c.get("pasta", "")): c for c in cart.get("clientes", []) if c.get("pasta")}


def grupo(business):
    if business and business == EMPRESA:
        return "empresa"
    if business in CLIENTES:
        return "cliente"
    return "outro" if business else "solto"


ESTADO = {"blocked": "aguardando você", "busy": "trabalhando", "working": "trabalhando",
          "idle": "livre", "waiting": "aguardando você"}
sessoes, by_project = [], {}
for s in st["sessions"]:
    if s.get("is_self"):
        continue
    t = s.get("tokens") or {}
    estado = ESTADO.get(s.get("state") or s.get("status") or "", s.get("status") or "?")
    if any(a.get("state") == "active" for a in s.get("agents", [])):
        estado = "trabalhando"
    proj = next((p for p in st["projects"] if p["path"] == s.get("project")), None)
    row = {"id": s["short"], "sessao": s["name"] or s["short"], "projeto": proj["name"] if proj else (s.get("folder") or ""),
           "negocio": proj["business"] if proj else "", "estado": estado,
           "agentes": len(s.get("agents", [])),
           "agentes_ativos": sum(1 for a in s.get("agents", []) if a.get("state") == "active"),
           "tokens": int(t.get("total") or 0), "contexto_k": round((t.get("ctx") or 0) / 1000),
           "nivel_contexto": {"high": "alto", "warn": "atenção"}.get(t.get("level"), "ok"),
           "ultima_atividade": time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime(s["last_epoch"])) if s.get("last_epoch") else ""}
    sessoes.append(row)
    by_project.setdefault(s.get("project"), []).append(row)

projetos = []
for p in st["projects"]:
    if p.get("kind") == "ct":
        continue
    b = p.get("business") or ""
    ss = by_project.get(p["path"], [])
    area = p["name"].split(" | ", 1)[-1] if " | " in p["name"] else p["name"]
    projetos.append({"grupo": grupo(b), "negocio": b or "(sem negócio)", "projeto": p["name"], "area": area,
                     "squads": ", ".join(p.get("squads", [])), "etapa": cut(p.get("stage")) or "sem registro",
                     "ultima_atividade": (p.get("last_touch") or "").replace(" ", "T") if (p.get("last_touch") or "")[:1].isdigit() else "",
                     "sessoes": len(ss), "aguardando_voce": sum(1 for r in ss if r["estado"] == "aguardando você")})
ordem = {"empresa": 0, "cliente": 1, "outro": 2, "solto": 3}
projetos.sort(key=lambda r: (ordem[r["grupo"]], r["negocio"], r["area"]))

cart_rows = []
for c in cart.get("clientes", []):
    d = re.match(r"(\d{4}-\d{2}-\d{2})", c.get("proxima_entrega") or "")
    data = d.group(1) if d else ""
    ativo = (c.get("status") or "").lower() not in ("encerrado", "pausado")
    cart_rows.append({"cliente": c["cliente"], "status": c.get("status") or "?",
                      "servicos": ", ".join(c.get("servicos") or []),
                      "servicos_sem_pasta": sum(1 for x in c.get("projetos", []) if not x.get("projeto")),
                      "proxima_entrega": cut(c.get("proxima_entrega"), 80), "data_entrega": data,
                      "situacao": "vencida" if data and data < TODAY and ativo else "no prazo" if data else "sem data"})
cart_rows.sort(key=lambda r: (r["data_entrega"] or "9999", r["cliente"]))

alertas = []
for r in sessoes:
    if r["estado"] == "aguardando você":
        alertas.append({"tipo": "aguardando você", "gravidade": "alta", "onde": r["sessao"],
                        "oque": "a sessão parou esperando uma resposta ou permissão sua"})
    if r["nivel_contexto"] == "alto":
        alertas.append({"tipo": "contexto cheio", "gravidade": "média", "onde": r["sessao"],
                        "oque": f"{r['contexto_k']}k tokens no contexto — compactar ou abrir sessão nova"})
NOMES = {"ENTREGA_VENCIDA": ("entrega vencida", "alta"), "FALTA_PROJETO": ("serviço sem pasta", "média"),
         "CLIENTE_SEM_PASTA": ("cliente sem pasta", "média"), "PROJETO_SEM_CONTRATO": ("pasta sem contrato", "baixa"),
         "NEGOCIO_FORA_DA_CARTEIRA": ("fora da carteira", "baixa")}
for a in cart.get("achados", []):
    tipo, g = NOMES.get(a["code"], (a["code"].lower(), "baixa"))
    alertas.append({"tipo": tipo, "gravidade": g, "onde": a["where"], "oque": cut(a["what"])})
org = collect.org(ROOT)
for f in org.get("findings", []):
    alertas.append({"tipo": "organização", "gravidade": "baixa", "onde": f["where"], "oque": cut(f["what"])})
alertas.sort(key=lambda r: {"alta": 0, "média": 1, "baixa": 2}[r["gravidade"]])
for i, r in enumerate(alertas):
    r["id"] = f"a{i + 1}"

# Despachos: "- [AAAA-MM-DD HH:MM] → "<Sessão>" (<Projeto>) · <pedido> · status: <…>"
pedidos = []
disp = os.path.join(CT, "docs", "smart-memory", "sala-de-controle", "dispatches.md")
if os.path.isfile(disp):
    sec = ""
    for line in open(disp, encoding="utf-8"):
        if line.startswith("## "):
            sec = "andamento" if "andamento" in line.lower() else "concluído"
        m = re.match(r'^- \[(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2})\] → "([^"]+)"(?: \(([^)]*)\))? · (.*?) · status: (.*)$', line.strip())
        if m:
            pedidos.append({"quando": f"{m.group(1)}T{m.group(2)}", "sessao": m.group(3), "projeto": m.group(4) or "",
                            "pedido": cut(m.group(5), 120), "status": cut(m.group(6), 120),
                            "situacao": "em andamento" if sec == "andamento" else "concluído"})
pedidos.sort(key=lambda r: r["quando"], reverse=True)

resumo = [{"gerado_em": NOW,
           "sessoes_abertas": len(sessoes),
           "trabalhando": sum(1 for r in sessoes if r["estado"] == "trabalhando"),
           "aguardando_voce": sum(1 for r in sessoes if r["estado"] == "aguardando você"),
           "agentes_ativos": sum(r["agentes_ativos"] for r in sessoes),
           "tokens_sessoes_abertas": sum(r["tokens"] for r in sessoes),
           "projetos": len(projetos), "clientes": len(cart_rows),
           "clientes_ativos": sum(1 for r in cart_rows if r["status"].lower() == "ativo"),
           "entregas_vencidas": sum(1 for r in cart_rows if r["situacao"] == "vencida"),
           "pedidos_em_andamento": sum(1 for r in pedidos if r["situacao"] == "em andamento"),
           "empresa": EMPRESA or "", "carteira": "sim" if cart.get("found") else "não"}]

# ── Prédio: quem está trabalhando agora ─────────────────────────────────────
AG_DIR = os.path.join(CT, ".claude", "agents")


def persona(agent_type):
    """'VERA, estrategista…' no description do agente do pack → ('VERA', 'estrategista…')."""
    f = os.path.join(AG_DIR, (agent_type or "") + ".md")
    try:
        head = open(f, encoding="utf-8").read(3000)
    except Exception:
        return "", ""
    m = re.search(r"^description:\s*['\"]?(.*)$", head, re.M)
    d = (m.group(1) if m else "").strip("'\" ")
    mm = re.match(r"^([A-ZÁÉÍÓÚÂÊÔÃÕÇ]{3,})[ ,—–-]+(.*)", d)
    if mm:
        return mm.group(1), cut(mm.group(2), 70)
    mm = re.match(r"^([A-ZÁÉÍÓÚ][a-záéíóúâêôãõç]+) — (.*)", d)   # 'Serak — Inteligência de portfólio'
    return (mm.group(1), cut(mm.group(2), 70)) if mm else ("", cut(d, 70))


ACAO = {"Read": "lendo", "Write": "escrevendo", "Edit": "editando", "NotebookEdit": "editando",
        "Bash": "rodando um comando", "Grep": "procurando", "Glob": "procurando",
        "WebSearch": "pesquisando na web", "WebFetch": "lendo uma página", "SendMessage": "falando com"}


def acao(tool):
    if not tool:
        return ""
    name, arg = tool[0], tool[1] if len(tool) > 1 else ""
    verb = ACAO.get(name) or ("organizando tarefas" if name.startswith("Task") else
                              "usando " + name.split("__")[1] if name.startswith("mcp__") and "__" in name[5:] else "trabalhando")
    if name in ("Read", "Write", "Edit", "NotebookEdit") and arg:
        return f"{verb} {os.path.basename(arg)}"
    if name == "SendMessage" and arg:
        return f"{verb} {cut(arg.lstrip('→ ').split(' · ')[0], 40)}"
    return verb


EST_AG = {"active": "trabalhando", "approval": "aguardando você", "waiting": "esperando", "idle": "parado"}
agentes = []
for s in st["sessions"]:
    if s.get("is_self"):
        continue
    proj = next((p for p in st["projects"] if p["path"] == s.get("project")), None)
    b = proj["business"] if proj else ""
    base = {"sessao": s["name"] or s["short"], "projeto": proj["name"] if proj else (s.get("folder") or ""),
            "negocio": b or "(sem negócio)", "grupo": grupo(b)}
    lead_state = ESTADO.get(s.get("state") or s.get("status") or "", "?")
    agentes.append({**base, "agente": "líder da sessão", "persona": "", "papel": "coordena o time",
                    "squad": "", "estado": lead_state, "faz_agora": acao(s.get("tool")),
                    "tokens": int((s.get("tokens") or {}).get("lead", {}).get("total", 0) if (s.get("tokens") or {}).get("lead") else 0)})
    tk = {a["name"]: a for a in (s.get("tokens") or {}).get("agents", [])}
    for a in s.get("agents", []):
        nome, papel = persona(a.get("type"))
        agentes.append({**base, "agente": a["name"], "persona": nome, "papel": papel,
                        "squad": (a.get("type") or "").split("-")[0], "estado": EST_AG.get(a.get("state"), a.get("state")),
                        "faz_agora": acao(a.get("tool")), "tokens": int(tk.get(a["name"], {}).get("total", 0))})

os.makedirs(OUT, exist_ok=True)
sent = load_sent()
print(f"OUT={OUT}")
print(f"URL={sent.get('url', '')}")
for name, rows in (("resumo", resumo), ("projetos", projetos), ("sessoes", sessoes),
                   ("carteira", cart_rows), ("alertas", alertas), ("pedidos", pedidos), ("agentes", agentes)):
    body = json.dumps({"rows": rows}, ensure_ascii=False, indent=1)
    with open(os.path.join(OUT, name + ".json"), "w", encoding="utf-8") as f:
        f.write(body)
    h = hashlib.sha256(body.encode("utf-8")).hexdigest()
    prev = sent["files"].get(name, {})
    state = "same" if prev.get("sha") == h else "changed"
    print(f"FILE={name}|{len(rows)}|{state}|{prev.get('asset', '')}")
