---
name: seo-audit
description: "Auditoria SEO completa de um site com delegação paralela a subagentes — rastreia até 500 páginas, detecta tipo de negócio, aciona até 14 especialistas e gera health score. Use quando o usuário pedir 'audit', 'auditoria SEO completa', 'analise meu site' ou 'saúde do site'."
version: "2.3.3"
updated: "2026-10-20"
user-invocable: true
argument-hint: "[url]"
license: MIT
metadata:
  author: AgriciDaniel
  version: "2.3.1"
  category: seo
---

# Auditoria SEO completa de site

**Quando usar esta vs. `sites-seo-technical`:** esta roda a auditoria completa de um site publicado (até 500 páginas, vários especialistas, health score). Para implementar SEO técnico no código Next.js/Astro, use `sites-seo-technical`.

## Processo

1. **Renderizar a home**: use `"${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run render_page.py <url> --mode auto --json` para capturar HTML bruto, HTML renderizado, texto extraído, status de SPA e dados de acessibilidade quando necessário
2. **Detectar o tipo de negócio**: analise os sinais da home conforme o orquestrador `seo`
3. **Rastrear o site**: siga links internos até 500 páginas, respeitando o robots.txt
4. **Delegar aos subagentes** (se disponíveis; senão, rode em linha, em sequência):
   - `seo-technical` -- robots.txt, sitemaps, canonicals, Core Web Vitals, headers de segurança
   - `seo-content` -- E-E-A-T, legibilidade, conteúdo raso, prontidão para citação por IA
   - `seo-schema` -- detecção, validação, recomendações de geração
   - `seo-sitemap` -- análise de estrutura, quality gates, páginas faltantes
   - `seo-performance` -- medições de LCP, INP, CLS; screenshots, teste mobile, análise da dobra (render em navegador headless)
   - `seo-geo` -- acesso de crawlers de IA, llms.txt, citabilidade, sinais de menção de marca
   - `seo-local` -- sinais do GBP, consistência de NAP, avaliações, schema local, fatores locais por setor (acione quando detectar negócio local: loja física, SAB ou tipo híbrido)
   - `seo-maps` -- geo-grid de ranking, auditoria do GBP, inteligência de avaliações, raio de concorrentes (acione quando detectar negócio local E o MCP do DataForSEO estiver disponível)
   - `seo-google` -- dados de campo de CWV (CrUX), indexação de URL (GSC), tráfego orgânico (GA4) (acione quando houver credenciais de API do Google, detectadas via `"${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run google_auth.py --check`)
   - `seo-backlinks` -- perfil de backlinks: DA/PA, domínios de referência, âncoras, links tóxicos (acione quando houver credenciais de Moz ou Bing, detectadas via `"${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run backlinks_auth.py --check`; ou inclua sempre as métricas por domínio do Common Crawl)
   - `seo-cluster` -- análise de clusters semânticos (acione quando houver sinais de estratégia de conteúdo: blog, páginas pilar, clusters de tema)
   - `seo-sxo` -- experiência de busca: descasamento de tipo de página, user stories, pontuação por persona (inclua sempre em auditoria completa)
   - `seo-drift` -- análise de drift: compara com a baseline guardada (acione quando existir baseline para a URL, via `"${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run drift_history.py <url>`)
   - `seo-ecommerce` -- schema de produto, inteligência de marketplace (acione quando detectar e-commerce)
5. **Pontuar** -- agregue no SEO Health Score (0-100)
6. **Persistir os artefatos da auditoria** -- grave todas as saídas em `{domain}-audit/`
7. **Relatar** -- gere o plano de ação priorizado e, opcionalmente, o relatório em PDF/HTML

## Configuração do rastreio

```
Max pages: 500
Respect robots.txt: Yes
Follow redirects: Yes (max 3 hops)
Timeout per page: 30 seconds
Concurrent requests: 5
Delay between requests: 1 second
```

## Arquivos de saída

- `{domain}-audit/FULL-AUDIT-REPORT.md`: achados completos
- `{domain}-audit/ACTION-PLAN.md`: recomendações priorizadas (Critical > High > Medium > Low)
- `{domain}-audit/audit-data.json`: envelope estruturado da auditoria para gerar o relatório
- `{domain}-audit/findings/*.md`: achados por especialista (`technical.md`, `content.md`, `schema.md`, `performance.md` etc.)
- `{domain}-audit/screenshots/`: capturas desktop + mobile (se o Playwright estiver disponível)
- **Relatório em PDF** (recomendado): gere um PDF A4 profissional com `"${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run google_report.py --type full --data {domain}-audit/audit-data.json --domain <domain> --output-dir {domain}-audit/`. Ele produz um relatório com capa branca, sumário, resumo executivo, gráficos (medidores do Lighthouse, barras de consultas, rosca de indexação), cartões de métrica, tabelas de limiar, recomendações priorizadas com estimativa de esforço e roadmap de implementação. Sempre ofereça gerar o PDF ao concluir uma auditoria.

## Envelope estruturado da auditoria

Grave `{domain}-audit/audit-data.json` com este formato, para que `"${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run google_report.py --type full --data {domain}-audit/audit-data.json --domain <domain> --output-dir {domain}-audit/` consiga gerar o relatório mesmo sem dados da API do Google (mantenha as chaves e os valores de `severity` exatamente como abaixo):

```json
{
  "summary": {
    "health_score": 0,
    "business_type": "detected type",
    "top_findings": [],
    "quick_wins": []
  },
  "categories": [
    {
      "name": "Technical SEO",
      "score": 0,
      "what_works": [],
      "findings": [
        {
          "title": "Finding title",
          "severity": "Critical|High|Medium|Low|Info",
          "description": "Evidence-backed detail",
          "recommendation": "Specific fix"
        }
      ]
    }
  ],
  "action_plan": {
    "phases": [
      {"name": "Phase 1: Critical Fixes", "timeframe": "Week 1", "items": []},
      {"name": "Phase 2: High-Impact Improvements", "timeframe": "Weeks 2-3", "items": []},
      {"name": "Phase 3: Content & Authority", "timeframe": "Month 2", "items": []},
      {"name": "Phase 4: Monitoring & Iteration", "timeframe": "Ongoing", "items": []}
    ]
  },
  "artifacts": {
    "findings_dir": "findings/",
    "screenshots_dir": "screenshots/"
  }
}
```

## Pesos da pontuação

| Categoria | Peso |
|----------|--------|
| SEO técnico (Technical SEO) | 22% |
| Qualidade de conteúdo (Content Quality) | 23% |
| SEO on-page (On-Page SEO) | 20% |
| Schema / dados estruturados | 10% |
| Performance (CWV) | 10% |
| Prontidão para busca por IA (AI Search Readiness) | 10% |
| Imagens | 5% |

## Estrutura do relatório

### Resumo executivo
- SEO Health Score geral (0-100)
- Tipo de negócio detectado
- Top 5 problemas críticos
- Top 5 ganhos rápidos

### SEO técnico
- Problemas de rastreabilidade
- Problemas de indexabilidade
- Questões de segurança
- Status dos Core Web Vitals

### Qualidade de conteúdo
- Avaliação de E-E-A-T
- Páginas com conteúdo raso
- Conteúdo duplicado
- Notas de legibilidade

### SEO on-page
- Problemas de title tag
- Problemas de meta description
- Estrutura de títulos
- Lacunas de link interno

### Schema e dados estruturados
- Implementação atual
- Erros de validação
- Oportunidades faltantes

### Performance
- Notas de LCP, INP, CLS
- Necessidades de otimização de recursos
- Impacto de scripts de terceiros

### Imagens
- Alt text ausente
- Imagens pesadas demais
- Recomendações de formato

### Prontidão para busca por IA
- Pontuação de citabilidade
- Melhorias estruturais
- Sinais de autoridade

## Definição de prioridades

- **Critical**: bloqueia indexação ou causa penalidade (corrigir imediatamente)
- **High**: impacta o ranking de forma significativa (corrigir em até 1 semana)
- **Medium**: oportunidade de otimização (corrigir em até 1 mês)
- **Low**: desejável (backlog)

## Integração com DataForSEO (opcional)

Se as ferramentas MCP do DataForSEO estiverem disponíveis, acione o agente `seo-dataforseo` junto com os demais subagentes para enriquecer a auditoria com dados ao vivo: posições reais na SERP, perfis de backlinks com spam score, análise on-page (Lighthouse), listagens de negócio e checagens de visibilidade em IA (ChatGPT scraper, menções em LLMs).

## Integração com a API do Google (opcional)

Se houver credenciais de API do Google configuradas (`"${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/seo/scripts/claude-seo" run google_auth.py --check`), acione o agente `seo-google` para enriquecer a auditoria com dados de campo reais do Google: Core Web Vitals do CrUX (substituem estimativas só de laboratório), status de indexação de URL no GSC, desempenho de busca (cliques, impressões, CTR) e tendência de tráfego orgânico no GA4. A nota da categoria Performance (CWV) é a que mais se beneficia de dado de campo.

## Tratamento de erros

| Cenário | Ação |
|----------|--------|
| URL inacessível (falha de DNS, conexão recusada) | Relate o erro com clareza. Não adivinhe o conteúdo do site. Sugira ao usuário conferir a URL e tentar de novo. |
| robots.txt bloqueia o rastreio | Relate quais caminhos estão bloqueados. Analise só as páginas acessíveis e registre a limitação no relatório. |
| Limite de taxa (respostas 429) | Recue e reduza as requisições simultâneas. Relate resultados parciais, indicando quais seções não puderam ser concluídas. |
| Timeout em site grande (500+ páginas) | Limite o rastreio ao teto de tempo. Relate os achados das páginas rastreadas e estime o tamanho total do site. |
| Subagente atinge o orçamento de `maxTurns` num site grande | Os achados não se perdem: todo subagente de auditoria grava um `output_dir/findings/*.md` parcial após a primeira passada de análise e o sobrescreve com os achados completos antes de terminar. Leia o arquivo de achados que existir e incorpore ao relatório, indicando que pode estar parcial. |
