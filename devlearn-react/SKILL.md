---
name: devlearn-react
description: |
  Teaches React while building components: JSX, props, state, effects, lists/keys,
  and when not to useEffect. Use when project uses React, user asks about components,
  hooks, props, state, or DEVLEARN.md stack is react/next. Proactively suggest for
  .jsx/.tsx edits. Pairs with devlearn-javascript (fundamentals), devlearn-next
  (App Router), devlearn-apis (client fetch). Voice triggers: "react component",
  "useState", "hooks".
---

# DevLearn: React

## Iron law

**Teach without blocking ship.** Ship the component; explain the model.

## Voice + blocks

Follow [../shared/voice.md](../shared/voice.md). Viber → lesson-block. Seasoned → decision-block for state architecture, context vs composition, effect boundaries.

## Context

React is **UI as functions of state**. Vibers confuse props vs state, over-use `useEffect`, and miss **keys** in lists. Teach the minimum mental model to ship features safely.

## Prerequisites

- devlearn-javascript (DOM, events, arrays, async basics)
- For Next.js projects, also use devlearn-next for server/client split

## Before you start

1. Read DEVLEARN.md: `stack`, `persona`, `depth`
2. Step 0: detect patterns — hooks only? UI library (MUI, shadcn)? TypeScript?
3. Read one existing component for naming/style match

## Core mental model

| Concept | Plain English |
|---------|---------------|
| Component | Reusable UI function that returns JSX |
| JSX | HTML-like syntax compiled to JS function calls |
| props | Inputs from parent — read-only in child |
| state | Data that changes over time inside component |
| re-render | React redraws when props or state change |
| effect | Sync with outside world — use sparingly |

## Phase 1: Component structure

**Build:** Presentational component with props (e.g. `TodoItem { text, done }`).

**Teach:** **props down** — parent owns data, child displays.

**Term:** component or props

**Anchor:** `ComponentName.tsx:line`

## Phase 2: State & events

**Build:** Interactive piece — toggle, controlled input, add-to-list.

**Teach:** `useState` → event handler → state update → re-render.

**Smell:** Duplicated state in siblings → **lift state up** (curious+)

**Try it (curious):** "Change initial state — what appears on screen?"

## Phase 3: Lists & keys

**Build:** Map array to components.

**Teach:** **key** prop — stable id, not index when list reorders/deletes.

**Common bug:** Using index key → wrong row updates — demo in lesson if bug appeared.

## Phase 4: Effects (curious/deep only)

**When:** fetch on mount, subscribe to external store, sync non-React widget.

**Teach:** **Don't effect what render can compute** — see [reference.md](reference.md) "When NOT to useEffect"

**Seasoned decision:** useEffect vs event handler vs React Query vs server fetch (Next)

Skip Phase 4 in **vibe** unless user hit a fetch bug.

## Phase 5: Composition patterns (deep)

- Children props, layout components
- Context only when prop drilling hurts (seasoned decision)
- Split container vs presentational (optional)

## Persona integration

| Persona | Focus |
|---------|-------|
| viber | props/state/re-render triangle; one hook at a time |
| seasoned | architecture choices; perf hooks only when measured need |
| autodetect | Skip effect lecture unless effects in diff |

## Common mistakes

| Smell | Fix | Teach |
|-------|-----|-------|
| Infinite re-render | Effect sets state without deps | dependency array |
| State not updating | Mutating object/array | spread/copy |
| Prop changed child state stale | Derive from props or key remount | single source of truth |
| Fetch in effect for button | Move to event handler | user action vs mount |
| Prop drilling 5+ levels | Context or composition | deep only |

Examples: [examples.md](examples.md)

## Lesson integration

After each phase batch, emit lesson block with one anchor. Offer `/devlearn-glossary` for props, state, JSX, hook names.

## Lifecycle handoffs

| Situation | Suggest |
|-----------|---------|
| package.json has `next` | `/devlearn-next` |
| Client fetch to API | `/devlearn-apis` |
| Ready to ship UI | `/devlearn-pre-ship` |
| Large component refactor | `/devlearn-before-you-ship` |

## STOP checkpoint

> "What makes this component re-render — a prop change from parent or its own state change?"

If wrong, one sentence correction — don't lecture.

## Required footer

```markdown
---
DevLearn status: DONE
Concepts taught: [list]
Suggested next: /devlearn-next | /devlearn-apis | /devlearn-explain-diff
---
```

## Additional resources

- Hooks cheatsheet → [reference.md](reference.md)
- Todo component walkthrough → [examples.md](examples.md)
- Fundamentals → `devlearn-javascript`
