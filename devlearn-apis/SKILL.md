---
name: devlearn-apis
description: |
  Teaches APIs, REST, JSON, env vars, auth basics, and error handling while
  wiring real client-server or localStorage persistence. Use when the user wants
  to save data, fetch from a server, login, fix CORS, or curriculum routes here.
  Proactively suggest when adding fetch, routes, .env, or API handlers and
  DEVLEARN.md is enabled.
---

# DevLearn: APIs

## Iron law

**Teach without blocking ship.** Get data flowing end-to-end; explain the request/response story at each layer.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Viber → lesson-block. Seasoned → decision-block for auth architecture, CORS proxy choice, session vs JWT.

## Context

An **API** is how programs talk across a boundary (browser ↔ server, app ↔ database). Vibe coders hit **CORS**, **404**, and "where did my data go" — teach the mental model, not HTTP RFC numbers.

## Prerequisites

- devlearn-javascript (DOM + fetch preview) or equivalent
- Optional: simple static page to wire up

## Before you start

1. DEVLEARN.md depth (default **curious**; **deep** for auth)
2. Step 0: localStorage only vs real backend? framework (Express, Next route handlers)?
3. Never commit secrets — teach `.env` + `.env.example`

## Phase 0: Persistence ladder (pick one)

| Level | Teach when | User gets |
|-------|------------|-----------|
| **localStorage** | Fastest save across refresh | Data on one browser |
| **REST API** | Share data / multi-device | Server owns truth |
| **Auth** | Private per-user data | Sessions/tokens |

Start at user's requested level; mention ladder in one sentence.

## Phase 1: REST mental model

**Teach before coding:**

```
Client  --HTTP request-->  Server
        <--HTTP response--
```

| Method | Plain English | Todo example |
|--------|---------------|--------------|
| GET | Read list | GET /api/todos |
| POST | Create | POST /api/todos { text } |
| PUT/PATCH | Update | PATCH /api/todos/:id |
| DELETE | Remove | DELETE /api/todos/:id |

**Term:** **endpoint** — URL + method that does one job

**Term:** **JSON** — text format for `{ "text": "Buy milk" }`

## Phase 2: Server route (minimal)

**Build:** One route returning JSON (framework-appropriate).

Example shape (adapt to stack):

```javascript
// GET /api/todos → [{ id, text }]
// POST /api/todos body { text } → created todo
```

**Teach:** Server reads request, touches data store, sends JSON response.

**Anchor:** route file:line

## Phase 3: Client fetch

**Build:** `fetch` calls matching server routes; update JS state + render.

```javascript
const res = await fetch('/api/todos', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ text }),
});
```

**Teach:** headers tell server body format; body is stringified JSON.

**Terms:** **request**, **response**, **status code** (200 ok, 404 missing, 500 server broke)

## Phase 4: Environment variables

**Build:** `.env.example` with `API_URL` or `DATABASE_URL`; read via platform pattern.

**Teach:** Secrets and URLs differ local vs production; **never** commit `.env`.

**Term:** **environment variable**

## Phase 5: Errors & CORS

**When browser blocks cross-origin:**

**Teach CORS in one paragraph:** Browser protects you — page at `a.com` can't read `b.com` unless `b.com` sends allow headers. Fix: same origin, proxy, or server CORS config — pick simplest for stack.

**Build:** User-visible error message on failed fetch; log status in console.

**STOP if CORS:** explain origin mismatch before random header spam.

## Phase 6: Auth preview (deep / on request)

**Teach layers:**

| Layer | Plain English |
|-------|---------------|
| Session cookie | Browser sends cookie; server knows who you are |
| JWT | Signed token in header |
| API key | Secret for server-to-server (not in frontend!) |

**Rule:** Don't put long-lived secrets in frontend code.

Hand off production hardening to **devlearn-security** before ship.

## Lifecycle handoffs

| Situation | Suggest |
|-----------|---------|
| Auth added | `/devlearn-security` |
| Ready to release | `/devlearn-pre-ship` |
| Live API URL | `/devlearn-post-ship` smoke on endpoints |
| CORS recurring | document origin decision in `.devlearn/decisions.md` |

## Domain glossary

| Term | Definition |
|------|------------|
| API | Interface for programs to request data/actions |
| REST | Style using URLs + HTTP methods |
| JSON | Text format for objects/arrays |
| endpoint | URL + method for one operation |
| CORS | Browser cross-origin security gate |
| env var | Config from environment not source code |
| status code | Number summarizing response result |
| header | Request/response metadata key-value |
| payload | Body data sent or received |

## Common mistakes

| Mistake | Symptom | Fix |
|---------|---------|-----|
| API key in frontend | Stolen key | Server-side only |
| No Content-Type | Server can't parse body | application/json |
| Wrong URL | 404 | Match route path + method |
| CORS panic | Blocked in console | Same origin or server headers |
| Swallow errors | Blank UI | Show message + log status |

## STOP checkpoint

After first successful POST:

> "Where does the todo live now — browser memory, localStorage, or server database?"

Wrong answer → one-sentence correction with diagram.

## Lesson integration

Teach **one network concept per lesson block** in vibe mode (CORS gets its own block when it happens).

## Required footer

```markdown
---
DevLearn status: DONE
Persistence level: [localStorage|REST|auth]
Suggested next: /devlearn-deploy | /devlearn-explain-diff
---
```

## Additional resources

- Request/response examples → [reference.md](reference.md)
- Client patterns → devlearn-javascript/examples.md
