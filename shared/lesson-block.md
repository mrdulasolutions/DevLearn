# Canonical lesson block

Emit this shape after substantive work when DevLearn is enabled. Adapt section length to depth mode (see `depth-levels.md`).

```markdown
---
devlearn-lesson: true
---

### What changed
[1–2 sentences. No jargon on first pass. What can the user see or do now?]

### Why we did it
[Mechanism + tradeoff. Why this way instead of the obvious shortcut?]

### How it works
[`path/to/file.ext:line` — one sentence tying the code to the behavior]

### Term of the moment
**[term]**: [One-line definition tied to this specific change]

### Try it yourself
[One tiny action: run a command, open a path, change one line, or click something in the UI]

---
Status: DONE
```

## Depth adjustments

| Section | vibe | curious | deep |
|---------|------|---------|------|
| What changed | 1 sentence | 1–2 sentences | 2 sentences |
| Why we did it | 1 sentence | 2–3 sentences | paragraph + tradeoff |
| How it works | 1 file:line | 1–2 anchors | 2–3 anchors + data flow |
| Term of the moment | always | always | always + link to glossary |
| Try it yourself | omit | include | include + stretch goal |

## When glossary is enabled

Append the **Term of the moment** to `DEVLEARN_GLOSSARY.md` (or `.devlearn/glossary.md`). Do not duplicate terms.

## Persona selection

| DEVLEARN.md `persona` | Template |
|-----------------------|----------|
| viber | This file (lesson-block.md) |
| seasoned | [decision-block.md](decision-block.md) |
| autodetect | Pick using [depth-levels.md](depth-levels.md) autodetect table |

Self-check against [lesson-rubric.md](lesson-rubric.md) before emitting.

## Status values

- `DONE` — work shipped and lesson emitted
- `LESSON_SKIPPED` — user said "just ship" or change was trivial
- `BLOCKED` — cannot teach accurately without missing context; say what's missing
