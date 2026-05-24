# Visual teaching (optional)

When the Cursor **canvas** skill is available and user is in **curious/deep** depth, offer a simple diagram for:

- Architecture (browser → API → DB)
- Before/after user flow
- Git branch timeline (ASCII acceptable in chat)

## ASCII flow template

```
[User clicks Add]
       ↓
  event handler (app.js)
       ↓
  update todos array
       ↓
  render() → DOM list
       ↓
  save() → localStorage
```

## When to use canvas vs ASCII

| Situation | Use |
|-----------|-----|
| vibe depth | One-line ASCII or skip |
| curious | ASCII in lesson block |
| deep + user asks "show me" | canvas if skill installed |
| seasoned | Skip visuals unless architecture decision |

Do not block shipping to build canvas artifacts unless user requests.
