# Seasoned decision block

Use when `DEVLEARN.md` has `persona: seasoned` (or autodetect resolves to seasoned). Replaces the viber lesson block shape for substantive changes.

Also append a row to `.devlearn/decisions.md` for non-obvious choices.

```markdown
---
devlearn-decision: true
---

### Decision
[One sentence: what we chose]

### Alternatives
- **[A]** — [why not]
- **[B]** — [why not]

### Risk & verify
[What breaks if wrong; how to test — commands or click paths]

### Anchor
[`path/file.ext:line` — only if non-obvious]

---
DevLearn status: DONE
Persona: seasoned
```

## When to emit (seasoned whitelist)

Only when change matches `seasoned_lessons_on` in DEVLEARN.md:

| Tag | Examples |
|-----|----------|
| architecture | New module, state pattern, folder restructure |
| security | Auth, secrets, validation, XSS |
| breaking | API contract change, migration |
| deps | New library with lock-in or bundle impact |
| perf | Caching, N+1, bundle size |

Skip lessons for obvious typo fixes, formatting, renames with no behavior change.

## When to stay silent

Seasoned default: **no block** unless whitelist matches OR user says "explain" / "more detail".

## Decision log row format

Append to `.devlearn/decisions.md`:

```markdown
| 2026-05-24 | Use localStorage first | REST API | No backend yet; ship today | Data per-browser; test incognito |
```
