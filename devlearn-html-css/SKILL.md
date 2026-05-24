---
name: devlearn-html-css
description: |
  Teaches HTML structure and CSS layout while building real pages for vibe coders.
  Covers semantic tags, accessibility basics, flex/grid, and responsive patterns.
  Use when the user wants a webpage, layout help, styling, or curriculum routes here.
  Proactively suggest when creating or editing .html/.css and DEVLEARN.md is enabled.
---

# DevLearn: HTML & CSS

## Iron law

**Teach without blocking ship.** Build the page the user asked for; teach structure and styling as you go.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Emit lesson blocks from [../shared/lesson-block.md](../shared/lesson-block.md) after each phase.

## Context

HTML is **meaning** (what things are). CSS is **presentation** (how they look). Vibe coders often start with div soup — your job is to ship something pretty enough while teaching why semantic tags and simple layout primitives matter.

## Prerequisites

- None for a blank page
- From router: often first skill before javascript

## Before you start

1. DEVLEARN.md depth (default **curious** for new pages)
2. Step 0: existing pages, design system, framework (React, etc.)?
3. Prefer semantic HTML before framework abstractions when teaching

## Phase 1: Document skeleton

**Build:** `<!DOCTYPE html>`, `html`, `head`, `body`, charset, viewport, title.

**Teach:**

| Element | Why |
|---------|-----|
| `viewport` meta | Mobile doesn't shrink desktop page into postage stamp |
| `title` | Tab label + SEO/bookmarks |

**Term:** **semantic HTML** — tags that describe meaning (`header`, `main`, not only `div`)

**Output:** Valid minimal page that opens in browser.

## Phase 2: Content structure

**Build:** One `main` region with real content (headings, lists, forms as needed).

**Prefer:**

```html
<header>...</header>
<main>
  <h1>...</h1>
  <section aria-labelledby="...">
```

**Avoid:** Nested divs with no landmarks when teaching.

**Smells:**

| Smell | Teach |
|-------|-------|
| Everything is `<div>` | Use `header`, `main`, `section`, `button` |
| Clickable div | Use `<button>` or `<a href>` |
| Missing `label` on input | Accessibility + bigger click target |

**Terms:** **landmark**, **heading hierarchy** (`h1` once per page)

## Phase 3: Layout with CSS

**Build:** Layout that matches user request (centered card, todo list, nav bar).

**Default stack for teaching:**

1. **Box model** — padding vs margin (one diagram in words)
2. **Flexbox** — one-dimensional rows/columns (`display: flex`, `gap`)
3. **Grid** — two-dimensional when needed (`grid-template-columns`)

**Teach tradeoff:** flex for toolbars/lists; grid for page regions.

**Terms:** **flexbox**, **gap**, **margin collapse** (if margin bugs appear)

See [examples.md](examples.md) for annotated snippets.

## Phase 4: Visual polish ( proportional to request )

**Build:** Typography, color, spacing, borders, focus states.

**Teach:**

- **Contrast** — text readable on background
- **`:focus-visible`** — keyboard users see where they are
- Relative units (`rem`) for scalable text

Don't redesign entire app unless asked — **scope to requested polish**.

## Phase 5: Responsive basics

**Build:** At least one breakpoint or fluid layout so mobile works.

**Teach:**

```css
@media (max-width: 640px) { ... }
```

Or fluid `max-width` + `%` widths without breakpoint if sufficient.

**Term:** **responsive** — layout adapts to screen width

## Domain glossary

| Term | Definition |
|------|------------|
| HTML | Structure and meaning of content |
| CSS | Visual style and layout rules |
| selector | Pattern picking elements to style |
| class | Reusable hook for CSS (`.todo-item`) |
| flexbox | Row/column layout for children |
| grid | 2D layout for rows and columns |
| rem | Font-relative size unit |
| semantic tag | Element whose name describes role |
| accessibility | Usable by keyboard/screen readers |

## Common mistakes

| Mistake | Symptom | Fix |
|---------|---------|-----|
| No viewport meta | Tiny text on phone | Add viewport meta |
| Fixed heights on text | Clipped content | min-height, auto |
| Only px everywhere | Zoom/access issues | rem for type |
| Div button | No keyboard activate | `<button>` |
| Global `*` hacks | Specificity wars | Target classes |

## Mini project checkpoint (STOP)

After todo **page structure** (before JS):

Ask one question:

> "Can you point to where the list lives in the HTML — `main`, `ul`, or something else?"

If no, open file and point — don't lecture. Then proceed to javascript skill when ready.

## Lesson integration

One lesson block per phase (vibe: merge phases 2–3 into one lesson).

Always include file:line for HTML structure and CSS layout rule.

## Lifecycle handoffs

| Situation | Suggest |
|-----------|---------|
| Static site ready | `/devlearn-javascript` for interactivity |
| Deploy static page | `/devlearn-deploy` after git |
| Large redesign | `/devlearn-before-you-ship` first |

## Required footer

```markdown
---
DevLearn status: DONE
Phases completed: [1-5 subset]
Suggested next: /devlearn-javascript | /devlearn-explain-diff
---
```

## Additional resources

- Annotated examples → [examples.md](examples.md)
- MDN links → [reference.md](reference.md)
