# devlearn-post-ship — reference

## Smoke test script (static todo app)

1. Open `https://YOUR_URL` in incognito
2. Add todo "smoke test"
3. Refresh — still there (if persistence)
4. Delete — gone

## API smoke

```bash
curl -sf https://YOUR_URL/api/health
curl -sf https://YOUR_URL/api/todos
```

`-f` fails on HTTP error — teach status codes.

## Platform rollback

| Platform | Rollback path |
|----------|---------------|
| Vercel | Deployments → Promote previous |
| Netlify | Deploys → Publish previous |
| Fly.io | `fly releases rollback` |
| K8s | rollout undo (deep) |

## Canary (concept)

Route 5% traffic to new version; watch error rate; full promote or rollback.

Viber: one sentence. Seasoned: metric + threshold.

## What to monitor first 24h

- Error rate in logs
- Latency spike
- Failed payments / auth (if applicable)
- Support tickets / user reports

## Post-ship ≠ done forever

Schedule: revisit pre-ship checklist next release.

Teach **release cadence**: small ships easier to verify than big bang.

## Healthy declaration

All smoke pass + no P0 errors in first hour → **healthy enough**; keep watching.

Don't demand perfection on day one for side projects.
