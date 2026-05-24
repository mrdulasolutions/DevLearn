---
name: devlearn-onboard
description: |
  Guided 60-second DevLearn setup. Asks persona, goal, depth, and stack; writes
  DEVLEARN.md, initializes .devlearn/ artifacts, runs install reminder, and gives
  a copy-paste first prompt. Use when user says "set up devlearn", "help me get
  started learning", first time using DevLearn, or DEVLEARN.md is missing. Voice
  triggers: "onboard", "devlearn setup", "get started with devlearn".
---

# DevLearn: Onboard

## Iron law

**Teach without blocking ship.** Setup should take one short exchange, then the user builds.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Onboarding copy is warm and concrete — no curriculum lecture.

## Context

New users have skills installed but no project config. This skill turns three answers into a working `DEVLEARN.md`, optional `.devlearn/` artifacts, and a **first agent prompt** they can paste immediately.

Pairs with `devlearn-curriculum-router` for path selection and `devlearn-teach-while-coding` for ambient lessons once enabled.

## Prerequisites

- DevLearn skills installed (`./install.sh` from repo root)
- A project folder (empty or existing code)

## Before you start

1. Check if `DEVLEARN.md` already exists — offer to **merge** (keep user edits) or **replace** (fresh start)
2. Read `package.json` if present for stack autodetect
3. Scan for existing `.devlearn/` or `DEVLEARN_GLOSSARY.md` — don't wipe without asking

## Phase 1: Three questions (batch if user already answered)

Use AskQuestion when available; otherwise one message with A/B/C options.

| # | Question | Maps to |
|---|----------|---------|
| 1 | **Experience:** New to coding (viber), experienced (seasoned), or autodetect? | `persona` |
| 2 | **Goal:** Webpage / interactive app / save data / go live / fix something / not sure | `topics`, lifecycle flags |
| 3 | **Explanation:** Ship first (vibe) / sometimes (curious) / teach me lots (deep) | `depth` |

**Goal → lifecycle defaults:**

| Goal | Suggest enabling |
|------|------------------|
| go live / production | all `lifecycle.*` true |
| save data / login | `security_pass: true` |
| fix something | `depth: curious`, shorter path |
| not sure | autodetect stack, vibe depth |

## Phase 2: Detect stack

Read `package.json` if present. Full rules: [../devlearn-curriculum-router/stack-detection.md](../devlearn-curriculum-router/stack-detection.md).

| Signal | Set `stack:` |
|--------|--------------|
| `"next"` in dependencies | next |
| `"react"` (no next) | react |
| static HTML or no package.json | vanilla |
| unclear | autodetect |

## Phase 3: Write DEVLEARN.md

Use template from repo [DEVLEARN.md](../DEVLEARN.md). Set:

- `enabled: true`
- `persona`, `depth`, `stack` from answers
- `topics: []` or focused list from goal
- `glossary`, `progress`, `decisions` — default true (decisions matters for seasoned)
- `before_big_changes: true`
- `lifecycle` block per goal table above

Show the user a **3-line summary** of what was written, not the full YAML dump unless they ask.

## Phase 4: Initialize artifacts

When flags are true, create under project root:

```bash
mkdir -p .devlearn
```

| Flag | File | Source template |
|------|------|-----------------|
| `progress: true` | `.devlearn/progress.md` | [../.devlearn/progress-template.md](../.devlearn/progress-template.md) |
| `decisions: true` | `.devlearn/decisions.md` | [../.devlearn/decisions-template.md](../.devlearn/decisions-template.md) |
| `glossary: true` | `DEVLEARN_GLOSSARY.md` | header from onboard [reference.md](reference.md) |
| go-live goal | `.devlearn/pre-ship-checklist.md` | optional, from pre-ship template |

If DevLearn repo isn't local, create minimal files from [reference.md](reference.md) inline templates.

## Phase 5: Install & rule reminder

If skills may be missing (user says commands not found):

```bash
git clone https://github.com/mrdulasolutions/DevLearn.git && cd DevLearn && ./install.sh
# All agents (Cursor, Claude, Codex, OpenCode):
./install.sh --agent all --verify
# This project:
./install.sh --project "$(pwd)" --copy-rule --copy-agents --project-skills --verify
```

Platform guide: [../shared/agent-compatibility.md](../shared/agent-compatibility.md)

Optional Cursor rule: copy [../.cursor/rules/devlearn.example.mdc](../.cursor/rules/devlearn.example.mdc) → `.cursor/rules/devlearn.mdc`

Optional Codex ambient: `./install.sh --copy-agents` or copy [../AGENTS.md.example](../AGENTS.md.example) → `AGENTS.md`

## Phase 6: Route + first prompt

Apply [../devlearn-curriculum-router/curriculum-map.md](../devlearn-curriculum-router/curriculum-map.md) logic.

If goal includes **go live**, mention ship lifecycle chain:

```
/devlearn-pre-ship → /devlearn-security → /devlearn-deploy → /devlearn-post-ship
```

Output:

```markdown
## You're set up

**DEVLEARN.md** written with persona [X], depth [Y], stack [Z].

**Your path:** `/devlearn-skill1` → `/devlearn-skill2` → ...

**Send this to your agent first:**
> "[specific build + teach prompt — see reference.md samples]"

**Optional:** `./install.sh --project . --copy-rule` if skills aren't global yet.
```

## Persona tuning

| Persona | Onboarding tone |
|---------|-----------------|
| viber | "You'll see short What/Why/How blocks after changes" |
| seasoned | "Lessons only on architecture, security, deps — say 'explain like PR review' anytime" |
| autodetect | "I'll match your style; say 'teach me like I'm new' to force beginner mode" |

## Common mistakes

| Smell | Fix |
|-------|-----|
| DEVLEARN.md in wrong folder | Must be **project root** where agent edits code |
| Skills work but no lessons | Check `enabled: true` and rule copied |
| Too many questions | Infer from repo + first message; confirm in one line |

## STOP checkpoint

After setup, ask **one** question:

> "Paste the first prompt above to start building, or want `/devlearn-curriculum-router` for a longer path first?"

## Required footer

```markdown
---
DevLearn status: DONE
Config: DEVLEARN.md
Artifacts: [list created files]
Suggested next: /devlearn-[first-skill] | start building with first prompt
---
```

## Additional resources

- Question scripts & first prompts → [reference.md](reference.md)
- Full curriculum → `devlearn-curriculum-router`
- Ambient teaching → `devlearn-teach-while-coding`
- Example project → [../examples/todo-app/README.md](../examples/todo-app/README.md)
