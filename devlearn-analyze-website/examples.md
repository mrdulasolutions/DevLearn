# Analyze website — examples

## Example invoke

```
/devlearn-analyze-website

https://stripe.com — teach me how the hero section is built. Learn only, no rebuild yet.
```

## Overview (Phase 2 sample)

**URL:** `https://example.com` (fictional teaching landing)

**Purpose:** Product landing — convert visitors with hero + feature grid + CTA.

**Regions:**

```text
┌─────────────────────────────────────┐
│ header: logo    nav links    [CTA]  │
├─────────────────────────────────────┤
│ hero: h1 + subtitle + primary btn   │
├─────────────────────────────────────┤
│ section: 3-column feature cards     │
├─────────────────────────────────────┤
│ footer: links + copyright           │
└─────────────────────────────────────┘
```

**Tech signals:** Single CSS file, no framework, vanilla JS for mobile nav toggle.

## Lesson block after Phase 4 (viber, curious)

**What:** The feature cards sit in a CSS Grid with three equal columns on desktop.

**Why:** Grid lets each card share the same width without calculating percentages manually.

**How:** `main .features { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }` — breakpoint at ~768px stacks to one column.

**Term:** **CSS Grid** — a two-dimensional layout system (rows and columns together).

**Try it:** Resize the browser below 768px and watch the cards stack.

## Decision block (seasoned)

**Decision:** Rebuild this landing as static HTML + one CSS file instead of React.

**Alternatives:** React components (overkill for static marketing); Webflow export (harder to learn from).

**Risk & verify:** Static is fine until you need CMS or A/B tests — then revisit stack.

## SPA limitation note (teach moment)

**What:** Fetching the HTML returned an almost empty `<div id="root"></div>`.

**Why:** React renders content in the browser after JavaScript loads — raw HTML fetch does not show the final page.

**How:** Re-run analysis with browser tools or DevTools Elements panel after load.

**Term:** **client-side rendering (CSR)** — HTML shell first, content painted by JS.

## Rebuild roadmap (curious depth)

1. Create `index.html` with `header`, `main` (hero + `.features`), `footer`
2. Add `styles.css` — reset, typography, `max-width: 72rem` centered column
3. Hero: flex column, centered text, primary button styles
4. Features: `display: grid; grid-template-columns: repeat(3, 1fr)` + mobile `@media`
5. `script.js` — toggle `.nav-open` on hamburger click for mobile nav

**Next skill:** `/devlearn-html-css` — step 1–4; `/devlearn-javascript` — step 5.
