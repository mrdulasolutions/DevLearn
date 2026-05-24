---
name: devlearn-pre-ship
description: |
  Pre-ship release checklist before merge or deploy: tests, lint, build, secrets scan,
  staging verify, rollback plan, breaking changes. Use when user says "ready to ship",
  "pre-ship", "release checklist", "before we merge", or before production deploy.
  Differs from devlearn-before-you-ship (plans code before editing). Pairs with
  devlearn-security, devlearn-deploy, devlearn-devops. Voice triggers: "pre ship",
  "release ready", "merge checklist".
---

# DevLearn: Pre-Ship

## Iron law

**Teach without blocking ship.** Checklist guides; user decides go/no-go.

## Voice + blocks

Follow [../shared/voice.md](../shared/voice.md). Viber → lesson-block per failed category with one term. Seasoned → decision-block on rollback, staging parity, migration risk.

## Context

| Skill | When |
|-------|------|
| **before-you-ship** | Before **writing** code — scope plan |
| **pre-ship** (this) | Before **merge/release** — verify quality |
| **security** | Auth, secrets, input — often after pre-ship triage |
| **deploy** | Push to production host |
| **post-ship** | Smoke test live URL |

Lifecycle: [../shared/ship-lifecycle.md](../shared/ship-lifecycle.md)

## Prerequisites

- Code at least runs locally
- Know release target: PR merge, tag, or direct deploy

## Before you start

1. Parse DEVLEARN.md `lifecycle.pre_ship_checklist` — skip only if user explicitly overrides
2. Identify release target and environment (staging vs prod)
3. Run discoverable commands from [reference.md](reference.md)

## Phase 1: Gather context

| Input | How |
|-------|-----|
| Release target | PR #, version tag, branch |
| Change scope | `git diff main...HEAD --stat` or user summary |
| CI status | `gh pr checks`, local test run |
| Risk areas | auth, migrations, deps, config |

Offer `/devlearn-explain-diff` if user doesn't know what changed.

## Phase 2: Run checklist

For each row in reference: **pass / fail / skip / n/a** + one-line why.

| Area | Teach term if fail |
|------|-------------------|
| Tests | regression, test suite |
| Lint / types | static analysis |
| Build | production bundle |
| Secrets in diff | env var, gitignore |
| Staging / preview | parity with prod |
| Rollback path | revert deploy, previous image |
| Prod env vars | configuration on host |
| Breaking changes | migration, API contract |
| Docs / changelog | user-facing communication |

**Viber minimal path:** reference.md "5 items" subset when time-constrained.

**Seasoned path:** full table + migration backward compatibility.

## Phase 3: Output report

```markdown
## Pre-ship checklist

**Release target:** [PR # / v1.2.0 / deploy to prod]

**Change summary:** [one line]

| Check | Result | Action if fail |
|-------|--------|----------------|
| Tests | ✅ / ❌ / ⏭ | ... |

**Blockers:** [none or prioritized list max 3]

**Ready:** yes / no — [one sentence]

### Term of the moment (viber)
**[term]**: [definition tied to top blocker or key pass]
```

If `progress: true`, write snapshot to `.devlearn/pre-ship-checklist.md` from [../.devlearn/pre-ship-checklist-template.md](../.devlearn/pre-ship-checklist-template.md).

## Phase 4: Handoffs

| Result | Suggest |
|--------|---------|
| Secrets/auth/input in diff | `/devlearn-security` |
| No CI / tests missing | `/devlearn-devops` |
| Ready to go live | `/devlearn-deploy` |
| After deploy URL exists | `/devlearn-post-ship` |
| Blockers need code fix | fix → re-run pre-ship |

## Persona integration

| Persona | Output |
|---------|--------|
| viber | Top 3 checks + one term; celebrate green checks |
| seasoned | Blockers with verify commands; rollback one-liner |
| autodetect | Match urgency |

## Common mistakes

| Smell | Fix |
|-------|-----|
| "Works on my machine" only | Require staging or preview URL check |
| Skip tests "just docs" | Note LESSON_SKIPPED; still scan secrets |
| Confuse with before-you-ship | Link lifecycle doc |

## STOP checkpoint

If blockers exist:

> "Fix these 3 in order, or deploy anyway? (I'll note risk)"

Seasoned users get explicit rollback reminder on "deploy anyway".

## Required footer

```markdown
---
DevLearn status: DONE | BLOCKED
Ready to ship: yes | no
Blockers: N
Suggested next: /devlearn-security | /devlearn-deploy | fix blockers | /devlearn-devops
---
```

## Additional resources

- Full checklist + commands → [reference.md](reference.md)
- Plan before coding → `devlearn-before-you-ship`
- Example filled checklist → [examples.md](examples.md)
