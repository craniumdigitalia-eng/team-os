---
title: Tech Stack
tags: [tech-stack, dependencies]
updated: 2026-05-19
---

# Tech Stack

Este projeto não tem linguagem de programação convencional. É um pacote de configuração para Claude Code com Agent Teams — composto por Markdown, Shell e JSON.

## Camadas

| Camada | Tecnologia | Versão | Notas |
|---|---|---|---|
| Plataforma | Claude Code | latest | Requisito base; Agent Teams experimental |
| Orquestração | Agent Teams nativo | — | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` |
| Modelo de agente | Claude Sonnet | sonnet | Padrão; alguns agentes podem usar opus |
| Conteúdo | Markdown (.md) | — | Agentes, skills, smart-memory |
| Automação | Bash (.sh) | — | Hooks e scripts internos do team-os-creator |
| Configuração | JSON | — | settings.json, settings.local.json, skills-lock.json |
| Knowledge Graph | Graphify | — | `uv tool install graphifyy`; transiente, não persistido |
| CLI de web scraping | Defuddle | 1.x | `npx @kepano/defuddle-cli` ou global; usado pelo Analyst/UX |

## MCPs externos (dependências de agentes específicos)

| MCP | Agente consumidor | Finalidade |
|---|---|---|
| `mcp__freepik__*` | social-photo (IRIS) | Geração e upscale de fotos AI via Freepik |
| `mcp__stitch__*` | social-design (AEON) | Key Visuals e carousels via Google Stitch |
| `mcp__magic__*` | social-design (AEON) | Componentes e logos via Magic/21st |
| Apify MCP | social-content (LYRIS) | Research de tendências (Instagram, TikTok, hashtags) |
| Meta API MCP | social-publisher (PULSE) | Publicação em Instagram e Facebook |

## Skills externas (via skills-lock.json)

| Skill | Fonte GitHub | Propósito |
|---|---|---|
| `deep-research` | `199-biotechnologies/claude-deep-research-skill` | Research aprofundado |
| `tiktok-marketing` | `claude-office-skills/skills` | Marketing no TikTok |

## Ferramentas de instalação

- `/team-os-creator *install` — copia agentes/skills/hooks para projeto destino
- `/team-os *bootstrap` — init + discovery em projetos novos
- `uv tool install graphifyy` — instala Graphify (opcional, para knowledge graph via AST)

## Relacionado

- [[conventions]] — padrões de nomenclatura e estrutura
- [[overview]] — visão geral do projeto
