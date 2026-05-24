---
name: devlearn-before-you-ship
description: |
  Pre-coding plain-English plan before large refactors or multi-file changes.
  Use when >5 files will change, architecture shifts, new dependencies, or user
  asks "what will you change before you do it". NOT the release checklist — use
  devlearn-pre-ship before merge/deploy. Pairs with devlearn-teach-while-coding when
  before_big_changes is true. Lifecycle: shared/ship-lifecycle.md. Voice triggers:
  "plan first", "before you refactor", "what are you about to change".
---

# DevLearn: Before You Ship (Plan)

## Iron law

**Plan in plain language; do not block small fixes.** User says "go" → execute.

## Voice

Follow [../shared/voice.md](../shared/voice.md). No code dumps in the plan — filenames and intent only.

## Context

**This skill is pre-coding planning** — before you edit files.

| Skill | When |
|-------|------|
| **before-you-ship** (this) | Before writing code — scope, risks, verify |
| **pre-ship** | Before merge/release — tests, staging, rollback |
| **deploy** | Going live |
| **post-ship** | After URL exists — smoke tests |

Full chain: [../shared/ship-lifecycle.md](../shared/ship-lifecycle.md)

Vibers lose trust when agents touch ten files silently. Seasoned devs want **scope and risk** without a design doc novel.

## Prerequisites

- `DEVLEARN.md` optional; honor `before_big_changes: true|false`
- Enough context to name files/areas (or ask one clarifying question)

## When to invoke

| Trigger | Action |
|---------|--------|
| `before_big_changes: true` and >5 files | Offer or run this skill |
| User: "plan first", "what will you change?" | Run |
| New dependency + restructure | Run |
| Architecture shift (auth, DB, routing) | Run |
| Single-file bug fix | **Skip** |
| User: "just ship" / "do it" | Skip plan; execute |

Meta skill (`devlearn-teach-while-coding`) should offer this automatically when thresholds hit.

## Before you start

1. Estimate file count and blast radius (grep/read structure)
2. Read DEVLEARN.md persona — viber gets one term preview; seasoned gets decision framing
3. Check if `/devlearn-pre-ship` is what they meant ("ready to merge" → redirect)

## Phase 1: Understand goal

Restate user outcome in **one sentence** — their words, not tech jargon.

If goal unclear, Status: NEEDS_CONTEXT — one question max.

## Phase 2: Draft plan

Output shape:

```markdown
## Before we change code

**Goal:** [user outcome in one sentence]

**What will change (plain English):**
1. [area/file group] — [intent]
2. ...
3. ...

**What we're NOT changing:** [scope guard — e.g. no redesign, no new deps]

**Files / areas (estimate):** ~N files — [list groups, not every path unless seasoned asks]

**Risks:** [max 3, one line each]

**Verify after:** [click path, command, or test name]

**Persona note:**
- viber: [one term they'll see, e.g. "refactor = rearrange without changing behavior"]
- seasoned: [main decision, e.g. "extract service layer vs inline handlers"]

**Lifecycle note:** [if change touches auth/secrets/CI — flag pre-ship/security/devops later]

Proceed? (yes / adjust / just ship)
```

See [reference.md](reference.md) for examples by change type.

## Phase 3: Wait or execute

| User reply | Action |
|------------|--------|
| yes / go / lgtm | Execute plan; meta skill emits lesson after |
| adjust | Revise plan once; ask what to narrow |
| just ship | Execute without re-planning |
| silent + already said "plan and go" | Execute |

**STOP:** Do not edit files until confirmation unless user explicitly combined plan+execute in one message.

## Phase 4: After execution

Suggest:

- `/devlearn-explain-diff` if many files changed
- `/devlearn-pre-ship` when user says release-ready
- `/devlearn-security` if auth/secrets touched

## Persona integration

| Persona | Plan emphasis |
|---------|---------------|
| viber | Plain English steps; one term; verify = "click X and see Y" |
| seasoned | Risks, rollback, decision preview; optional file list |
| autodetect | Match user message formality |

## Common mistakes

| Smell | Fix |
|-------|-----|
| Plan is pseudo-code | Plain English only |
| 40-file plan with no grouping | Cluster into 3–6 intent groups |
| Confused with pre-ship | Link lifecycle doc |
| Plan for one-line fix | Skip skill |

## Red flags

| Situation | Action |
|-----------|--------|
| Deletes data / migration | Explicit backup + verify in plan |
| Production hotfix | Short plan still; note post-ship verify |
| User impatient | "just ship" overrides |

## Required footer

```markdown
---
DevLearn status: DONE | NEEDS_CONTEXT | AWAITING_CONFIRM
Plan files estimate: N
Suggested next: execute plan | /devlearn-explain-diff after | /devlearn-pre-ship when release-ready
---
```

## Additional resources

- Examples by change type → [reference.md](reference.md)
- Release checklist → `devlearn-pre-ship`
- Ambient trigger → `devlearn-teach-while-coding`
