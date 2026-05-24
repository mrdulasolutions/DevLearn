---
name: devlearn-post-ship
description: |
  Teaches post-deploy verification: smoke tests, health checks, monitoring vocabulary,
  rollback, and declaring a release healthy. Use after deploy, "is prod ok", "post ship",
  canary, or when user shares a live URL. Pairs with devlearn-deploy and devlearn-pre-ship.
  Voice triggers: "post deploy", "prod check", "smoke test", "monitoring", "is it live".
---

# DevLearn: Post-Ship

## Iron law

**Verify in production-like conditions.** Incognito, real HTTPS URL, critical path once — not only on your logged-in laptop.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Celebrate working URL — then teach what to watch.

## Context

**Deploy** gets code live. **Post-ship** proves real users won't hit a broken path — and teaches what to do when something fails (rollback, logs, smoke tests).

Lifecycle: [../shared/ship-lifecycle.md](../shared/ship-lifecycle.md)

## Prerequisites

- Live URL (prefer HTTPS) or staging URL treated as prod drill
- Know what changed this release (commit, PR, or explain-diff)

## Before you start

1. Parse DEVLEARN.md `lifecycle.post_ship_verify`
2. Capture URL, commit SHA, deploy time if available
3. If no URL yet → suggest `/devlearn-deploy` first

## Phase 1: Capture deploy facts

```markdown
**Live URL:** https://...
**Commit/version:** abc123 / v1.2.0
**Release notes:** [one line user outcome]
**Changed areas:** [from diff summary]
```

Link `/devlearn-explain-diff` if user unsure what shipped.

## Phase 2: Smoke checklist

Run [reference.md](reference.md) checklist — document each row:

| Check | Why teach |
|-------|-----------|
| Homepage loads incognito | Cached auth/cookies hide bugs |
| Critical user path | The job your app exists for |
| API health or equivalent | Server actually up |
| Wrong env symptoms | Blank data, 500 on API only in prod |
| Second network / phone | Not just your WiFi |
| HTTPS redirect | Users hit secure URL |

**Viber:** top 3 checks + term **smoke test**.

**Seasoned:** add latency spot-check, error budget mention if relevant.

Write results to `.devlearn/post-ship-log.md` from [../.devlearn/post-ship-log-template.md](../.devlearn/post-ship-log-template.md) when `progress: true`.

## Phase 3: Monitoring basics (curious/deep)

| Concept | Plain English |
|---------|---------------|
| logs | server diary of errors |
| metrics | numbers over time (latency, error rate) |
| alert | notify human when threshold crossed |
| canary | small % traffic to new version first |
| rollback | revert to last good deploy |
| SLO | target reliability you aim for (seasoned) |

Don't setup full observability unless asked — teach vocabulary + one practical log location on their host.

## Phase 4: When something's wrong

1. **Rollback first** if users blocked — teach platform-specific path ([reference.md](reference.md))
2. **Then** debug with `/devlearn-debugging` using prod symptoms
3. **Seasoned postmortem (optional):** which pre-ship check would have caught it → update checklist

Never debug prod by guessing — reproduce in incognito, read logs, compare env to staging.

## Phase 5: Declare healthy

```markdown
## Post-ship status

**URL:** https://...
**Smoke tests:** pass / fail [list failures]
**Watch until:** [date + 24h default for risky releases]
**Rollback:** [one command or dashboard path]

### Term of the moment
**[smoke test]**: quick check that critical paths work where users actually go
```

## Persona integration

| Persona | Emphasis |
|---------|----------|
| viber | Incognito + one happy path + celebrate |
| seasoned | Rollback command, log query, watch window |
| autodetect | Match release risk |

## Handoffs

| Situation | Suggest |
|-----------|---------|
| Errors in prod logs | `/devlearn-debugging` |
| Need automated smoke in CI | `/devlearn-devops` |
| Next release | `/devlearn-pre-ship` |
| Session wrap | `/devlearn-recap` |
| Security incident | `/devlearn-security` |

## Common mistakes

| Smell | Fix |
|-------|-----|
| Test only while logged in as dev | Incognito path |
| "Homepage works" only | Run critical business path |
| Ignore API 500 on prod | Network tab on same URL users use |

## STOP checkpoint

If smoke fail:

> "Rollback now (users broken) or hotfix forward? I'll teach rollback steps either way."

## Required footer

```markdown
---
DevLearn status: DONE | BLOCKED
Production healthy: yes | no | monitoring
Smoke passed: N/M
Suggested next: /devlearn-recap | rollback | /devlearn-debugging | /devlearn-devops
---
```

## Additional resources

- Checklist detail → [reference.md](reference.md)
- Example log entry → [examples.md](examples.md)
- Deploy → `devlearn-deploy`
