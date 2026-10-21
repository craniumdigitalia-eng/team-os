# Avisos de terceiros (Third-Party Notices)

O pack **team-os** é distribuído sob a licença MIT (ver [LICENSE](./LICENSE), © 2026 João Guirunas).
Algumas skills em `.claude/skills/` foram importadas de projetos de terceiros e adaptadas
(tradução da descrição, frontmatter padronizado, ajustes de caminhos). Os direitos autorais e a
licença originais permanecem com os respectivos autores, listados abaixo. Cada skill importada
que tenha `LICENSE.txt` próprio aponta para este arquivo.

Legenda: **Autor** = titular declarado no `metadata.author`/`LICENSE.txt` da skill; **Origem** = URL
declarada em `metadata`, `source:` ou `LICENSE.txt`; quando não há URL nem licença verificável, o
item está marcado para conferência antes de qualquer redistribuição.

## claude-seo (27 skills `seo*`)

| Skill | Autor | Licença | Origem |
|---|---|---|---|
| `seo` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-ahrefs` | AgriciDaniel (extensão do claude-seo) | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-audit` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-backlinks` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-bing` | AgriciDaniel (extensão do claude-seo) | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-cluster` | AgriciDaniel — autoria original: Lutfiya Miller (Pro Hub Challenge) | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-competitor-pages` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-content` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-content-brief` | **puneetindersingh** (titular do copyright, contribuição ao claude-seo) | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-dataforseo` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-drift` | AgriciDaniel — autoria original: Dan Colta (Pro Hub Challenge) | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-ecommerce` | AgriciDaniel — autoria original: Matej Marjanovic (Pro Hub Challenge) | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-flow` | AgriciDaniel — base de prompts FLOW em `references/` sob **CC BY 4.0** (github.com/AgriciDaniel/flow) | MIT (skill) / CC BY 4.0 (prompts) | https://github.com/AgriciDaniel/claude-seo |
| `seo-geo` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-google` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-hreflang` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-image-gen` | AgriciDaniel (baseada em Claude Banana, github.com/AgriciDaniel/banana-claude) | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-images` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-local` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-maps` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-page` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-plan` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-programmatic` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-schema` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-sitemap` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-sxo` | AgriciDaniel — autoria original: Florian Schmitz (Pro Hub Challenge) | MIT | https://github.com/AgriciDaniel/claude-seo |
| `seo-technical` | AgriciDaniel | MIT | https://github.com/AgriciDaniel/claude-seo |

Texto da licença: `MIT License — Copyright (c) 2026 AgriciDaniel` (e `Copyright (c) 2026 puneetindersingh`
para `seo-content-brief`). Os `LICENSE.txt` das skills remetem ao `LICENSE` raiz do repositório de origem;
o texto integral da MIT é o mesmo de [LICENSE](./LICENSE), trocando-se o titular.

## Outras skills importadas

| Skill | Autor | Licença | Origem / observação |
|---|---|---|---|
| `accessibility` | Addy Osmani | MIT — `Copyright (c) 2026 Addy Osmani` (LICENSE conferido em 2026-10-20) | https://github.com/addyosmani/web-quality-skills — adaptada (skill `accessibility`), sincronizada com a v2.0 (commit afa8da9) e reescrita em pt-BR em 2026-10-20; conteúdo baseado em WCAG 2.2 (W3C) e Lighthouse |
| `deep-research` | 199 Biotechnologies | MIT (declarado só no README, "modify as needed"; **repositório sem arquivo LICENSE**) | https://github.com/199-biotechnologies/claude-deep-research-skill — base commit f2f2c0f (v3.0); adaptação CT 3.0.1-ct em 2026-10-20 (pt-BR, caminhos, ledger de afirmações, fontes oficiais BR) |
| `negotiation` | Wondel.ai sp. z o.o. | MIT — `Copyright (c) 2025 Wondel.ai sp. z o.o.` (LICENSE conferido em 2026-10-20) | https://github.com/wondelai/skills (commit 0dea03f; `metadata.author: wondelai`, v1.5.0) — traduzida e adaptada em pt-BR em 2026-10-20 (sem links de afiliado; regras do pack) |
| `presentation-design` | jwynia | MIT | origem não declarada em URL (`metadata.author: jwynia`, v1.0) |
| `sales-deck-production` (references `deck-layout-patterns.md`, `deck-slide-strategies.md`, `deck-navigation.md`) | Next Level Builder | MIT — `Copyright (c) 2024 Next Level Builder` (LICENSE conferido em 2026-10-20) | adaptado da skill `slides` de https://github.com/nextlevelbuilder/ui-ux-pro-max-skill — a `slides` foi consolidada em 2026-10-20 |
| `startup-financial-modeling` | não declarado (corpo menciona adaptação ao "Codex 8 KB skill body cap") | **licença upstream não localizada; verificar antes de redistribuir** | origem não declarada |
| `ui-ux-pro-max` | Next Level Builder | MIT — `Copyright (c) 2024 Next Level Builder` (LICENSE conferido em 2026-09-25; sincronizada com o upstream v2.15.0 em 2026-10-20) | https://github.com/nextlevelbuilder/ui-ux-pro-max-skill — inclui dados derivados de Google Fonts (licenças por família em `data/google-font-licenses.json`) e Phosphor Icons (`data/phosphor-icons-upstream.json`, MIT) |
| `ai-ml-data-science` | não declarado | **licença upstream não localizada; verificar antes de redistribuir** | importada em 2026-06-18 (commit 65743d2) sem metadados de origem; cita `data/sources.json` |
| `ai-ml-timeseries` | não declarado | **licença upstream não localizada; verificar antes de redistribuir** | idem |
| `data-analytics-engineering` | não declarado | **licença upstream não localizada; verificar antes de redistribuir** | idem |
| `data-lake-platform` | não declarado | **licença upstream não localizada; verificar antes de redistribuir** | idem |
| `data-sql-optimization` | não declarado | **licença upstream não localizada; verificar antes de redistribuir** | idem |
| `web-design-guidelines` | João Guirunas (skill); guidelines: Vercel Labs | MIT (skill); guidelines MIT — `Copyright (c) 2025 Vercel Labs` (LICENSE conferido em 2026-10-20) | https://github.com/vercel-labs/web-interface-guidelines — `guidelines-cache.md` **é cópia vendorizada** dessas guidelines, fixada no commit 4ecfb9fb8d1d3b7009674869b3aaee2f904042e1 (2026-10-05) |

## marketingskills (Corey Haines)

Repositório [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills), licença MIT —
`Copyright (c) 2025 Corey Haines` (LICENSE conferido em 2026-10-20, commit 22dcd26).

| Skill | Origem no repositório | Como entrou no pack |
|---|---|---|
| `pricing` | `skills/pricing` (v2.1.4) | importada e traduzida para pt-BR, com correções (Van Westendorp, guardrail de página buscada, skills relacionadas e contexto via smart-memory) |
| `sales-enablement` | `skills/sales-enablement` | importada e adaptada |
| `traffic-paid-ads-optimization` | `skills/ads` (ex-`paid-ads`) | adaptada (método reescrito em pt-BR, expandido) |
| `traffic-analytics-tracking` | `skills/analytics` (ex-`analytics-tracking`) | adaptada (método reescrito em pt-BR, expandido) |

## superpowers (Jesse Vincent)

| Skill | Origem | Licença | Como entrou no pack |
|---|---|---|---|
| `verify-before-done` | [obra/superpowers](https://github.com/obra/superpowers) — `skills/verification-before-completion` | MIT — `Copyright (c) 2025 Jesse Vincent` (LICENSE conferido em 2026-10-20) | adaptada (reescrita em pt-BR no padrão do pack) |

## Métodos adaptados (2026-10)

Conceitos e métodos reescritos em pt-BR no padrão do pack (texto próprio, sem código copiado), com crédito às fontes:

| Onde no pack | Fonte | Licença | Observação |
|---|---|---|---|
| `team-os` — modo `*grill` (Fase 3) | [mattpocock/skills](https://github.com/mattpocock/skills) — `grilling`/`grill-me` | MIT | rodadas de perguntas com resposta recomendada |
| `seo-google/references/rankings-push.md`; `seo-sxo` (Diagnóstico contra o top 3) | [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) — `seo-audit/references/rankings-push.md` | MIT — `Copyright (c) 2025 Corey Haines` | commit e85f3cb |
| `seo-geo` (Medir visibilidade real) | coreyhaines31/marketingskills — `ai-seo` | MIT — `Copyright (c) 2025 Corey Haines` | commit 001fd4e |
| `security-audit-method` (filtro do candidato, três estados, refutação cruzada, ledger de cobertura, classes de ataque) e agentes `security-*` | [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill) | MIT — `Copyright (c) 2025-2026 Cloudflare, Inc.` | commit c1c8a8c1 |
| `social-video-editing` (regras de correção, corte por silêncio, legenda, áudio, autoavaliação) | [browser-use/video-use](https://github.com/browser-use/video-use) | MIT — `Copyright (c) 2026 Browser Use` | commit 43cfc56 |
| `social-video-editing/reference/launch-video.md` | [latent-spaces/brag](https://github.com/latent-spaces/brag) | MIT — `Copyright (c) 2026 Shunit Haviv Hakimi` | commit 069432ca |
| `social-copywriting`, `social-scriptwriting` (+`reference/ganchos.md`), `social-carousel-design`, `social-analytics` (+`reference/perfil-rubrica.md`), `social-apify-research` | [Jakeschincariol/instagram-agent-skill](https://github.com/Jakeschincariol/instagram-agent-skill) | MIT — `Copyright (c) 2026 Jake Schincariol` | commit d03c56b |
| `instagram-strategy`, `instagram-dm-flows` | [Jakeschincariol/instagram-agent-skill](https://github.com/Jakeschincariol/instagram-agent-skill) — `ig-dm`, `ig-reply`, `ig-plan` | MIT — `Copyright (c) 2026 Jake Schincariol` | conceitos adaptados, commit d03c56b |
| `instagram-dm-flows` (opt-in de WhatsApp e templates) | [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) — referência de WhatsApp da skill `sms` | MIT — `Copyright (c) 2025 Corey Haines` | conceitos adaptados |
| `youtube-scriptwriting`, `youtube-packaging`, `youtube-analytics`, `youtube-publishing` | [darkzOGx/youtube-automation-agent](https://github.com/darkzOGx/youtube-automation-agent) | MIT — `Copyright (c) 2025 YouTube Automation Agent Contributors` | commit 24f9cb5 — método, sem código |
| `sites-scroll-motion` §5A (GSAP + ScrollTrigger) | [greensock/gsap-skills](https://github.com/greensock/gsap-skills) | MIT — `Copyright (c) 2026 GreenSock` | padrões useGSAP/context/matchMedia |

## Conteúdo adaptado de agency-agents

Trechos de método foram adaptados (reescritos em PT-BR, no padrão do pack — não copiados) do repositório
[msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents), licença MIT, © 2025 AgentLand Contributors.

| Destino no pack | Origem | O que foi adaptado |
|---|---|---|
| skill `dev-security-patterns` (seção "Varredura de código gerado por IA"); agentes `dev-qa`, `sites-qa`, `dev-data-engineer`, `sites-data` | `security/security-ai-generated-code-auditor.md` | Os cinco erros típicos de código gerado por IA, a lista do que não acusar, "segredo vazado = rotacionar" e "correção só vale com nova varredura" |
| squad `security` — agente `security-architect`, skill `security-threat-modeling` | `security/security-architect.md`, `security/security-appsec-engineer.md` | Modelagem de ameaças com STRIDE por fronteira e saída em requisitos testáveis |
| agente `security-appsec`, skill `security-audit-method` | `security/security-appsec-engineer.md`, `security/security-architect.md` | Áreas de auditoria de aplicação, escala de severidade e "nunca aceitar risco sem dono" |
| agente `security-ai-code` | `security/security-ai-generated-code-auditor.md` | Riscos de apps com LLM (injeção, agência excessiva, saída do modelo confiada) |
| agente `security-secrets` | `security/security-secrets-credential-engineer.md` | Inventário de credenciais, rotação sem derrubar o serviço, nunca expor o valor |
| agente `security-privacy`, skill `security-privacy-data-map` | `engineering/engineering-privacy-engineer.md` | Mapa técnico de dados pessoais, minimização, consentimento aplicado no código, exclusão provada |
| agente `security-incident`, skill `security-incident-response` | `security/security-incident-responder.md` | Classificação SEV, preservação de evidência, linha do tempo em UTC, post-mortem com poucas correções |

Skills não listadas aqui são de autoria de João Guirunas e seguem a licença MIT do repositório.
