---
name: devlearn-deploy
description: |
  Teaches deployment: build, hosting, environment on production, and what users
  actually hit when they open a URL. Use when the user wants to go live, share a
  link, set up CI, Docker, Vercel/Netlify/Fly, or curriculum routes here.
  Proactively suggest when adding deploy config and DEVLEARN.md is enabled.
---

# DevLearn: Deploy

## Iron law

**Teach without blocking ship.** Get a working public URL (or staging URL); explain build vs runtime as you go.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Viber → lesson-block. Seasoned → decision-block for host choice, env strategy, CI vs manual deploy.

## Context

**Deploy** means your code runs on a machine strangers can reach via URL. Vibe coders think "it's on my laptop" until it isn't — teach build output, env on server, and DNS as magic door numbers.

## Prerequisites

- Something that runs locally (static HTML, or `npm run build`)
- devlearn-git recommended for push-to-deploy flows

## Before you start

1. DEVLEARN.md depth (default **curious**)
2. Step 0: static site vs Node API vs full stack? existing host preference?
3. Detect platform from repo (vercel.json, Dockerfile, fly.toml, GitHub Actions)

## Phase 1: Local vs production

**Teach diagram (words):**

```
Your laptop: npm run dev  → localhost (only you)
Server:      build + host → https://your-app.com (everyone)
```

**Term:** **production** — environment real users hit

**Term:** **build** — compile/bundle code into deploy artifact

## Phase 2: Build step

**Build:** Run project's build (`npm run build`, static folder, etc.).

**Teach:** Dev uses hot reload; production serves optimized static files or server process.

**Anchor:** package.json scripts, build output dir (`dist/`, `.next/`, `build/`)

## Phase 3: Choose hosting pattern

| App type | Typical host | Teach |
|----------|--------------|-------|
| Static HTML/CSS/JS | Netlify, Vercel, GitHub Pages | Upload folder |
| SPA (Vite/React) | Vercel, Netlify | Build command + output dir |
| Node API | Fly, Render, Railway | Long-running process |
| Full stack Next | Vercel | Platform-native |

Pick simplest matching repo — don't over-platform.

## Phase 4: Environment on server

**Build:** Set env vars in host dashboard or deploy config.

**Teach:** Production `.env` lives on host, not in git. Redeploy after changing secrets.

Link to devlearn-apis env lesson if API keys involved.

## Phase 5: Deploy + verify

**Build:** Connect git push or CLI deploy; obtain HTTPS URL.

**Before calling deploy done:** suggest `/devlearn-pre-ship` if not run yet; `/devlearn-security` if secrets/auth in release.

**Verify checklist (local smoke — post-ship does prod incognito):**

- [ ] Homepage loads
- [ ] One interactive path works (add todo, etc.)
- [ ] API routes work on same origin or configured proxy
- [ ] No secrets in browser network tab

**Try it yourself:** Open URL on phone; different network than laptop.

**Term:** **HTTPS** — encrypted URL users should use

## Phase 6: CI preview (optional)

**Build:** GitHub Action or host preview on PR.

**Teach:** **CI** runs checks/build on each push; preview URL per PR.

Keep minimal for v1 — one paragraph unless user asked for CI.

## Domain glossary

| Term | Definition |
|------|------------|
| deploy | Put app on reachable server |
| build | Transform source to production artifacts |
| artifact | Output folder/image CI produces |
| host / platform | Service running your app |
| env var (prod) | Config on server |
| DNS | Name → server address lookup |
| HTTPS | Secure HTTP |
| preview deploy | Temporary URL for branch/PR |

## Common mistakes

| Mistake | Symptom | Fix |
|---------|---------|-----|
| Deploy dev server | Crash / slow | Use `build` + static/serve |
| Missing env on host | 500 in prod only | Set vars in dashboard |
| API on localhost in prod | fetch fails | Public API URL env |
| Wrong output directory | Blank site | Fix build output setting |
| Committed secrets | Security incident | Rotate + gitignore |

## STOP checkpoint

Before calling deploy done:

> "Open the live URL in an incognito window — does it work without your laptop running?"

If no, diagnose: static vs server, env, build output.

## Lesson integration

One lesson after URL works — focus on **what users hit** (CDN, server, edge).

If DEVLEARN.md `lifecycle.post_ship_verify: true` → immediately suggest **`/devlearn-post-ship`**.

Celebrate: shareable link = real software. Verification is a separate taught step.

## Required footer

```markdown
---
DevLearn status: DONE
Live URL: [url or pending]
Platform: [vercel|netlify|fly|other]
Suggested next: /devlearn-post-ship | /devlearn-git | /devlearn-curriculum-router
---
```

## Additional resources

- Platform notes → [reference.md](reference.md)
- Git push deploy → devlearn-git
