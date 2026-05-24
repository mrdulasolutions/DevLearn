# DevLearn debugging — reference

## DevTools checklist (teach once per session)

1. **Console** — red errors first; click stack to jump to line
2. **Network** — filter Fetch/XHR; status column (404, 500, CORS)
3. **Sources** — breakpoint on suspect line; reload to pause

**Viber script:** "Open DevTools (right-click → Inspect → Console). The red line is the computer's complaint."

## Stack trace reading

```
TypeError: Cannot read properties of undefined (reading 'map')
    at TodoList (TodoList.tsx:12:18)
    at renderWithHooks (react-dom.development.js:...)
```

- **Top frame** = where it exploded (`TodoList.tsx:12`)
- Scan down for **your** paths; ignore `node_modules` unless dependency bug
- Line:column → open file at that line

## Common fixes by file type

| File type | Check first |
|-----------|-------------|
| `.jsx/.tsx` | Default export? Hook at top level? `'use client'` if useState |
| `route.ts` / API | HTTP method export (`GET`, `POST`); URL path |
| `.env` | Name matches code; restart dev server after change |
| `layout.tsx` | Children rendered? Client/server boundary |
| CSS "broken" | Often JS error stopped render — check console |

## Framework-specific smells

### React

| Error | Fix direction |
|-------|---------------|
| Invalid hook call | Hook outside component or conditional |
| Maximum update depth | setState during render |
| Key warning | Stable key in list map |

### Next.js

| Error | Fix direction |
|-------|---------------|
| Hydration failed | Client-only API in server component |
| Dynamic server usage | `'use client'` or move fetch server-side |
| Module not found in app/ | Wrong relative import |

## Network errors (teach with apis skill)

| Status | Meaning | Next step |
|--------|---------|-----------|
| 404 | URL or route wrong | Compare fetch URL to server route |
| 401/403 | Auth | Headers, cookies, env |
| 500 | Server threw | Server logs / terminal |
| CORS | Browser blocked cross-origin | Same-origin proxy or server CORS headers |
| Failed to fetch | Network down or CORS | Network tab detail |

## Seasoned debug decision block

When fix is non-obvious:

```markdown
### Decision
Add null guard before `.map` instead of refactoring data loader.

### Alternatives
- Fix upstream API to never return null
- Default to `[]` at fetch boundary

### Risk & verify
Empty state hides API bug — add test "renders empty list when API returns []".
Run: `npm test TodoList`
```

## Test failures

| Pattern | Teach |
|---------|-------|
| Snapshot mismatch | UI changed — update snapshot intentionally or fix regression |
| Cannot find module | Mock path or install devDep |
| Timeout | Missing `await` or fake timers |

## Production debugging handoff

Don't debug prod without post-ship context:

- Get URL, time, commit SHA
- Reproduce in incognito
- Check host logs
- Rollback if users blocked → `/devlearn-post-ship`

## Glossary terms to offer

undefined, null, stack trace, breakpoint, regression, CORS, status code, hydration, promise rejection
