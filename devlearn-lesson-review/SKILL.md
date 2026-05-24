---
name: devlearn-lesson-review
description: |
  Meta-QA: reviews the last DevLearn lesson or decision block against the lesson
  rubric and suggests a tighter rewrite. Use when user says lesson was too long,
  too basic, jargon-heavy, missing tradeoffs, or "review that explanation". Does
  not re-do code unless the explanation was factually wrong. Voice triggers:
  "too much detail", "dumb it down", "PR review style".
---

# DevLearn: Lesson Review

## Iron law

**Improve the explanation; don't re-do the code** unless the lesson was wrong about behavior.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Feedback is direct and actionable — like a friendly editor, not a grade.

## Context

Ambient and topic skills emit lesson/decision blocks. Users sometimes want **tighter**, **deeper**, or **different persona** without repeating the whole task.

This skill scores the last block against [../shared/lesson-rubric.md](../shared/lesson-rubric.md) and outputs a **revised block** in the correct template.

## Prerequisites

- A lesson or decision block in recent conversation (last 5–10 turns)
- Optional: `DEVLEARN.md` for target persona/depth

## Before you start

1. Identify **which block** to review (quote first line or "last lesson")
2. Read target persona from DEVLEARN.md or user complaint
3. If user said "wrong" about code behavior → fix code first, then revise lesson

## Phase 1: Score against rubric

Evaluate pass/fail per row in lesson-rubric.md:

| Rubric row | Fail signal |
|------------|-------------|
| Grounded in project | Generic Wikipedia tone |
| Plain language first | Jargon before meaning |
| File:line anchors | No where in code |
| Right length for depth | vibe block >12 lines |
| One term max (vibe) | Term dump |
| Try-it (curious+) | Missing hands-on nudge |
| Tradeoff (seasoned) | Decision without alternatives |

Output compact scorecard:

```markdown
## Lesson review scorecard

| Criterion | Pass | Note |
|-----------|------|------|
| ... | ✅/❌ | one line |
```

## Phase 2: Diagnose from complaint

| User complaint | Fix strategy |
|----------------|--------------|
| Too long | vibe compression; merge Why into What |
| Too basic (seasoned) | Rewrite as decision-block |
| Too jargon-heavy | feel-first sentence; term after |
| Missing tradeoff | add Alternatives + Risk |
| Wrong persona | swap template entirely |
| Factually wrong | correct fact; note in "What changed" |

## Phase 3: Emit revised block

Use exact templates:

- Viber → [../shared/lesson-block.md](../shared/lesson-block.md)
- Seasoned → [../shared/decision-block.md](../shared/decision-block.md)

Prefix with:

```markdown
## Revised lesson

**Changes:** [shorter | less jargon | added tradeoff | persona switch]

[full block here]
```

## Phase 4: Optional meta feedback

One sentence for **future** ambient behavior (don't lecture):

> "Next time I'll keep vibe blocks under 10 lines and one term."

## Persona targets

| Target | Revised block must include |
|--------|---------------------------|
| viber + vibe | What, Why, How (1–2 anchors), optional 1 term |
| viber + curious | + try-it-yourself line |
| seasoned | Decision, Alternatives, Risk & verify |
| autodetect | Match complaint unless DEVLEARN.md says otherwise |

## Common mistakes

| Smell | Fix |
|-------|-----|
| Review re-implements feature | Only rewrite explanation |
| Scorecard without revision | Always output revised block |
| Revised block still fails rubric | Iterate once internally |

## STOP checkpoint

Ask **one** question:

> "Use this revised block going forward, or want another pass (shorter / more technical)?"

## Required footer

```markdown
---
DevLearn status: DONE
Block type: lesson | decision
Rubric fails fixed: N
Suggested next: keep building | /devlearn-recap
---
```

## Additional resources

- Rubric → [../shared/lesson-rubric.md](../shared/lesson-rubric.md)
- Templates → lesson-block.md, decision-block.md
- Ambient emitter → `devlearn-teach-while-coding`
