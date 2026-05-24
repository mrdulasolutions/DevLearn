---
name: devlearn-curriculum-router
description: |
  Maps the user's learning goal to an ordered DevLearn skill chain, suggested
  weekend project, and depth setting. Use when the user asks what to learn next,
  "I'm new where do I start", "I want a webpage/app/live site", or feels lost
  in the curriculum. Voice triggers: "what should I learn", "learning path".
---

# DevLearn: Curriculum Router

## Iron law

**Teach without blocking ship.** Recommend a path; start building when the user says go.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Recommendations must be concrete: skill names, project ideas, and why this order.

## Phase 1: Discover goal

Ask or infer from user message. Minimum inputs (accept partial):

| Question | Why |
|----------|-----|
| What do you want to **have** at the end? | webpage / interactive app / saved data / live URL |
| What have you **already** built in this repo? | avoid re-teaching basics |
| How much explanation? | maps to vibe / curious / deep |

If user gave a clear goal ("I want this live on the internet"), skip redundant questions.

## Phase 2: Detect stack

Read `package.json` if present. Follow [stack-detection.md](stack-detection.md).

Prefer framework skills when stack is react/next before vanilla html-css chain.

## Phase 3: Match route

Use [curriculum-map.md](curriculum-map.md). Output **2–3 skills in order** and one **weekend project**.

## Phase 4: Present recommendation

```markdown
## Your path

**Goal:** [restated in their words]

**Learn next (in order):**
1. `/devlearn-[skill]` — [one line why]
2. `/devlearn-[skill]` — [one line why]
3. ...

**Weekend project:** [specific, shippable, e.g. todo list → deploy]

**Suggested DEVLEARN.md depth:** vibe | curious | deep — [one line why]

**First message to send your agent:**
> "[copy-paste prompt to start building + teaching]"
```

## Phase 4: Enable DevLearn

If `DEVLEARN.md` missing, offer `/devlearn-onboard` or copy template from DevLearn repo.

Install skills:

```bash
git clone https://github.com/mrdulasolutions/DevLearn.git && cd DevLearn && ./install.sh
./install.sh --project "$(pwd)" --copy-rule --verify
```

## Curriculum quick map

| User says | Route |
|-----------|-------|
| "webpage" / "landing page" | html-css → javascript |
| "interactivity" / "button clicks" | javascript → html-css refresh |
| "save data" / "login" | javascript → apis → security (auth) |
| "don't understand git" | git → explain-diff |
| "live on internet" | deploy ← git ← (html-css + javascript as needed) |
| "full stack app" | html-css → javascript → apis → git → deploy |
| "react app" | javascript → react → apis → deploy |
| "next app" | react → next → apis → deploy |
| "what did agent change" | explain-diff → glossary |
| "ready to ship" | pre-ship → security → deploy → post-ship |
| "CI / pipeline" | devops → pre-ship |
| "I'm totally new" | onboard → html-css → javascript (todo project) |

Full map: [curriculum-map.md](curriculum-map.md). Ship lifecycle: [../shared/ship-lifecycle.md](../shared/ship-lifecycle.md)

## STOP checkpoint

After presenting path, ask **one** question:

> "Start with step 1 now, or jump to [later step] because you already know [X]?"

Respect jump if user confirms.

## Sample paths

### Todo → live (vanilla)

1. html-css — static todo page
2. javascript — add/remove todos
3. apis — localStorage or simple API persistence
4. git — commit + PR story
5. pre-ship → security — release checks
6. deploy — public URL
7. post-ship — smoke test live URL

### React / Next shortcut

Detect stack → react or next skill early → apis → devops (optional CI) → ship lifecycle chain.

Documented end-to-end in [../examples/todo-app/README.md](../examples/todo-app/README.md) and [../README.md](../README.md).

## Required footer

```markdown
---
DevLearn status: DONE
Route: [skill1 → skill2 → skill3]
Suggested depth: [vibe|curious|deep]
Suggested next: /devlearn-[first-skill]
---
```

## Additional resources

- Full curriculum map → [curriculum-map.md](curriculum-map.md)
- Sample path → [../README.md](../README.md)
