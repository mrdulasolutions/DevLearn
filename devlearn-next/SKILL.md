---
name: devlearn-next
description: |
  Teaches Next.js App Router while building: file-based routes, layouts, server vs
  client components, route handlers, env vars, and data fetching patterns. Use when
  package.json includes next, DEVLEARN.md stack is next, or editing app/, page.tsx,
  layout.tsx, route.ts. Pairs with devlearn-react, devlearn-apis, devlearn-deploy
  (Vercel). Voice triggers: "next.js", "app router", "server component", "route handler".
---

# DevLearn: Next.js

## Iron law

**Teach without blocking ship.** Match the project's Next major version patterns (App Router default).

## Voice + blocks

Follow [../shared/voice.md](../shared/voice.md). **Server/client boundary** = prime seasoned decision-block territory.

## Context

Next.js adds **routing, server rendering, and API routes** on top of React. Vibers paste `'use client'` everywhere or put `useState` in server files. Teach **file = URL** and **split by interactivity**.

## Prerequisites

- devlearn-react strongly recommended
- devlearn-apis for HTTP/route handler details
- devlearn-javascript for async/fetch basics

## Before you start

1. Confirm App Router (`app/` directory) vs legacy `pages/` — this skill targets **App Router**
2. Read `next` version in package.json
3. Check existing `'use client'` files for project convention

## Mental model

| Piece | Plain English |
|-------|---------------|
| App Router | Folders under `app/` map to URLs |
| `page.tsx` | UI for that URL segment |
| `layout.tsx` | Shared shell wrapping child pages |
| Server Component | Default — runs on server, no hooks |
| Client Component | `'use client'` — browser interactivity |
| `route.ts` | HTTP API on same domain (`/api/...`) |
| Server Action | Server function called from forms (deep) |

File → URL table: [reference.md](reference.md)

## Phase 1: Page + layout

**Build:** New route with shared layout (nav, title).

**Teach:** **file-based routing** — `app/todos/page.tsx` → `/todos`

**Term:** route or layout

**Anchor:** `app/.../page.tsx:1`

## Phase 2: Client boundary

**Build:** Add click/state to a server page by extracting client child or adding `'use client'`.

**Teach:** Server = fast, secrets safe, no hooks. Client = clicks, state, browser APIs.

**Seasoned decision:** Document split in `.devlearn/decisions.md` — what stays server vs client.

**Smell:** Entire page `'use client'` — teach narrowing (curious+)

## Phase 3: Data fetching

Pick pattern matching task:

| Pattern | Teach when | Handoff |
|---------|------------|---------|
| `fetch` in Server Component | Read-only data on first paint | this skill |
| `route.ts` handler | Client mutations, mobile app callers | devlearn-apis |
| Server Action | Form post without manual REST (deep) | reference.md |

Link HTTP verbs/status to apis skill — don't duplicate full REST lesson.

## Phase 4: Environment variables

**Teach:**

- Server: `process.env.SECRET` — never exposed to browser
- Client: `NEXT_PUBLIC_*` only for safe values
- Restart dev server after `.env` change

**Security:** `/devlearn-security` if API keys discussed

## Phase 5: Deploy path (when user asks)

Next often deploys to Vercel — hand off **devlearn-deploy** with framework preset note.

Post-live: **devlearn-post-ship** smoke on production URL.

## Persona integration

| Persona | Emphasis |
|---------|----------|
| viber | File = URL; when to click `'use client'` |
| seasoned | Boundary decisions, caching, ISR only if in scope |
| autodetect | Skip Server Actions unless user mentions forms |

## Common mistakes

| Smell | Fix | Teach |
|-------|-----|-------|
| useState in server file | `'use client'` or split component | boundary |
| fetch in client for static read | Server Component fetch | waterfall/ bundle |
| API URL hardcoded | env var | config |
| Hydration error | Client-only API in SSR output | mismatch |
| Wrong export in route.ts | Named HTTP exports | route handler |

## Lesson integration

One concept per batch — routing OR client boundary OR env, not all three in vibe mode.

## Lifecycle handoffs

| Situation | Suggest |
|-----------|---------|
| Auth on routes | `/devlearn-security` |
| CI for Next build | `/devlearn-devops` |
| Release | `/devlearn-pre-ship` → `/devlearn-deploy` |
| Live URL check | `/devlearn-post-ship` |

## STOP checkpoint

> "Should this file be a Server or Client Component — does it need clicks or browser-only APIs?"

## Required footer

```markdown
---
DevLearn status: DONE
Next patterns: [routing|client|data|env]
Suggested next: /devlearn-apis | /devlearn-deploy | /devlearn-security
---
```

## Additional resources

- File map & route handler sample → [reference.md](reference.md)
- React fundamentals → `devlearn-react`
- [Next.js App Router docs](https://nextjs.org/docs/app)
