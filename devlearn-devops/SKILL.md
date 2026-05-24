---
name: devlearn-devops
description: |
  Teaches DevOps while building pipelines: CI/CD, GitHub Actions, Docker, environments,
  test gates, secrets in CI. Use when user adds workflow yaml, Dockerfile, "set up CI",
  staging vs prod, or wants deploy automation. Pairs with devlearn-pre-ship, devlearn-deploy,
  devlearn-security, devlearn-post-ship. Voice triggers: "CI/CD", "pipeline", "github actions",
  "docker", "automated deploy".
---

# DevLearn: DevOps

## Iron law

**Teach without blocking ship.** Smallest pipeline that catches **real** bugs — not 200-line yaml on day one.

## Voice

Follow [../shared/voice.md](../shared/voice.md). DevOps jargon → plain English first.

## Context

DevOps connects **git push** to **automated checks** and optionally **deploy**. Vibers copy yaml without knowing what runs when. Teach the robot teammate mental model.

Lifecycle: [../shared/ship-lifecycle.md](../shared/ship-lifecycle.md)

## Prerequisites

- Git repo with test/lint/build commands (or create minimal ones)
- Deploy target known — link **devlearn-deploy**

## Before you start

1. Parse DEVLEARN.md `lifecycle.devops_on_ci`
2. Inventory `.github/workflows/`, `Dockerfile`, platform CI config
3. Read `package.json` scripts — use what exists

## Mental model

```
git push → CI runs → tests/build → artifact → deploy (manual or auto)
```

| Term | Plain English |
|------|---------------|
| CI | Automated checks on every push/PR |
| CD | Automated deploy after green CI |
| pipeline / workflow | Ordered steps in CI |
| artifact | Build output CI saves (folder, image) |
| container | App + runtime packaged (Docker) |
| staging | Pre-prod environment |
| required check | Merge blocked until green |

## Phase 1: Discover stack

| Look for | Implies |
|----------|---------|
| `.github/workflows/*.yml` | GitHub Actions |
| `Dockerfile` | Container deploy |
| `vercel.json`, `fly.toml` | Platform-native deploy |
| No CI | Start minimal workflow |

Document current state before adding files.

## Phase 2: Minimal CI (first win)

**Build:** workflow on PR/push:

1. checkout
2. install deps (cache optional deep)
3. lint / test / build — **only scripts that exist**

**Teach:** CI = robot teammate running commands you forget before merge.

**Anchor:** `.github/workflows/ci.yml:1`

Examples: [examples.md](examples.md)

## Phase 3: Gates (curious/deep)

Add merge-blocking checks:

- tests required
- typecheck
- `npm audit --audit-level=high` — link **devlearn-security**

**Seasoned decision:** required vs advisory checks; branch protection rules.

Suggest `/devlearn-pre-ship` before enabling auto-deploy to prod.

## Phase 4: Docker (when needed)

**When:** long-running server, non-serverless host, reproducible env complaint.

**When NOT:** static site, Vercel/Netlify SPA — unnecessary complexity.

**Teach:** Dockerfile instructions → image → container on host.

Anchor: `Dockerfile:1`, `.dockerignore`

## Phase 5: Environments

| Env | Trigger | Purpose |
|-----|---------|---------|
| preview | PR | Review app URL |
| staging | main push | Pre-prod parity |
| production | tag / manual approval | Users |

**Teach:** env vars per environment — GitHub Secrets, host dashboard, not git.

## Phase 6: CD hook

Connect green CI to deploy:

- Platform auto (Vercel/Fly)
- Workflow deploy job with approval gate for prod

Hand off runtime verification to **devlearn-post-ship**.

## Persona integration

| Persona | Focus |
|---------|-------|
| viber | One workflow, three steps, term CI |
| seasoned | Branch protection, secrets, rollback on failed deploy |
| autodetect | Skip Docker unless server deploy |

## Common mistakes

| Smell | Fix |
|-------|-----|
| CI passes locally fails | Pin node version; commit lockfile |
| Secrets in workflow yaml | GitHub Secrets / host secrets |
| Slow CI no cache | cache deps (deep) |
| Auto prod on every main push | manual approval / tag deploy |
| CI green but prod broken | add post-ship smoke or staging gate |

## STOP checkpoint

Before enabling auto-deploy to prod:

> "Have we run `/devlearn-pre-ship` and `/devlearn-security` at least once on this pipeline?"

## Required footer

```markdown
---
DevLearn status: DONE
Pipeline: [describe file + triggers]
Checks: [lint|test|build]
Suggested next: /devlearn-pre-ship | /devlearn-post-ship | /devlearn-deploy
---
```

## Additional resources

- Workflow patterns → [reference.md](reference.md)
- Copy-paste workflows → [examples.md](examples.md)
- Security in CI → `devlearn-security`
