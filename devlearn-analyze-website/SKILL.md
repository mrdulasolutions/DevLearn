---
name: devlearn-analyze-website
description: |
  Teaches how a live webpage was built from a URL the user provides. Inspects HTML
  structure, CSS layout, typography, responsiveness, and JavaScript behavior; maps
  patterns to skills (html-css, javascript, react, next). Use when user pastes a link
  and asks how a site works, how it was made, reverse engineer a page, learn from a
  website, or recreate a layout. Voice triggers: "analyze this site", "how was this
  built", "break down this page", "teach me from this URL".
---

# DevLearn: Analyze Website

## Iron law

**Teach from what you can actually inspect.** Gather real evidence from the page first; then explain structure and patterns — never invent markup or styles you did not see.

## Voice + blocks

Follow [../shared/voice.md](../shared/voice.md). Emit lesson blocks from [../shared/lesson-block.md](../shared/lesson-block.md) after each analysis phase. Seasoned users get [../shared/decision-block.md](../shared/decision-block.md) when comparing rebuild approaches (static HTML vs framework vs CMS).

## Context

Users learn fastest when they connect a polished site to concrete building blocks. This skill turns any URL into a guided tour: what the page is for, how regions are laid out, which CSS tricks hold it together, what runs in JavaScript, and how they would rebuild a simplified version themselves.

Pairs with `devlearn-html-css` and `devlearn-javascript` for hands-on rebuilds; `devlearn-react` / `devlearn-next` when framework signals appear.

## Prerequisites

- A **public URL** the user can share (or local `file://` / localhost if they are debugging their own app)
- Optional: browser or fetch tools to load the page (see [reference.md](reference.md))
- `DEVLEARN.md` enabled for persona/depth (defaults: **curious**, **viber** or **autodetect**)

## Before you start

1. Read `DEVLEARN.md`: persona, depth, stack, `topics`
2. Confirm the URL — normalize (`https://`, strip tracking params if user pastes long links)
3. Ask **one** scope question if unclear:
   - **Learn only** — explain how it works, no code in their repo
   - **Rebuild simplified** — create a teaching clone in their project after analysis
   - **One section** — hero, nav, card grid, etc. (not whole marketing site)
4. Note limitations upfront for SPAs, login walls, or bot-blocked sites (see Common mistakes)

## Phase 1: Gather evidence

**Do:**

| Step | Output |
|------|--------|
| Load page | Title, visible above-the-fold description |
| Capture structure | Main landmarks (`header`, `main`, `nav`, `footer`, sections) |
| Styles | Linked CSS, inline critical styles, layout hints (flex/grid classes) |
| Scripts | Script tags, framework hints (React, Next, Vue), analytics only if relevant |
| Viewport | Desktop + mobile if tools allow (stacking, hamburger, font scale) |

**Tools (use what's available):**

| Tool | Use for |
|------|---------|
| Browser / DevTools | DOM tree, computed styles, network, responsive |
| `WebFetch` / HTTP GET | Static HTML when no browser |
| View source | Fallback when fetch is blocked |

Full checklist: [reference.md](reference.md#gather-checklist).

**Teach (viber):** What is a **document object model (DOM)** — the browser's tree of elements you are inspecting.

## Phase 2: Page overview (the "what")

**Build:** A short narrative, not code:

- **Purpose** — landing page, dashboard, article, e-commerce, app shell
- **Layout regions** — sketch in words or ASCII (header / hero / grid / footer)
- **Tech signals** — static HTML, Tailwind utility classes, React root `#__next`, etc.

**Output template:** see [examples.md](examples.md#overview).

**Term:** **information architecture** — how content is grouped and prioritized on the page.

## Phase 3: HTML structure

**Build:** Annotated outline of major elements (not every div):

```text
header → logo + nav (ul > li > a)
main → hero (h1, p, cta button)
section.cards → repeating article/card pattern
footer → links + copyright
```

**Teach:**

| Pattern | Why it matters |
|---------|----------------|
| Semantic tags | Screen readers + clearer CSS hooks |
| Repeated card markup | Component pattern (even in plain HTML) |
| `button` vs `div` click | Accessibility + keyboard |

**Handoff:** rebuilding markup → `/devlearn-html-css`

## Phase 4: CSS & layout

**Build:** Explain how the visible layout is achieved:

| Inspect | Teach |
|---------|-------|
| `display: flex` / `grid` | Axis, gap, alignment |
| Max-width + margin auto | Centered content column |
| Media queries | Breakpoints / mobile-first |
| Spacing rhythm | Consistent padding scale (8px, rem) |
| Utility classes (e.g. Tailwind) | Speed vs custom CSS tradeoff |

**Seasoned:** Decision block — utility-first CSS vs component CSS modules vs CSS-in-JS for this page type.

**Terms:** **flexbox**, **grid**, **breakpoint**, **specificity** (only if user hits override bugs)

## Phase 5: Typography & color

**Build:**

- Font families (system stack vs Google Fonts)
- Type scale (h1 vs body vs caption)
- Color roles (background, text, accent, border)
- Contrast note if obviously low (teach, don't redesign unless asked)

**Term:** **design tokens** — named values (colors, spacing) reused across the site.

## Phase 6: JavaScript & interactivity

**Build:** List behaviors visible on the page:

| Behavior | Likely mechanism |
|----------|------------------|
| Mobile menu toggle | class on `nav`, click listener |
| Carousel | JS + CSS transform or library |
| Form submit | fetch POST or full page reload |
| Infinite scroll | intersection observer / framework |

If only minified bundles are visible, describe **observed behavior** and typical implementation — label as inference.

**Handoff:** interactivity rebuild → `/devlearn-javascript`; framework app shell → `/devlearn-react` or `/devlearn-next`

## Phase 7: Rebuild roadmap

**Build:** Ordered steps the user could follow in their own project:

1. HTML skeleton with landmarks
2. Mobile-first base styles
3. Layout (flex/grid)
4. Typography and colors
5. Interactivity last

Match depth to `DEVLEARN.md`:

| depth | Rebuild roadmap |
|-------|-----------------|
| vibe | 3–5 bullet steps, no full code |
| curious | Steps + one key snippet per section |
| deep | Steps + simplified clone plan with file names |

**Optional:** After user confirms, switch to `devlearn-html-css` and build a **simplified teaching clone** — same layout idea, original content/branding, no pixel-perfect copy of proprietary sites.

## Persona integration

| Persona | Behavior |
|---------|----------|
| **viber** | Short What/Why/How per phase; one term each; ASCII layout sketch |
| **seasoned** | Skip basics; decision blocks on stack choice and perf/a11y smells |
| **autodetect** | Match user language; offer "explain like I'm new" reset |

## Lesson integration

| When | Action |
|------|--------|
| After each phase | One lesson block (depth from DEVLEARN.md) |
| New term (flex, grid, DOM, hydration) | Append to `DEVLEARN_GLOSSARY.md` if enabled |
| Session end | Offer `/devlearn-recap` or `/devlearn-curriculum-router` for next build skill |

## Lifecycle handoffs

| Situation | Skill |
|-----------|--------|
| User wants to ship a clone | `devlearn-before-you-ship` if >5 files |
| Auth/login wall on target site | `devlearn-security` (don't bypass; teach concepts only) |
| Deploy their rebuild | `devlearn-deploy` |

See [../shared/ship-lifecycle.md](../shared/ship-lifecycle.md).

## Common mistakes

| Smell | Fix |
|-------|-----|
| Guessing CSS without inspecting | Open computed styles or fetched CSS first |
| Copying proprietary copy/images | Teach structure; use placeholder text and original styling |
| SPA shows empty shell in fetch | Use browser; explain client-side rendering |
| Site blocks bots | Ask user for screenshot or their own DevTools export |
| 50-page site scope | Narrow to one section or above-the-fold |
| Framework detected, user is new | Teach HTML/CSS layout first; mention framework second |

## Red flags / STOP

Stop and ask **one** question when:

- URL is login-only, paywalled, or illegal to scrape — teach general patterns only
- User wants exact clone of branded commercial site — offer simplified educational rebuild
- Page is malware/phishing — refuse; do not analyze beyond warning

## Required footer

```markdown
---
DevLearn status: DONE | IN PROGRESS (phase N/7)
URL: [analyzed link]
Artifacts: DEVLEARN_GLOSSARY.md (if updated) | rebuild files (if started)
Suggested next: /devlearn-html-css (rebuild) | /devlearn-curriculum-router
---
```

## Additional resources

- Gather checklist, tool matrix, output templates → [reference.md](reference.md)
- Sample breakdown → [examples.md](examples.md)
- Rebuild hands-on → `devlearn-html-css`, `devlearn-javascript`
- Framework pages → `devlearn-react`, `devlearn-next`
