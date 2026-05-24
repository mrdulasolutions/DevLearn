---
name: devlearn-explain-diff
description: |
  Turns the current git diff or pull request into a guided What/Why/How walkthrough
  grouped by intent. Use when the user asks to explain a diff, "what did you change",
  "walk me through the PR", or after large edit batches when they seem lost.
  Pairs with devlearn-teach-while-coding and devlearn-git. Voice triggers:
  "explain the diff", "what changed", "walk through the PR".
---

# DevLearn: Explain Diff

## Iron law

**Teach without blocking ship.** This skill explains; it does not block merges unless the user asks to pause.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Follow lesson layers: What → Why → How, with file:line anchors.

## Context

Vibe coders often see a wall of green and red. Your job: group changes by **intent**, tell the story in plain language, and leave them with one memorable takeaway.

## Phase 1: Gather the diff

Collect the change set from one source (prefer the most complete):

| Source | Command / action |
|--------|------------------|
| Unstaged + staged | `git diff` and `git diff --cached` |
| Since branch point | `git diff main...HEAD` or `git diff origin/main...HEAD` |
| Specific commit | `git show <sha>` |
| Pull request | `gh pr diff <number>` or PR URL |

If no diff exists, Status: NEEDS_CONTEXT — ask whether to compare against `main` or a specific commit.

**Do not** paste entire huge diffs into the chat. Read and synthesize.

## Phase 2: Group by intent

Cluster hunks into 2–6 groups with human names:

| Group type | Label example |
|------------|---------------|
| Setup / scaffold | "Project setup" |
| Feature | "Todo add/delete" |
| Fix | "Fix empty submit" |
| Refactor | "Extract save helper" |
| Config / deploy | "Vercel config" |
| Tests | "Cover save handler" |

Skip empty groups. Merge tiny related hunks.

## Phase 3: Walkthrough each group

For each group, output:

```markdown
## [Group name]

**What changed:** [1–2 sentences, no jargon first]

**Why we did it:** [Mechanism + tradeoff]

**How it works:**
- `path/file.ext:line` — [one line]
- [additional anchors for curious/deep]

**Terms introduced:** [term1, term2] (optional)
```

Use patterns from [reference.md](reference.md) for common hunk types.

Respect depth from DEVLEARN.md if present (see [../shared/depth-levels.md](../shared/depth-levels.md)).

### Persona shaping

| Persona | Walkthrough style |
|---------|-------------------|
| viber | What/Why/How per group; terms list at end |
| seasoned | Decision summary per group if architectural; skip line-by-line on lockfiles |
| autodetect | Match user's prior messages |

Seasoned users may prefer one **decision block** for the whole diff instead of per-group lessons — offer if diff is mostly refactors.

## Phase 4: Summary

End with:

```markdown
## If you only remember one thing

[One sentence tying the whole diff to user-visible outcome]

## Suggested next steps
- [ ] Run the app and verify [specific behavior]
- [ ] `/devlearn-glossary` — review new terms
- [ ] `/devlearn-git` — if you want the commit/PR story
- [ ] `/devlearn-pre-ship` — if this diff is release-ready
- [ ] `/devlearn-security` — if auth/secrets/input changed
```

## Phase 5: Glossary offer

If new terms appeared, offer to append them to `DEVLEARN_GLOSSARY.md` via devlearn-glossary rules.

## STOP checkpoint

After the walkthrough, ask **one** question:

> "Which group do you want to zoom into — [A] setup, [B] feature, [C] fix, or none — you're good?"

One group per follow-up. Do not re-dump the full diff.

## Red flags

| Situation | Action |
|-----------|--------|
| Secret in diff | Teach env var pattern; redact value |
| >500 lines changed | Summarize groups first; offer zoom on one |
| Binary / lockfile only | Say so plainly; skip line-by-line theater |

## Required footer

```markdown
---
DevLearn status: DONE
Lesson depth: [vibe|curious|deep]
Groups explained: N
Suggested next: /devlearn-glossary | /devlearn-git | none
---
```

## Additional resources

- Hunk pattern library → [reference.md](reference.md)
- Git narrative → `devlearn-git`
- Ambient lessons → `devlearn-teach-while-coding`
