# DevLearn Next.js — reference

## File → URL (App Router)

| Path | URL |
|------|-----|
| `app/page.tsx` | `/` |
| `app/about/page.tsx` | `/about` |
| `app/blog/[slug]/page.tsx` | `/blog/hello-world` |
| `app/api/todos/route.ts` | `/api/todos` |
| `app/layout.tsx` | Wraps all routes in segment |

## Server vs client (teaching script)

> Server Components run on the server first — good for reading a database, hiding secrets, and sending HTML fast. Client Components run in the browser — needed for `useState`, `onClick`, and browser APIs. In the App Router, **server is the default**; add `'use client'` only at the top of files that need interactivity.

## Minimal route handler

```typescript
// app/api/todos/route.ts
import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json([{ id: '1', text: 'Learn Next' }]);
}

export async function POST(request: Request) {
  const body = await request.json();
  // validate, save...
  return NextResponse.json({ id: '2', text: body.text }, { status: 201 });
}
```

Teach: same origin as site → often **no CORS** for browser fetches to `/api/...`

## Client component minimal

```tsx
'use client';

import { useState } from 'react';

export function Counter() {
  const [n, setN] = useState(0);
  return <button onClick={() => setN(n + 1)}>{n}</button>;
}
```

Import into server `page.tsx` — page stays server, counter client.

## Server Component fetch (read)

```tsx
// app/todos/page.tsx — server by default
async function getTodos() {
  const res = await fetch('https://...', { cache: 'no-store' });
  return res.json();
}

export default async function TodosPage() {
  const todos = await getTodos();
  return <ul>{todos.map(...)}</ul>;
}
```

**Seasoned note:** caching defaults changed across Next versions — match project docs.

## Environment variables

| Variable | Visible to browser? |
|----------|---------------------|
| `DATABASE_URL` | No (server only) |
| `NEXT_PUBLIC_API_URL` | Yes |

`.env.local` for secrets — in `.gitignore`. Teach `.env.example` without values.

## Server Actions (deep)

```tsx
'use server';
export async function addTodo(formData: FormData) {
  const text = formData.get('text');
  // save...
}
```

Use when user wants form submit without writing fetch — optional advanced topic.

## Legacy `pages/` router

If project uses `pages/` only:

- Note App Router is current default for new work
- Teach `pages/api/*` for APIs, `pages/*.tsx` for routes
- Suggest migration only when user asks

## Deploy notes

| Platform | Teach |
|----------|-------|
| Vercel | Git connect, env in dashboard, preview URLs |
| Node host | `next build` + `next start` — link devlearn-deploy |
| Docker | devlearn-devops |

## Common Next + React errors

See devlearn-debugging reference — hydration, dynamic server, module not found.

## Docs

- [Next.js App Router](https://nextjs.org/docs/app)
- [Server and Client Components](https://nextjs.org/docs/app/building-your-application/rendering/server-components)
- [Route Handlers](https://nextjs.org/docs/app/building-your-application/routing/route-handlers)
