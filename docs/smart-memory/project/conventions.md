---
title: Convenções
tags: [conventions, naming, agents, skills, scripts]
updated: 2026-05-19
---

# Convenções do Projeto

## Nomenclatura de arquivos

### Agentes (`.claude/agents/`)
- Padrão: `{squad}-{role}.md` em kebab-case
- Squads válidos: `dev`, `sites`, `social`, `traffic`
- Exemplos: `dev-analyst.md`, `sites-dev-alpha.md`, `social-design.md`, `traffic-strategist.md`
- Nomes de persona (ficcionais) vivem dentro do arquivo, não no nome do arquivo

### Skills (`.claude/skills/`)
- Padrão: `{squad}-{funcionalidade}/SKILL.md` — cada skill é uma pasta com `SKILL.md` obrigatório
- Skills core sem squad: `team-os/`, `team-os-creator/`, `ui-ux-pro-max/`, `accessibility/`, `web-design-guidelines/`
- Exemplos: `dev-defuddle/SKILL.md`, `sites-seo-technical/SKILL.md`, `social-apify-research/SKILL.md`

### Scripts (`.claude/skills/team-os-creator/scripts/`)
- Padrão: `{ação}-{substantivo}.sh` em kebab-case
- Exemplos: `install-to-project.sh`, `scan-ct-projects.sh`, `diff-agents.sh`, `validate-agent.sh`

### Smart-memory (`docs/smart-memory/`)
- Pastas: `project/`, `agents/research/`, `ops/`, `decisions/`, `stories/backlog/`, `stories/active/`, `stories/done/`
- Arquivos: kebab-case, `.md`, com frontmatter YAML obrigatório
- `INDEX.md` na raiz — deve ser atualizado ao criar qualquer arquivo novo

### Assets de campanha social
- Padrão: `{campaign-id}_{formato}_{versão}_{variante}.png`
- Exemplo: `camp001_feed_v1_a.png`, `camp001_carousel_slide01_v1.png`

---

## Frontmatter de agentes

Campos obrigatórios em todo `.claude/agents/*.md`:

```yaml
---
name: {slug-kebab-case}
description: {1-2 frases: papel + casos de uso + quando chamar}
model: sonnet
memory: project
tools: {lista separada por vírgula}
color: {cyan|yellow|green|pink|purple|orange|blue}
---
```

Campos opcionais observados:
- `isolation: worktree` — dev-dev-* usam para isolamento de branch
- `permissionMode: acceptEdits` — dev-dev-*, dev-devops, sites equivalentes
- `hooks:` — campo vazio ou lista; dev-dev-* têm campo presente (hook block-git-push referenciado)

---

## Estrutura interna dos agentes

Todo agente segue esta sequência no corpo:

1. **Contrato com team-os** — bloco padronizado, copiado identicamente em todos os agentes; define: coordenação via SendMessage, smart-memory como source of truth, self-claim de tasks, proibição de `Agent()` e nested teams, autoridades exclusivas, atualização do INDEX, escalação em 2 tentativas
2. **Identidade/Persona** — nome fictício, espécie arcturiana, frases de abertura e entrega
3. **Instruções de domínio** — o que o agente faz, como trabalha, protocolos específicos
4. **Notificação obrigatória** — template de SendMessage ao concluir
5. **Regras absolutas** — invariantes do agente
6. **Skills disponíveis** — lista de `/skill-name` que o agente pode invocar

---

## Contrato com team-os (bloco padrão)

Presente em todos os agentes. 8-9 regras numeradas. As invariantes comuns:
- Lead é sempre a skill `/team-os` na main session — nunca outro agente
- Smart-memory é source of truth — ler antes, atualizar depois
- Self-claim permitido: ao terminar task, pegar próxima compatível e avisar lead
- Nunca spawnar agentes (`Agent()` proibido), nunca nested teams
- Atualizar `docs/smart-memory/INDEX.md` ao criar arquivo
- Escalação rápida: 2 tentativas sem resolução → SendMessage ao lead imediato
- Task lifecycle (alguns agentes): `TaskUpdate(in_progress)` ao iniciar, `TaskUpdate(completed)` ao concluir

---

## Padrões de scripts shell

### Saída (stdout)
- Erros: `KEY=VALUE` com pipe `|` separando campos — ex: `ERROR=missing_target|SOURCE=foo|TARGET=bar`
- Status incremental: `STATUS=starting`, `STATUS=done`
- Campos de contexto: `SOURCE=nome`, `TARGET=nome`, `SQUADS=dev,sites`
- Separadores de seção: `---` (linha literal)

### Exit codes
- `exit 0` — sucesso ou sem problemas detectados
- `exit 1` — erro de parâmetro/configuração
- `exit 2` — feedback para o Chief (bloqueio, alerta, lista de problemas)

### Flags de entrada
- `--flag valor` com `case "$1" in` + `shift 2`
- Flags booleanas: `--dry-run`, `--include-hooks` → variáveis `DRY_RUN=0/1`
- Defaults definidos logo após o parse de argumentos

### Shebang e compatibilidade
- `#!/usr/bin/env bash` em todos os scripts
- `stat` com fallback macOS/Linux: `stat -f %m ... 2>/dev/null || stat -c %Y ...`
- `date` com fallback: `date -d ... 2>/dev/null || date -j -f ... +%s 2>/dev/null`

---

## Padrões de smart-memory (Obsidian)

- Frontmatter YAML obrigatório: `title`, `tags` (array), `updated` (YYYY-MM-DD)
- Wikilinks para arquivos relacionados: `[[../decisions/ADR-N]]`, `[[conventions]]`
- Tags seguem padrão kebab-case: `[tech-stack]`, `[research]`, `[conventions]`
- Research reports: `docs/smart-memory/agents/research/{tema}.md`
- ADRs: `docs/smart-memory/decisions/ADR-{N}.md`

---

## Autoridades exclusivas (não delegáveis)

| Autoridade | Agente |
|---|---|
| git push, gh pr create/merge | dev-devops / sites-devops |
| Veredictos de QA (PASS/CONCERNS/FAIL) | dev-qa / sites-qa |
| Criar stories no backlog | dev-architect / sites-architect / traffic-strategist |
| Validação editorial antes de publicar | social-strategist (VERA) |
| Publicação via Meta API | social-publisher (PULSE) |
| Métricas oficiais (ROAS, LTV, CPA) | traffic-bi |
| Veredictos de campanha (PASS/FAIL) | traffic-qa |

## Relacionado

- [[tech-stack]] — dependências e ferramentas
- [[overview]] — visão geral do projeto
