---
name: devlearn-debugging
description: |
  Teaches debugging while fixing real errors: reproduce, read stack/console, trace root
  cause, minimal fix, verify. Use when user pastes an error, "it's broken", blank page,
  failed test, or unexpected behavior. Proactively suggest when console/stack trace appears
  and DEVLEARN.md is enabled. Pairs with devlearn-apis (CORS/404), devlearn-react/next
  (hooks), devlearn-security (auth failures). Voice triggers: "debug this", "why is it broken".
---

# DevLearn: Debugging

## Iron law

**Fix first, teach from the real error.** No hypothetical debugging lectures.

## Voice + blocks

Follow [../shared/voice.md](../shared/voice.md). Viber → lesson-block on **cause**. Seasoned → decision-block when choosing quick patch vs root fix.

## Context

Errors feel personal ("I'm bad at coding"). Reframe: **the computer is giving clues** — stack trace, status code, line number. This skill fixes the bug and teaches one durable debugging move.

## Prerequisites

- devlearn-javascript helpful for syntax/DOM errors
- devlearn-apis for CORS, fetch, 404
- devlearn-react / devlearn-next for component/hook errors

## Before you start

1. Parse DEVLEARN.md depth — vibe: one term; deep: trace + DevTools
2. Capture **exact** error text (don't paraphrase)
3. Ask what user did right before break (one question if unclear)

## Phase 1: Reproduce & capture

| Source | Collect |
|--------|---------|
| Browser | Console first red line, Network failed row |
| Terminal | Full stack, exit code |
| Test runner | Failing test name + assertion |
| User report | "blank page", "button does nothing" |

Document:

- Error message verbatim
- File:line from **first project frame** (not node_modules)
- Steps to reproduce

## Phase 2: Translate (viber)

Plain English template:

> "The [browser/server/test] expected X but got Y because Z."

**Term of the moment:** one error-related term (undefined, CORS, 404, TypeError, hydration)

## Phase 3: Trace (curious/deep)

1. Read stack **top → bottom**; stop at first `src/` or project path
2. Open file:line; read surrounding 5–10 lines
3. Form hypothesis: "Variable is undefined because import wrong"
4. Seasoned: state hypothesis **before** edit; verify after

DevTools script: [reference.md](reference.md)

## Phase 4: Fix & verify

- **Minimal fix** — smallest change that resolves error
- Re-run same steps user used
- Confirm error gone (screenshot or "no red in console")

Lesson block on **cause**, not every edited line.

## Phase 5: Prevent recurrence (curious+)

One line: test, guard clause, typecheck, or lint rule that would catch it next time.

## Error pattern table

| Error smell | Likely cause | Teach | Handoff |
|-------------|--------------|-------|---------|
| `undefined is not a function` | Wrong import/name | imports | javascript |
| `Cannot read property X of undefined` | Missing data guard | optional chaining | javascript |
| `CORS policy` | Cross-origin fetch | browser security gate | apis |
| `404` on fetch | Wrong URL/method | endpoint | apis |
| Blank white page | Uncaught throw before render | console first line | javascript |
| `Module not found` | Path/package | deps install | git/npm |
| `Hydration mismatch` | Server HTML ≠ client | server/client split | next |
| `Too many re-renders` | setState in render loop | hooks rules | react |
| `401/403` | Auth missing/wrong | session/token | security/apis |
| Test timeout | Async not awaited | promises | javascript |

Full table: [reference.md](reference.md)

## Persona integration

| Persona | Behavior |
|---------|----------|
| viber | Feel-first translation; one term; show console location |
| seasoned | Hypothesis + verify; decision block if patch vs refactor |
| autodetect | Match urgency — production → shorter teach |

## Lifecycle handoffs

| After fix | Suggest |
|-----------|---------|
| Error in production | `/devlearn-post-ship` rollback/smoke |
| Auth bug | `/devlearn-security` |
| CI test fail | `/devlearn-devops` |
| User still lost | `/devlearn-explain-diff` on fix commit |

## Common mistakes

| Smell | Fix |
|-------|-----|
| Random edits without reading stack | STOP at phase 3 |
| Teaching HTTP spec during CORS | apis skill one-paragraph model |
| Fix attempt 3+ without progress | One diagnostic question; narrow scope |

## STOP checkpoint

If error persists after **2** fix attempts:

> "Which is true: (A) same error message, (B) new error, (C) no error but wrong behavior?"

One follow-up based on answer. Do not spiral.

## Required footer

```markdown
---
DevLearn status: DONE | BLOCKED
Error class: [syntax|runtime|network|auth|test|unknown]
Suggested next: /devlearn-explain-diff | /devlearn-apis | /devlearn-react | keep building
---
```

## Additional resources

- DevTools & stack patterns → [reference.md](reference.md)
- HTTP/API errors → `devlearn-apis`
- Production issues → `devlearn-post-ship`
