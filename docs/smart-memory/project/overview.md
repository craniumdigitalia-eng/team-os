---
title: Overview
tags: [overview, project]
updated: 2026-05-19
---

# CT Agentes — Overview

## Objetivo

Centro de Treinamento de Agentes Claude Code. Repositório-fonte de todas as squads de agentes nativos (Agent Teams) do ecossistema. Mantém agentes atualizados e os propaga para projetos destino (Dev, Site, Social Media, Tráfego pago, Designer de anuncios).

## Stack principal

Markdown + Shell + JSON — sem linguagem de programação convencional. Orquestrado por Agent Teams nativo do Claude Code (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`).

## Padrão arquitetural

**Hub-and-Spoke com memória compartilhada centralizada.**
- **Hub:** skill `/team-os` na main session (orquestrador)
- **Spokes:** 37 agentes especializados em 4 squads
- **Memória:** `docs/smart-memory/` no padrão Obsidian

## Squads

| Squad | Agentes | Foco |
|---|---|---|
| `dev` | 10 | Software fullstack (analyst, architect, ux, 4 devs, qa, devops, data) |
| `sites` | 10 | Projetos web/landing pages (mesma composição com foco sites) |
| `social` | 7 | Criação de conteúdo social (design, foto, vídeo, copy, publicação) |
| `traffic` | 10 | Tráfego pago Google/Meta/TikTok (estratégia, criativos, gestão) |

## Módulos principais

- [[modules]] — God Nodes e clusters de dependência
- [[architecture]] — Fluxo Hub-and-Spoke, camadas e sequência de orquestração
- [[tech-stack]] — Plataforma, MCPs externos, skills externas
- [[conventions]] — Nomenclatura, frontmatter obrigatório, padrões de script

## God Nodes (arquivos críticos)

| Arquivo | Por quê é crítico |
|---|---|
| `.claude/skills/team-os/SKILL.md` | Orquestrador de toda a squad — quebra tudo se alterado incorretamente |
| `.claude/skills/team-os/reference/teammate-contract.md` | Contrato de todos os 37 agentes — propagação manual obrigatória |
| `.claude/skills/team-os-creator/SKILL.md` | Factory de agentes — controla criação e propagação de squads |
| `.claude/skills/team-os-creator/scripts/install-to-project.sh` | Único caminho de propagação — bugs aqui corrompem projetos destino |
| `.claude/skills/team-os/scripts/detect-state.sh` | Entrada do `/team-os` — erro aqui bloqueia todo o bootstrap |

## Projetos destino (CT)

| Projeto | Squads instaladas |
|---|---|
| Dev | dev |
| Site | sites |
| Social Media | social |
| Tráfego pago | traffic |
| Designer de anuncios | social (design/foto/vídeo) + traffic (designer/copywriter) + sites-ux |

## Links

- [[tech-stack]] — stack (fonte: dev-analyst)
- [[architecture]] — padrão arquitetural (fonte: dev-architect)
- [[modules]] — mapa de módulos e God Nodes (fonte: dev-architect)
- [[conventions]] — convenções de nomenclatura e scripts (fonte: dev-analyst)
- [[../stories/BACKLOG]] — backlog
