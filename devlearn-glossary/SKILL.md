---
name: devlearn-glossary
description: |
  Maintains and explains a running session glossary of dev terms tied to the user's
  project. Use when user asks "what terms did we cover", "define X", "what does that
  mean in our app", quiz on terms, or to merge Term of the moment entries from ambient
  lessons. Works with DEVLEARN.md when glossary true. Pairs with devlearn-teach-while-coding,
  devlearn-recap, and all topic skills. Voice triggers: "glossary", "define", "what does X mean".
---

# DevLearn: Glossary

## Iron law

**Teach without blocking ship.** Glossary work is additive; don't block feature work unless user asks to pause.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Definitions must use plain language and tie to **this project**, not Wikipedia abstracts.

## Context

Scattered terms across a session become **forgettable jargon**. The glossary is a living index: what the word means **here**, where it appears in **your repo**, and pointers for review before ship or recap.

## Prerequisites

- Optional: `DEVLEARN.md` with `glossary: true`
- Ambient lessons from `devlearn-teach-while-coding` supply **Term of the moment** entries

## Before you start

1. Resolve artifact path (see below)
2. Read DEVLEARN.md persona — viber gets analogies; seasoned gets precise + tradeoff one-liner
3. If term unknown to project, say "not used yet — we discussed it for…"

## Artifact location

| Priority | Path |
|----------|------|
| Default | `DEVLEARN_GLOSSARY.md` (project root) |
| Alternative | `.devlearn/glossary.md` if user prefers hidden |

Create file if missing when `glossary: true` or user invokes this skill.

Template: [glossary-template.md](glossary-template.md)

## Table format

| Term | Definition | Where we used it | Reference |
|------|------------|------------------|-----------|
| CORS | Browser rule blocking some cross-site requests | Todo fetch to other domain | `app.js:88`, apis lesson |

Sort alphabetically by Term (optional user preference).

## Workflow modes

### Mode A: Merge from session (ambient companion)

1. Scan recent lesson/decision blocks for **Term of the moment**
2. For each term: new → append row; exists → extend Reference with new file:line
3. Dedupe case-insensitive Term column
4. Report: "Added N terms, updated M existing"

Run after large sessions or when user invokes `/devlearn-recap`.

### Mode B: Define one term (explicit)

User: "What is CORS?" / "Define localStorage in our app"

1. Re-ground: one sentence on current project
2. Plain definition (2–3 sentences max)
3. Where **this repo** uses it (file:line or "not used yet")
4. Optional analogy (one line, viber)
5. Append or update glossary row
6. Emit mini lesson-block if depth ≥ curious

### Mode C: Review all terms (explicit)

User: "What have we covered?"

1. Read full glossary
2. Present **5 most important for next step** + link to full file
3. Ask which term to zoom into (one at a time)

### Mode D: Quiz (optional, curious)

One plain-language question on one term. Not a graded exam. Skip if "just ship".

## Definition quality rules

| Rule | Bad | Good |
|------|-----|------|
| No circular | "JWT is a JSON Web Token" | "JWT is a signed string the client sends so the server knows who you are without storing session in memory" |
| Project anchor | Generic HTTP definition only | "Our `/api/todos` route returns JSON" |
| Feel first | "DOM implements the HTML standard…" | "The DOM is the live tree of your page the browser lets JS change" |
| Length | Paragraph | 2–3 sentences + anchor |

## Persona integration

| Persona | Definition shape |
|---------|-------------------|
| viber | Analogy + where in app |
| seasoned | Precise + caveat/tradeoff one line |
| autodetect | Match last lesson style |

## Integration with other skills

| Skill | Glossary role |
|-------|---------------|
| teach-while-coding | Supplies terms each lesson |
| explain-diff | "Terms introduced" per group → merge |
| recap | Top terms summary |
| topic skills | Domain terms (props, CORS, CI) |
| pre-ship | Teach term for failed check |

## STOP checkpoint

After adding **3+** terms in one pass:

> "Want a 30-second quiz on one term, or keep building?"

Skip quiz if user said "just ship".

## Common mistakes

| Smell | Fix |
|-------|-----|
| Encyclopedia definitions | Tie to project file or planned use |
| Duplicate rows | Merge Reference column |
| Glossary without file | Create on first term |

## Required footer

```markdown
---
DevLearn status: DONE
Glossary path: DEVLEARN_GLOSSARY.md
Terms total: N
Added/updated: N
Suggested next: /devlearn-recap | /devlearn-curriculum-router | back to building
---
```

## Additional resources

- Table template → [glossary-template.md](glossary-template.md)
- Term sources → `devlearn-teach-while-coding`, `devlearn-explain-diff`
- Session summary → `devlearn-recap`
