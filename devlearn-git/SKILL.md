---
name: devlearn-git
description: |
  Teaches git commits, branches, pull requests, and merge workflow while the
  agent performs real git operations. Use when the user asks about git, commits,
  branches, PRs, "what did you just run in git", or curriculum routes here.
  Pairs with devlearn-explain-diff. Proactively suggest when git commands run
  and DEVLEARN.md is enabled.
---

# DevLearn: Git

## Iron law

**Teach without blocking ship.** Run git operations the user asked for; explain each meaningful step in plain language.

## Voice

Follow [../shared/voice.md](../shared/voice.md). After git operations, emit lesson blocks from [../shared/lesson-block.md](../shared/lesson-block.md).

## Context

Git is a **time machine + parallel universes** for your code. Vibe coders don't need every flag — they need to know what just happened, why it's safe, and what to do when something looks scary.

## Prerequisites

- Project with git initialized (or offer `git init`)
- User goal: save work, try ideas safely, share via PR, or undo mistakes

Router handoff: users from "what did agent change" → `devlearn-explain-diff` after commit.

## Before you start

1. Read DEVLEARN.md depth (default **curious** for git — mistakes are costly)
2. Step 0: `git status` — what's dirty, what branch, remote?
3. Never force-push `main` without explicit user request and warning

## Core mental model (teach once per session)

| Concept | Plain English |
|---------|---------------|
| **Working tree** | Files on disk right now |
| **Staging** | Shopping cart of changes for next snapshot |
| **Commit** | Named snapshot with message |
| **Branch** | Parallel line of snapshots |
| **Remote** | Copy on GitHub/GitLab others can see |
| **PR** | "Please merge my branch into main" with review |

## Workflow A: First commit

**When:** New project or never committed.

1. `git status` — show untracked/modified
2. Explain: commit = save point with message
3. Stage intentional files only (warn on `.env`, secrets)
4. `git commit -m "..."` — message describes **why**, not only what
5. Lesson block + terms: **commit**, **staging**

**Try it yourself:** Run `git log -1 --oneline` and read your message aloud.

## Workflow B: Save work on a branch

**When:** Feature or experiment without breaking main.

1. Explain branch as "copy of timeline for one idea"
2. `git checkout -b feature/todo-save` (or `git switch -c`)
3. Work + commits on branch
4. Lesson: **branch**, why not commit directly to main

**Smell:** Long-lived work on `main` with no commits — suggest branch.

## Workflow C: Pull request story

**When:** User wants review or merge to main.

1. Push branch: `git push -u origin HEAD`
2. `gh pr create` if available — title = user outcome, body = test plan
3. Teach PR as conversation + CI gate, not magic merge button
4. Offer `/devlearn-explain-diff` on PR diff

**Terms:** **remote**, **PR**, **merge**

## Workflow D: Update from main

**When:** Branch is behind main.

1. Explain: main moved; you need those fixes on your branch
2. Prefer `git pull --rebase origin main` on feature branches (teach rebase as "replay your commits on top")
3. If conflicts: teach conflict markers, one file at a time

**STOP:** If conflict, pause and teach one file before continuing.

## Workflow E: Oops recovery (safe only)

| User says | Teach + do |
|-----------|------------|
| "Unstage" | `git restore --staged` |
| "Discard file changes" | `git restore <file>` — warn: loses uncommitted work |
| "Undo last commit keep changes" | `git reset --soft HEAD~1` |
| "What did I change?" | `git diff` → `/devlearn-explain-diff` |

**Never** `git reset --hard` or force-push without careful warning and user confirmation.

## Domain glossary

| Term | Definition |
|------|------------|
| commit | Snapshot of staged changes with message |
| staging | Selecting which changes go into next commit |
| branch | Movable pointer to a line of commits |
| merge | Combine branch histories |
| rebase | Replay commits onto another base |
| remote | Server copy (origin) |
| PR | Request to merge branch with review |
| clone | Copy remote repo locally |
| .gitignore | Files git should not track |

## Common mistakes

| Smell | What happened | Fix |
|-------|---------------|-----|
| "Everything is red in status" | Many untracked files | .gitignore, commit in chunks |
| "Committed secret" | .env in commit | Rotate secret, gitignore, teach env vars |
| "Can't push" | No upstream / auth | `-u origin`, SSH/token help |
| "Merge conflict scary" | Same lines edited twice | Open file, pick correct parts, commit |

## Lesson integration

After each workflow step that changes git state, emit lesson block. Minimum one **Term of the moment** per workflow.

For multi-command sequences (push + PR), one combined lesson is OK in vibe mode.

## STOP checkpoint

Before first push to remote:

> "Your commits will be visible on [remote]. Ready to push, or want to review diff first?"

Offer `/devlearn-explain-diff` if they hesitate.

Before merge after PR:

> "After merge, run `/devlearn-pre-ship` before production deploy."

## Lifecycle handoffs

| After | Suggest |
|-------|---------|
| PR open | `/devlearn-explain-diff` on PR diff |
| Merge to main | `/devlearn-pre-ship` → `/devlearn-security` |
| Push deploy | `/devlearn-deploy` |
| Live URL | `/devlearn-post-ship` |
| Add GitHub Actions | `/devlearn-devops` |

## Required footer

```markdown
---
DevLearn status: DONE
Lesson depth: [from DEVLEARN.md]
Git actions: [e.g. commit, push, pr create]
Suggested next: /devlearn-explain-diff | /devlearn-deploy
---
```

## Additional resources

- Command cheatsheet → [reference.md](reference.md)
- Diff narrative → `devlearn-explain-diff`
- Ambient teaching → `devlearn-teach-while-coding`
