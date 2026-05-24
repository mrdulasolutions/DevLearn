# DevLearn before-you-ship — reference

## Change type examples

### Refactor (extract module)

**Goal:** Make todo save logic reusable without changing behavior.

**What will change:**
1. Move save/load from `app.js` into `storage.js`
2. Update imports in `app.js` and tests

**NOT changing:** UI, API shape, localStorage key name

**Risks:** Missed import → blank list on load

**Verify:** Add todo, refresh, delete todo — same as before

### Add auth (multi-file)

**Goal:** Only logged-in users see their todos.

**What will change:**
1. Login/signup UI
2. Server routes for session or JWT
3. Protect todo API routes
4. Env vars for secrets

**NOT changing:** Todo data model fields (unless needed)

**Risks:** Secrets in repo; broken guest access

**Verify:** Logout → cannot read todos; login → sees own list

**Lifecycle:** Run `/devlearn-security` before merge; `/devlearn-pre-ship`

### Framework migration (large)

**Goal:** Move todo app from vanilla JS to React.

**What will change:**
1. Tooling (Vite/CRA), component structure
2. Reimplement UI + state in components
3. Retire old `app.js` entry pattern

**NOT changing:** Backend API contract (if any)

**Risks:** Scope creep; lost features during port

**Verify:** Feature parity checklist — add/edit/delete/persist

**Persona:** Seasoned — document "React SPA vs keep MPAs" decision in decisions.md

### CI/CD introduction

**Goal:** Run tests on every PR.

**What will change:**
1. `.github/workflows/ci.yml`
2. Maybe test script in package.json

**NOT changing:** App behavior

**Risks:** Flaky CI blocks merges

**Verify:** Push branch; see green check

**Handoff:** `/devlearn-devops` for teaching during implementation

## File count heuristics

| Count | Typical action |
|-------|----------------|
| 1–2 | Skip before-you-ship |
| 3–5 | Optional one-paragraph plan in chat |
| 6+ | Full plan block |
| many + user confusion | Plan + later explain-diff |

## Risk vocabulary (viber-friendly)

| Term | Plain English |
|------|---------------|
| regression | Something that worked stops working |
| breaking change | Old clients/users break until they update |
| rollback | Undo deploy or revert commit |
| scope creep | Extra features sneaking into the same change |

## Confirmation phrases that mean GO

- "yes", "go", "do it", "lgtm", "ship it", "plan and go", "sounds good"

## When to redirect to pre-ship

User language:

- "ready to merge", "release checklist", "before deploy", "production"

→ "That sounds like `/devlearn-pre-ship` (verify before release). This skill plans code before we edit."
