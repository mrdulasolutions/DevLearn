# Step 6 — Deploy

Copy the complete app from `step-4-persist/` (or step-5-git after commit).

## Static deploy (Netlify / Vercel / GitHub Pages)

| Platform | Build command | Output directory |
|----------|---------------|------------------|
| Static | *(none)* | `.` (folder with index.html) |
| GitHub Pages | — | root or `/docs` |

## Verify

1. Open deploy URL in incognito
2. Add a todo, refresh — still there
3. Run `/devlearn-deploy` for build vs runtime explanation

## Example netlify.toml (optional)

```toml
[build]
  publish = "."
```

No build step needed for this static todo app.
