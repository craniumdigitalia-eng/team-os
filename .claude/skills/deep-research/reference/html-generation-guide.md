# HTML Generation: McKinsey Style Report

## Design Principles

- Sharp corners (NO border-radius)
- Muted corporate colors (navy #003d5c, gray #f8f9fa)
- Ultra-compact layout
- Info-first structure
- 14px base font, compact spacing
- No decorative gradients or colors
- NO EMOJIS in final HTML

---

## Generation Steps

### Step 1: Read McKinsey Template
Load template from: `./templates/mckinsey_report_template.html`

### Step 2: Extract Key Metrics
Extract 3-4 key quantitative findings for dashboard display at top.

### Step 3: Convert MD to HTML

Use Python script:
```bash
python3 "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/deep-research/scripts/md_to_html.py" [markdown_report_path]
```

**Script outputs two parts:**
- **Part A ({{CONTENT}}):** All sections except Bibliography
- **Part B ({{BIBLIOGRAPHY}}):** Bibliography section only

**Script handles all conversion:**
- Headers: `##` -> `<div class="section"><h2 class="section-title">`
- Headers: `###` -> `<h3 class="subsection-title">`
- Lists: Markdown bullets -> `<ul><li>` with nesting
- Tables: Markdown tables -> `<table>` with thead/tbody
- Paragraphs: Text wrapped in `<p>` tags
- Bold/italic: `**text**` -> `<strong>`, `*text*` -> `<em>`
- Citations: [N] preserved for tooltip conversion

### Step 4: Add Citation Tooltips (Optional)

Attribution Gradients - wrap each [N] citation:
```html
<span class="citation">[N]
  <span class="citation-tooltip">
    <div class="tooltip-title">[Source Title]</div>
    <div class="tooltip-source">[Author/Publisher]</div>
    <div class="tooltip-claim">
      <div class="tooltip-claim-label">Supports Claim:</div>
      [Extract sentence with this citation]
    </div>
  </span>
</span>
```
NOTE: This step is optional for speed. Basic [N] citations are sufficient.

### Step 5: Replace Template Placeholders

| Placeholder | Content |
|-------------|---------|
| {{TITLE}} | Report title (from first ## heading) |
| {{DATE}} | Generation date (YYYY-MM-DD) |
| {{SOURCE_COUNT}} | Number of unique sources |
| {{METRICS_DASHBOARD}} | Metrics HTML from step 2 |
| {{CONTENT}} | HTML from Part A |
| {{BIBLIOGRAPHY}} | HTML from Part B |

### Step 6: Verify HTML

```bash
python3 "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/deep-research/scripts/verify_html.py" --html [html_path] --md [md_path]
```
- Pass: proceed
- Fail: fix errors and re-run

### Step 7: Tell the user where it is
Report the HTML path to the user. Do not auto-open files.

---

## PDF Generation (optional)

**Option A (preferred): headless browser via `sales-deck-production`**

If the `sales-deck-production` skill is installed in the project, reuse its exporter (Playwright or Puppeteer, whichever is installed; waits for fonts and images; exits non-zero if a font or image fails to load):

```bash
# once, in the project: npm i -D playwright && npx playwright install chromium   (or: npm i -D puppeteer)
node "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}/.claude/skills/sales-deck-production/scripts/html-to-pdf.mjs" \
  [html_path] [pdf_path] [--format A4|Letter] [--landscape]
```

Print CSS still matters: `page-break-inside: avoid` on tables and boxes, `page-break-after: avoid` on headings, `orphans: 3; widows: 3` on paragraphs.

**Option B (alternative): WeasyPrint**

Only if `command -v weasyprint` exists (it is not a dependency of this skill). Follow `./reference/weasyprint_guidelines.md` (use `display: table` instead of Flexbox/Grid, sizes in pt), then:

```bash
weasyprint [html_path] [pdf_path]
```

**Neither available:** deliver Markdown + HTML only and say so in the final message.

In every case, report the PDF path to the user — do not auto-open it.
