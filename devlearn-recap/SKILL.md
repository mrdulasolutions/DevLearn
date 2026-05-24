---
name: devlearn-recap
description: |
  Produces a 60-second session recap from DEVLEARN_GLOSSARY.md, .devlearn/progress.md,
  decisions log, and recent lesson blocks. Use when user says "what did I learn",
  "recap", "catch me up", end of long session, or before starting a new day. Updates
  progress Last session when done. Voice triggers: "session summary", "what we covered".
---

# DevLearn: Recap

## Iron law

**Recap is short.** Never block shipping. Summarize; don't re-teach entire lessons.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Format: [../shared/session-recap.md](../shared/session-recap.md).

## Context

Long vibe sessions blur together. Recap gives **memory anchors**: terms, files touched, decisions, and one next step — without repeating full lesson blocks.

Ambient skill (`devlearn-teach-while-coding`) may append to progress during work; this skill **consolidates** at session end or on demand.

## Prerequisites

Optional but richer when present:

- `DEVLEARN.md` with `progress: true` and/or `glossary: true`
- `.devlearn/progress.md`, `DEVLEARN_GLOSSARY.md`, `.devlearn/decisions.md`

If nothing exists, recap from **conversation only** and offer `/devlearn-onboard`.

## Before you start

1. Parse `DEVLEARN.md` for persona and depth
2. Read artifacts (skip missing files gracefully)
3. Scan recent conversation for lesson/decision blocks (last ~20 substantive turns)

## Phase 1: Gather sources

| Source | Extract |
|--------|---------|
| `.devlearn/progress.md` | Last session, concepts table |
| `DEVLEARN_GLOSSARY.md` | Newest or most-referenced terms |
| `.devlearn/decisions.md` | Last 1–3 decisions (seasoned) |
| Conversation | Lesson blocks not yet in files |
| Git (optional) | `git log -5 --oneline` for "what shipped" |

## Phase 2: Build recap

Use template from session-recap.md. Line limits:

| Depth | Max lines |
|-------|-----------|
| vibe | ≤15 |
| curious | ≤22 |
| deep | ≤30 |

### Required sections

```markdown
## Session recap (60 seconds)

**We worked on:** [one sentence user outcome]

**Key terms:** [3–5 with half-line definitions]

**Files / areas touched:** [bullet list, max 5]

**Decisions** (seasoned or if any): [one line each]

**Try next:** [one concrete action — run app, one term quiz, or next skill]

**Suggested next session:** `/devlearn-[skill]` or [feature to continue]
```

## Phase 3: Persona tuning

| Persona | Emphasize | De-emphasize |
|---------|-----------|--------------|
| viber | Top 3 terms + one try-it-yourself | ADR detail |
| seasoned | Top decisions + verify/rollback | long What/Why |
| autodetect | Blend from message tone | — |

**Viber add-on (curious+):** one "quiz" question on a term — optional, skip if user said "just ship"

**Seasoned add-on:** "What would you verify before merging this?"

## Phase 4: Update progress

If `progress: true` and `.devlearn/progress.md` exists:

- Refresh **Last session** with date + one-line summary
- Append new concepts not already in table (dedupe by name)

Do not rewrite entire history.

## Phase 5: Handoffs

| Situation | Suggest |
|-----------|---------|
| User forgot a term | `/devlearn-glossary` define [term] |
| Large diff since recap start | `/devlearn-explain-diff` |
| Ready to release today | `/devlearn-pre-ship` |
| End of week | `/devlearn-curriculum-router` for next path |

## Common mistakes

| Smell | Fix |
|-------|-----|
| Recap repeats full lessons | Compress to terms + anchors |
| No artifacts, empty recap | Mine conversation; offer onboard |
| 50-line recap | Cut to depth limit |

## STOP checkpoint

End with **one** question:

> "Zoom into one term, see the diff story, or keep building?"

## Required footer

```markdown
---
DevLearn status: DONE
Recap lines: N
Progress updated: yes | no | n/a
Suggested next: /devlearn-curriculum-router | keep building | /devlearn-glossary
---
```

## Additional resources

- Recap format → [../shared/session-recap.md](../shared/session-recap.md)
- Rubric for lesson quality → `devlearn-lesson-review`
- Full path planning → `devlearn-curriculum-router`
