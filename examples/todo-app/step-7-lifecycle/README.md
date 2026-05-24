# Step 7 — Ship lifecycle

After the app works locally (step 4+) and optionally git (step 5) + deploy (step 6):

## Recommended skill order

1. **`/devlearn-devops`** — add GitHub Actions: `npm test` on PR
2. **`/devlearn-pre-ship`** — checklist before merge/release
3. **`/devlearn-security`** — scan for secrets, XSS (`innerHTML`), deps audit
4. **`/devlearn-deploy`** — publish static site
5. **`/devlearn-post-ship`** — smoke test live URL in incognito

## Artifacts created

- `.devlearn/pre-ship-checklist.md`
- `.devlearn/post-ship-log.md`

Templates in DevLearn repo: `.devlearn/pre-ship-checklist-template.md`, `post-ship-log-template.md`

## Minimal CI snippet

See [../../devlearn-devops/examples.md](../../devlearn-devops/examples.md).

## DEVLEARN.md lifecycle block

```yaml
lifecycle:
  pre_ship_checklist: true
  security_pass: true
  post_ship_verify: true
  devops_on_ci: true
```
