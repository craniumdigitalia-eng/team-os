---
title: Mapa de Módulos
type: overview
agent: dev-architect
created: 2026-05-19
updated: 2026-05-19
tags: [architecture, modules]
related: ["[[architecture]]", "[[overview]]"]
---

# Mapa de Módulos

## God Nodes

Arquivos com papel central no sistema — mudança aqui tem impacto amplo em toda a squad. **QA obrigatório sempre que uma story tocar estes arquivos.**

| Arquivo | Papel | Impacto |
|---|---|---|
| `.claude/skills/team-os/SKILL.md` | Orquestrador principal (team lead) — define todos os fluxos, comandos e protocolo Agent Teams | Todo time depende desta skill. Alteração quebra orquestração de todas as squads. |
| `.claude/skills/team-os/reference/teammate-contract.md` | Contrato universal injetado em todos os agentes via `*enroll` | Regula coordenação de todos os 37 agentes. Alteração deve ser propagada em todos os `.claude/agents/*.md`. |
| `.claude/skills/team-os-creator/SKILL.md` | Factory de agentes — gera, valida e propaga agentes para projetos do CT | Controla criação de toda nova squad. Alteração afeta todos os flows de install/propagate. |
| `.claude/skills/team-os-creator/scripts/install-to-project.sh` | Script de instalação de agentes e skills em projetos destino | Único caminho de propagação — bugs aqui corrompem projetos destino silenciosamente. |
| `.claude/skills/team-os/scripts/detect-state.sh` | Detecta estado do projeto (NEW/NO_DISCOVERY/IN_PROGRESS/READY) e roteia o fluxo principal | Lógica de entrada do `/team-os`. Erro aqui impede bootstrap e discovery. |

---

## Clusters de Módulos

Grupos que trabalham juntos por responsabilidade funcional:

### Cluster: Orquestração (team-os)
**Núcleo do sistema.**

```
team-os/SKILL.md
  → team-os/scripts/preflight.sh
  → team-os/scripts/detect-state.sh
  → team-os/scripts/list-teammates.sh
  → team-os/scripts/audit-smart-memory.sh
  → team-os/scripts/audit-teammate-compliance.sh
  → team-os/reference/teammate-contract.md
  → team-os/reference/team-activation.md
  → team-os/reference/obsidian-patterns.md
  → team-os/templates/ (INDEX, shared-context, BACKLOG, story, delegation-log, teams-log, overview)
```

**Responsabilidade:** Orquestrar toda a execução de Agent Teams — detectar estado, formar times, despachar tasks, monitorar progresso, auditar smart-memory.

### Cluster: Factory de Agentes (team-os-creator)
**Criação e propagação de squads.**

```
team-os-creator/SKILL.md
  → team-os-creator/scripts/detect-project-signals.sh
  → team-os-creator/scripts/generate-agent.sh
  → team-os-creator/scripts/validate-agent.sh
  → team-os-creator/scripts/scan-ct-projects.sh
  → team-os-creator/scripts/diff-agents.sh
  → team-os-creator/scripts/install-to-project.sh
  → team-os-creator/scripts/install-suggested-skills.sh
  → team-os-creator/scripts/search-skills.sh
  → team-os-creator/scripts/preflight.sh
  → team-os-creator/presets/ (dev, sites, social, traffic, content, data, marketing)
  → team-os-creator/templates/ (architect, implementer, reviewer, researcher, data, devops, ux, hardening, orchestrator)
  → team-os-creator/reference/archetypes.md
  → team-os-creator/reference/skills-catalog-quality.md
  → team-os-creator/reference/smart-memory-integration.md
```

**Responsabilidade:** Gerar agentes nativos Claude Code, instalar skills, validar compliance, propagar squads para projetos do Centro de Treinamento.

### Cluster: Squad Dev (10 agentes)
**Desenvolvimento de software fullstack.**

```
dev-analyst    (researcher, cyan)    — pesquisa técnica, comparação de libs
dev-architect  (architect, purple)   — arquitetura, ADRs, stories (exclusivo)
dev-ux         (ux, pink)            — componentes, a11y, specs de UI
dev-dev-alpha  (implementer)         — implementação frontend/backend
dev-dev-beta   (implementer)         — implementação frontend/backend
dev-dev-gamma  (implementer)         — implementação frontend/backend
dev-dev-delta  (implementer)         — implementação + hardening
dev-qa         (reviewer, red)       — veredictos formais PASS/FAIL (exclusivo)
dev-devops     (devops, green)       — git push, PRs, CI/CD (exclusivo)
dev-data-engineer (data)             — schema, migrations, queries
```

### Cluster: Squad Sites (10 agentes)
**Desenvolvimento de sites e landing pages.**

```
sites-analyst      — pesquisa, SEO, análise de mercado
sites-architect    — arquitetura de páginas, stories (exclusivo)
sites-ux           — UX, interação, acessibilidade
sites-dev-alpha/beta/gamma/delta — implementação Next.js/frontend
sites-qa           — veredictos de qualidade
sites-devops       — deploy, push, CI
sites-data         — dados de analytics, schema
```

### Cluster: Squad Social (7 agentes)
**Produção e publicação de conteúdo para redes sociais.**

```
social-strategist  (VERA, red)      — validação editorial (obrigatória antes de publicar)
social-analyst     — métricas, performance de conteúdo
social-content     — criação de textos e legendas
social-design      — design de posts, carrosséis
social-photo       — direção e seleção de imagens
social-video       — edição e scriptwriting de vídeo
social-publisher   — publicação final (exclusivo)
```

### Cluster: Squad Traffic (10 agentes)
**Tráfego pago cross-platform (Google, Meta, TikTok).**

```
traffic-strategist  (purple)   — planejamento de campanhas, budget, KPIs (stories exclusivo)
traffic-analyst     — análise de performance, atribuição
traffic-bi          — métricas oficiais, dashboards (exclusivo)
traffic-copywriter  — copy de anúncios
traffic-designer    — criativos visuais para ads
traffic-google      — campanhas Google Ads
traffic-meta        — campanhas Meta Ads
traffic-tiktok      — campanhas TikTok Ads
traffic-qa          — veredictos de campanha (exclusivo)
traffic-automation  — integrações API, automações (exclusivo)
```

### Cluster: Smart Memory
**Fonte de verdade compartilhada entre todos os agentes.**

```
docs/smart-memory/
  INDEX.md                        — MOC raiz (atualizado por todos os agentes)
  shared-context.md               — status board em tempo real
  project/
    overview.md                   — objetivo e contexto do projeto
    modules.md                    — este arquivo
    architecture.md               — padrão arquitetural
    tech-stack.md                 — stack (responsabilidade dev-analyst)
    conventions.md                — convenções (responsabilidade dev-analyst)
    squads/                       — specs por squad
  stories/
    BACKLOG.md                    — índice de stories
    backlog/                      — stories pendentes
    active/                       — em desenvolvimento
    done/                         — concluídas
  decisions/                      — ADRs numerados
  ops/
    delegation-log.md             — histórico de delegações
    teams-log.md                  — times formados
  agents/
    data-engineer/schema.md
    qa/results.md
    ux/components.md
    research/
```

### Cluster: Hooks de Enforcement
**Guardrails executados automaticamente pelo Claude Code.**

```
.claude/hooks/
  block-git-push.sh       — PreToolUse: bloqueia git push em agentes dev-dev-*
  check-story-progress.sh — SubagentStop: alerta se story ficou > 2h sem conclusão
  check-social-progress.sh — monitoramento do fluxo social
```

### Cluster: Skills por Domínio
**Skills especializadas instaladas por squad.**

```
dev skills (11):
  dev-api-design, dev-database-patterns, dev-defuddle,
  dev-error-handling, dev-git-workflow, dev-security-patterns,
  dev-technical-writing, dev-testing-strategy, dev-typescript-patterns,
  deep-research, accessibility

sites skills (14):
  sites-canvas-design, sites-content-strategy, sites-copy-editing,
  sites-copywriting, sites-deployment, sites-frontend-design,
  sites-page-cro, sites-scroll-motion, sites-seo-keywords,
  sites-seo-technical, sites-shadcn-ui, sites-tailwind-design-system,
  sites-ux-interaction, sites-web-accessibility

social skills (11):
  social-analytics, social-apify-research, social-carousel-design,
  social-cinematic-composition, social-copywriting, social-editorial-validation,
  social-format-specs, social-freepik-generation, social-key-visual,
  social-meta-publishing, social-scriptwriting, social-stitch-workflow,
  social-video-editing

traffic skills (2):
  tiktok-marketing, (+ social skills compartilhadas)

cross-squad (3):
  team-os, team-os-creator, ui-ux-pro-max, web-design-guidelines
```

---

## Estrutura de Diretórios

```
CT Agentes/
├── .claude/
│   ├── agents/                   — 37 agentes nativos (4 squads)
│   │   ├── dev-*    (10)
│   │   ├── sites-*  (10)
│   │   ├── social-*  (7)
│   │   └── traffic-* (10)
│   ├── hooks/                    — 3 hooks de enforcement
│   ├── skills/                   — 42 skills instaladas
│   │   ├── team-os/              — orquestrador (god node)
│   │   ├── team-os-creator/      — factory de agentes (god node)
│   │   ├── dev-*/                — skills do domínio dev
│   │   ├── sites-*/              — skills do domínio sites
│   │   ├── social-*/             — skills do domínio social
│   │   └── [cross-squad skills]
│   ├── agent-memory/             — memória privada por agente
│   └── settings.json             — CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
├── docs/
│   ├── smart-memory/             — fonte de verdade compartilhada
│   └── CT AGENTES/               — vault Obsidian (espelho/complementar)
├── scripts/
│   └── propagate-graphify.py     — propagação de knowledge graph para projetos do CT
├── skills-lock.json              — hash de skills externas instaladas (deep-research, tiktok-marketing)
└── README.md
```
