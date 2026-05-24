# devlearn-explain-diff — reference

Plain-language patterns for common diff hunk types.

## Imports

**What:** New import line at top of file.

**Why:** Pulls in code defined elsewhere so we can call it here.

**How:** `file.ts:1` — `import { X } from 'y'`.

**Term:** **import** — borrows code from another file/module.

## New function / handler

**What:** New function that runs when something happens.

**Why:** Keeps event reaction in one named place instead of inline spaghetti.

**How:** `app.js:15` — `function handleSave() { ... }`.

**Term:** **handler** — function that runs in response to an event.

## DOM query / manipulation

**What:** Code finds an element and changes it.

**Why:** HTML is static; JS updates the page without reload.

**How:** `app.js:8` — `document.getElementById('list')`.

**Terms:** **DOM** — tree of page elements; **query** — find an element.

## fetch / API call

**What:** Browser asks a server for data.

**Why:** Server holds data users share or that outlives one browser.

**How:** `api.js:22` — `fetch('/api/todos')`.

**Terms:** **request**, **endpoint**, **JSON**.

## Env var added

**What:** Config reads `process.env.API_URL` or similar.

**Why:** Secrets and URLs differ per machine; don't hardcode in git.

**How:** `.env.example:1` — documents key name without secret value.

**Term:** **environment variable** — config from outside the code file.

## Package.json dependency

**What:** New entry under `dependencies`.

**Why:** Reuse battle-tested library instead of reinventing.

**How:** `package.json:12` — package name and semver range.

**Term:** **dependency** — external code your project installs.

## CSS layout change

**What:** Flex/grid/display rules changed.

**Why:** Controls where elements sit on screen.

**How:** `styles.css:40` — `display: flex`.

**Term:** **flexbox** — one-dimensional layout for rows/columns.

## Test added

**What:** New test file or `it('...')` block.

**Why:** Locks expected behavior so future edits don't break silently.

**How:** `app.test.js:5` — assertion on save behavior.

**Term:** **assertion** — check that output matches expectation.

## CI / deploy config

**What:** YAML or platform config for build/deploy.

**Why:** Automates "push code → live site" without manual steps.

**How:** `.github/workflows/deploy.yml:1`.

**Term:** **CI** — automated checks/build on each push.

## Git-only diff (no code semantics)

If diff is only `.gitignore`, README, or license — say it's **project hygiene**, not user-facing behavior. Still one sentence of why.

## Grouping heuristics

| If hunks share | Group as |
|----------------|----------|
| Same feature flag or route | One feature group |
| Same bug symptom in commit message | One fix group |
| rename + import updates | Refactor (mechanical) |
| test + implementation | Feature (note test proves behavior) |

## Depth expansion

**Deep mode** add per group:

- **Before/after behavior** — what user could do before vs after
- **Failure mode** — what breaks if this hunk is reverted
- **Alternative** — what you didn't do and why
