# DevLearn pre-ship — examples

## Example output (viber, partial pass)

```markdown
## Pre-ship checklist

**Release target:** PR #42 → merge to main → Vercel prod

**Change summary:** Todo delete button + localStorage fix

| Check | Result | Action if fail |
|-------|--------|----------------|
| App runs locally | ✅ | — |
| Add/delete/refresh path | ✅ | — |
| `npm test` | ⏭ | No tests yet — add one happy-path test later |
| Secrets in diff | ✅ | No `.env` files |
| Preview URL works | ❌ | Open Vercel preview — API 500 |
| Rollback | ✅ | Redeploy previous Vercel deployment |

**Blockers:** Preview API 500 — likely missing env on preview

**Ready:** no — fix preview env, re-check

### Term of the moment
**Preview deploy** — a temporary URL for your branch so you can test before real users see it.
```

## Example output (seasoned, ready)

```markdown
## Pre-ship checklist

**Release target:** tag v2.1.0

| Check | Result |
|-------|--------|
| CI green | ✅ |
| `npm run build` | ✅ |
| DB migration backward compatible | ✅ (additive column only) |
| Rollback | `fly releases list` → rollback previous |
| On-call notified | ✅ |

**Ready:** yes — deploy via CI job after tag push

### Decision note
Ship without feature flag — low risk UI copy change only; rollback is revert deploy.
```

## When to chain skills

```
User: "ready to ship"
→ pre-ship (this)
→ security (if auth/secrets/input)
→ deploy
→ post-ship (live URL)
```

## Copy-paste user prompts

- `/devlearn-pre-ship` — run full checklist before I merge PR #12
- Pre-ship vibe mode — only the 5 essential checks, teach one term
- Pre-ship seasoned — include rollback and migration notes
