# devlearn-pre-ship — reference

## Commands to discover (run what exists)

```bash
npm test
npm run lint
npm run typecheck
npm run build
git diff main...HEAD --stat
gh pr checks
```

Skip missing scripts; note gap as devops opportunity.

## Staging vs production

| | Staging | Production |
|---|---------|------------|
| Purpose | Last look before users | Real users |
| Data | Often fake/sanitized | Real |
| Env | staging env vars | prod env vars |

Teach: "Works in staging" reduces surprise; not a guarantee.

## Rollback one-liners

| Platform | Rollback |
|----------|----------|
| Vercel/Netlify | Previous deployment in dashboard |
| Fly | `fly releases list` + rollback |
| Git-only | Revert merge commit; redeploy |

## Minimal viber checklist (5 items)

1. App runs locally
2. Main user path clicked manually
3. No `.env` in git
4. Someone else could deploy from docs
5. Know how to undo

## Seasoned additions

- Load/smoke on critical endpoint
- DB migration backward compatible?
- Feature flags for risky launches
- On-call knows release happened

## When to skip pre-ship

- Docs-only change (note LESSON_SKIPPED)
- User explicitly hotfix with eyes open (document risk)
