# devlearn-deploy — reference

## Static site (no build)

**Files:** `index.html`, `app.js`, `styles.css`

| Platform | Pattern |
|----------|---------|
| Netlify | Drag folder or connect repo, publish directory `/` |
| GitHub Pages | Push to `gh-pages` or Actions |
| Vercel | Import repo, framework preset "Other", output `.` |

## Vite / SPA

```json
// package.json
"scripts": {
  "build": "vite build",
  "preview": "vite preview"
}
```

| Platform | Build command | Output dir |
|----------|---------------|------------|
| Vercel | `npm run build` | `dist` |
| Netlify | `npm run build` | `dist` |

Teach: `preview` simulates production locally before push.

## Next.js

- Vercel native — connect repo, auto-detect
- Env vars in Project Settings → Environment Variables
- Server routes deploy as serverless functions (teach: API lives on same domain)

## Node API (Fly.io sketch)

```toml
# fly.toml (conceptual)
app = "my-todo-api"
```

Deploy CLI: `fly deploy` after Dockerfile or buildpack.

Teach: long-running **process** vs static files.

## Environment variable checklist

| Var | Where set | Never |
|-----|-----------|-------|
| DATABASE_URL | Host dashboard | Commit to git |
| API_SECRET | Host only | Frontend bundle |
| PUBLIC_* | Can be public prefix | Put secrets in PUBLIC |

## DNS one paragraph script

> `yourapp.com` is a name. DNS tells browsers which server IP to talk to. Platform gives you a subdomain first (`yourapp.vercel.app`); custom domain adds your name pointing to them.

## Post-deploy debug order

1. Open browser DevTools → Console (client errors)
2. Network tab → failed requests (404 API, CORS)
3. Host logs (server 500)
4. Compare env local vs production

## HTTPS

Modern hosts provision TLS automatically. Teach: always share `https://` links.

## Rollback story (deep)

> Deploy is a new version pointer. Most hosts let you roll back to previous deploy in dashboard — like git revert for infrastructure.

Pair with devlearn-git for code rollback narrative.
