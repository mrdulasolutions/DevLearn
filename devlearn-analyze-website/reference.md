# Analyze website — reference

## Intake prompt (copy-paste)

> Analyze https://example.com and teach me how the page was built. Start with layout overview, then HTML structure, CSS layout, and any JavaScript behavior. Depth: curious. Don't copy their text — use placeholders if we rebuild.

## Scope variants

| User says | Scope |
|-----------|--------|
| "just explain" | Phases 1–6, no code in repo |
| "help me rebuild it" | Full workflow + simplified clone |
| "only the hero" | Phase 2–4 on one section |
| "what framework" | Phase 1 gather + Phase 6, short answer |

## Gather checklist

1. **Fetch or open** URL; record final URL after redirects
2. **Document title** and meta description (if present)
3. **Landmarks** — `header`, `nav`, `main`, `footer`, `section`, `article`
4. **Repeated patterns** — cards, list items, grid cells
5. **CSS sources** — `<link rel="stylesheet">`, `<style>`, inline styles on key nodes
6. **Layout probes** — on hero or main container: `display`, `flex-direction`, `grid-template`, `gap`, `max-width`
7. **Breakpoints** — resize or read `@media` rules in stylesheets
8. **Fonts** — `font-family` on `body`, `h1`
9. **Scripts** — count, `type=module`, known bundles (`/_next/`, `react`, `vue`)
10. **Interactions** — menu, tabs, modal, form, scroll effects (click/hover if browser available)

## Tool matrix

| Environment | Recommended approach |
|-------------|---------------------|
| Cursor + browse/MCP | Navigate URL, snapshot DOM, screenshot regions |
| WebFetch only | Parse returned HTML; note "dynamic content may be missing" |
| User provides screenshot | Describe layout visually; ask for DevTools HTML export for structure |
| Localhost / own project | Full DevTools; tie analysis to their repo files |

## Framework detection signals

| Signal | Likely stack |
|--------|--------------|
| `#__next`, `/_next/static/` | Next.js |
| `#root` + `data-reactroot` or `.react-` | React SPA |
| `ng-` attributes, `_ngcontent` | Angular |
| `v-` bindings in HTML | Vue |
| WordPress `wp-content`, `wp-includes` | WordPress theme |
| Utility classes `flex`, `grid`, `text-xl`, `md:` | Tailwind (or similar) |
| No JS, semantic HTML + one CSS file | Static / hand-written |

## Ethics & limits

- Teach **patterns**, not stolen assets (logos, marketing copy, licensed fonts)
- Respect `robots.txt` and rate limits when fetching
- Do not bypass paywalls, CAPTCHAs, or authentication
- For banking, adult, or clearly sensitive sites — confirm user intent

## Rebuild simplification rules

When creating a teaching clone:

| Original | Clone |
|----------|-------|
| Brand logo | Placeholder box or initials |
| Stock photos | `placeholder` color block or unsplash generic if user asks |
| 12-section marketing page | 1 hero + 1 card row + footer |
| Complex animation | Static layout first; optional motion later |

## Output: analysis report skeleton

```markdown
## Site overview
- URL:
- Purpose:
- Regions: [ASCII or bullet list]

## HTML structure
- Landmarks:
- Repeating patterns:

## CSS & layout
- Page width / centering:
- Main layout (flex/grid):
- Mobile changes:

## Typography & color
- Fonts:
- Accent:

## JavaScript
- Behaviors observed:
- Framework (if any):

## How you'd rebuild it
1. ...
2. ...

## Terms learned
| Term | One-line |
|------|----------|
```

## Handoff prompts

**After analysis → HTML/CSS rebuild:**

> Using what we learned, build a simplified version of the hero section in my project. Teach each change with DevLearn blocks.

**After analysis → curriculum:**

> `/devlearn-curriculum-router` — I analyzed a site; what skills should I learn next to build pages like this?
