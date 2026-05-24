# DevLearn lesson review — reference

## Rubric quick reference

### Viber lesson (lesson-block.md)

1. Opens with **what changed** in user-visible terms
2. **Why** in one mechanism (not history lecture)
3. **How** with ≥1 `path:line` anchor
4. **Term of the moment** — max one for vibe; optional for curious
5. Length: vibe ≤12 lines, curious ≤18, deep ≤25
6. No blocking questions unless user asked to pause

### Seasoned decision (decision-block.md)

1. **Decision** names the choice made
2. **Alternatives** lists ≥1 real option not taken
3. **Risk & verify** — how it breaks + how to check
4. **Anchor** only if non-obvious file
5. Append-worthy for `.devlearn/decisions.md` when non-obvious

## Compression techniques (too long)

| Cut | Keep |
|-----|------|
| Merge Why into What | One mechanism |
| Drop second anchor | Strongest file:line |
| Move extra terms to glossary offer | One term in block |
| Remove try-it in vibe | Add in curious rewrite |

## Expansion techniques (too basic for seasoned)

| Add | Example |
|-----|---------|
| Alternatives | "Could use session cookie vs JWT" |
| Risk | "Token in localStorage → XSS steals session" |
| Verify | "curl -H Authorization …" or test name |

## Example scorecard + revision

**Original (fail):** 20-line vibe block, three terms, no anchors.

**Scorecard:** Length ❌, Terms ❌, Anchors ❌

**Revised:**

```markdown
### What changed
Todos survive refresh — we save the list to the browser's storage when you add or delete.

### Why
The page reload wipes normal variables; localStorage keeps data on your machine between visits.

### How
- `app.js:42` — `localStorage.setItem('todos', JSON.stringify(todos))` on every save

### Term of the moment
**localStorage** — a built-in browser key-value store for strings (we store JSON text).
```

## When to escalate to code fix

| Lesson says | Reality | Action |
|-------------|---------|--------|
| "Saves on click" | Saves on submit only | Fix handler; revise lesson |
| "Secure auth" | Password in plain text | Fix + security skill |
| "CORS fixed" | Still blocked | debugging/apis skill |

## Handoff to meta skill

User happy with revision → ambient skill should match new style for rest of session (shorter vibe blocks, etc.).
