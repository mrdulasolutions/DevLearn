# DevLearn security — examples

## Example viber lesson (API key in frontend)

```markdown
### What could go wrong
Anyone can open your site's JavaScript and copy the API key — then use your paid API as if they were you.

### What we changed
Moved the fetch to a server route so the key stays on the server only.

### How
- `app/api/todos/route.ts:1` — server reads `process.env.API_KEY`
- Removed key from `app.js`

### Term of the moment
**Secret** — a password-like string that must never ship in browser code or git.
```

## Example seasoned decision (session vs JWT)

```markdown
### Decision
Use httpOnly session cookie for web app auth.

### Alternatives
- JWT in localStorage — simpler SPA, XSS steals token
- JWT in httpOnly cookie — hybrid; more moving parts

### Risk & verify
CSRF on cookie auth — use SameSite=Lax + CSRF token on mutating routes.
Verify: logged-out user gets 401 on POST /api/todos.
```

## Triage-only output (quick pass)

```markdown
## Security triage

| Area | Status |
|------|--------|
| Secrets in repo | ✅ clean |
| Auth on /admin | ❌ missing |
| XSS (innerHTML) | ✅ none found |
| npm audit high | ⚠ 1 — lodash (fix available) |

**Top action:** Protect `/admin` before merge.
```

## When to invoke proactively

- Diff adds `process.env` usage in client component
- New login/signup routes
- User input rendered to HTML
- New GitHub Action with hardcoded token
