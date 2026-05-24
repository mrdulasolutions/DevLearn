# Stack detection for curriculum router

Run before Phase 2 route matching.

## Read package.json

| Signal | stack value | Prefer skills |
|--------|-------------|---------------|
| `"next"` in dependencies | next | devlearn-next → devlearn-react → devlearn-deploy |
| `"react"` (no next) | react | devlearn-react → devlearn-javascript |
| `"vite"` or no framework | vanilla | devlearn-html-css → devlearn-javascript |

Update DEVLEARN.md `stack:` when autodetect if file writable.

## Route overrides

| stack | Instead of vanilla path |
|-------|-------------------------|
| next | Skip pure html-css unless user needs fundamentals; start next + react |
| react | react after quick js refresh if needed |
| vanilla | existing html-css → js chain |

## package.json absent

Assume vanilla static site path unless user names a framework.

## Example router output (Next detected)

```markdown
**Detected stack:** Next.js (from package.json)

**Learn next:**
1. `/devlearn-next` — routing and server/client split in your app
2. `/devlearn-react` — components and state for UI
3. `/devlearn-deploy` — Vercel-style deploy
```
