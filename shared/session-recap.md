# Session recap format

Used by `devlearn-recap` and session openers in `devlearn-teach-while-coding`.

## Session opener (when `.devlearn/progress.md` exists)

Before substantive work, optional 2–3 sentences:

```markdown
**Welcome back.** Last session: [date] — [what you built]. Picking up: [current task].
Concept to build on: **[term]** ([one line]).
```

Skip opener if user said "just ship" or persona is seasoned (unless they ask).

## Recap block (`/devlearn-recap`)

```markdown
## DevLearn recap — [project name]

**Sessions:** [count or date range]
**Persona / depth:** [viber|seasoned] / [vibe|curious|deep]

### You learned
1. **[term]** — [one line]
2. ...

### Decisions worth remembering
- [from .devlearn/decisions.md if present]

### Suggested next
- [one skill or one feature to build]

**Stretch:** [optional one line]
```

Keep under 15 lines for vibe; up to 30 for deep recap.

## Progress file updates

After substantive session, append to `.devlearn/progress.md` **Concepts covered** table and refresh **Last session**.
