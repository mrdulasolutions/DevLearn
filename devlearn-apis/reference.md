# devlearn-apis — reference

## HTTP status codes (teaching subset)

| Code | Meaning | Tell user |
|------|---------|-----------|
| 200 | OK | It worked |
| 201 | Created | New resource made |
| 400 | Bad request | Sent invalid data |
| 401 | Unauthorized | Need login |
| 403 | Forbidden | Logged in but not allowed |
| 404 | Not found | Wrong URL or missing id |
| 500 | Server error | Bug on server — check logs |

## JSON rules quick

- Keys in double quotes
- No trailing commas (strict JSON)
- `JSON.stringify(obj)` → string for wire
- `JSON.parse(string)` → object in code

## Express-style minimal routes (teaching)

```javascript
app.get('/api/todos', (req, res) => {
  res.json(todos);
});

app.post('/api/todos', (req, res) => {
  const { text } = req.body;
  const todo = { id: crypto.randomUUID(), text };
  todos.push(todo);
  res.status(201).json(todo);
});
```

Adapt paths to Next.js route handlers, Fastify, etc. — teach pattern not framework wars.

## Next.js App Router handler sketch

```javascript
// app/api/todos/route.js
export async function GET() {
  return Response.json(todos);
}

export async function POST(request) {
  const { text } = await request.json();
  // ...
  return Response.json(todo, { status: 201 });
}
```

## .env pattern

```bash
# .env.example (committed)
DATABASE_URL=
API_SECRET=

# .env (gitignored)
DATABASE_URL=postgres://...
```

Teach: example documents keys; real values local only.

## CORS minimal explanation script

> Your page runs on `http://localhost:5173`. API runs on `http://localhost:3000`. Different ports = different **origins**. Browser blocks the response unless the API says `Access-Control-Allow-Origin` for your page (or you proxy through same origin).

## localStorage vs API decision table

| Need | Pick |
|------|------|
| Solo demo, one browser | localStorage |
| Share link with friends' data | API + deploy |
| Accounts | API + auth |

## curl for teaching (deep)

```bash
curl -s http://localhost:3000/api/todos | jq
curl -s -X POST http://localhost:3000/api/todos \
  -H 'Content-Type: application/json' \
  -d '{"text":"Learn APIs"}'
```

Shows API without browser UI.

## Security one-liners

- Validate input on server (never trust client)
- Rate limit public APIs in production
- Hash passwords; never store plain text
- HTTPS in production (deploy skill)
