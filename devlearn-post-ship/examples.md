# DevLearn post-ship — examples

## Example smoke log entry

```markdown
# Post-ship log — 2026-05-24

**URL:** https://my-todos.vercel.app
**Commit:** a1b2c3d
**Tester:** incognito Chrome, iPhone Safari

| Check | Result | Notes |
|-------|--------|-------|
| Homepage | ✅ | 200, loads <2s |
| Add todo | ✅ | persists refresh |
| Delete todo | ✅ | |
| /api/health | ✅ | `{"ok":true}` |
| Wrong env | n/a | — |

**Status:** healthy — watch until 2026-05-25
**Rollback:** Vercel → Deployments → Promote previous
```

## Example failure + rollback teach (viber)

```markdown
## Post-ship status

**Smoke tests:** fail — add todo returns 500 in incognito

**What users see:** Page loads but saving breaks.

**Rollback:** Vercel dashboard → last green deployment → Promote to Production

### Term of the moment
**Rollback** — switching live traffic back to the last version that worked.
```

## Critical path by app type

| App type | Smoke path |
|----------|------------|
| Todo | add → refresh → delete |
| Blog | home → article → RSS optional |
| API-only | GET health + one authenticated POST |
| Next auth app | signup/login → protected page incognito |

## Chain with other skills

After `/devlearn-deploy` returns URL:

```
/devlearn-post-ship on https://...
→ if fail: rollback teach + /devlearn-debugging
→ if pass: /devlearn-recap
```
