---
name: devlearn-teach-while-coding
description: |
  Ambient teaching layer for vibe coders and seasoned devs. After substantive
  changes, emits persona-aware lesson or decision blocks without blocking shipping.
  Use when user says "teach me while you work", "learn while I vibe", or when
  DEVLEARN.md exists with enabled true. Proactively apply after edit batches.
  Supports viber (What/Why/How) and seasoned (Decision/Alternatives/Risk) personas.
  Voice triggers: "teach me", "explain while you build", "explain like PR review".
---

# DevLearn: Teach While Coding

## Iron law

**Teach without blocking ship.** Complete the user's task first. Lessons are additive unless they explicitly pause.

## Shared doctrine

- Skill structure guide → [../shared/skill-skeleton.md](../shared/skill-skeleton.md)
- Platform paths (Cursor, Codex, OpenCode…) → [../shared/agent-compatibility.md](../shared/agent-compatibility.md)
- Voice → [../shared/voice.md](../shared/voice.md)
- Viber block → [../shared/lesson-block.md](../shared/lesson-block.md)
- Seasoned block → [../shared/decision-block.md](../shared/decision-block.md)
- Depth + persona → [../shared/depth-levels.md](../shared/depth-levels.md)
- Rubric → [../shared/lesson-rubric.md](../shared/lesson-rubric.md)
- Session recap → [../shared/session-recap.md](../shared/session-recap.md)
- Visual diagrams → [../shared/visual-flow.md](../shared/visual-flow.md)
- Footer → [../shared/completion-protocol.md](../shared/completion-protocol.md)
- Teach/skip rules → [reference.md](reference.md)

## Phase 0: Config & session memory

Parse `DEVLEARN.md`:

| Field | Default |
|-------|---------|
| enabled | false unless file exists |
| persona | autodetect |
| depth | vibe |
| glossary | true |
| progress | true |
| decisions | true |
| before_big_changes | true |
| lifecycle.pre_ship_checklist | true |
| lifecycle.security_pass | true |
| lifecycle.post_ship_verify | true |
| seasoned_lessons_on | architecture, security, breaking, deps, perf |
| stack | autodetect |

**Session opener:** If `progress: true` and `.devlearn/progress.md` exists, use opener from session-recap.md (skip if "just ship" or seasoned quiet mode).

**Autodetect persona:** See depth-levels.md. Override with "explain like PR review" → seasoned.

## Phase 0b: Before big changes

If `before_big_changes: true` and plan touches **>5 files** or architecture shift:

1. Pause before editing
2. Offer `/devlearn-before-you-ship` — plain-English plan in 5 bullets
3. Proceed when user confirms or says "just ship"

## Phase 1: Do the work

Execute normally. Small logical change sets. Match stack from `package.json` when teaching (React/Next skills for framework code).

## Phase 2: Emit block (when teaching ON)

After substantive batch, apply rubric then emit:

| Persona | Template | When seasoned skips |
|---------|----------|---------------------|
| viber | lesson-block.md | N/A |
| seasoned | decision-block.md | No whitelist match + vibe depth |
| autodetect | resolved persona | same as resolved |

**Seasoned whitelist:** Only emit if change tags a `seasoned_lessons_on` category OR user asked for explanation.

### Viber sections

What changed → Why → How (file:line) → Term → Try it (curious+)

### Seasoned sections

Decision → Alternatives → Risk & verify → Anchor (if non-obvious)

Append row to `.devlearn/decisions.md` when `decisions: true` and choice is non-obvious.

### Progress & glossary

- `glossary: true` → update DEVLEARN_GLOSSARY.md or `.devlearn/glossary.md`
- `progress: true` → append concept to `.devlearn/progress.md`; refresh Last session

Create `.devlearn/` from repo templates if missing.

## Phase 2b: Lifecycle hooks (DEVLEARN.md lifecycle)

| Trigger | Suggest |
|---------|---------|
| User says "ready to ship" / PR approved + `pre_ship_checklist` | `/devlearn-pre-ship` |
| Diff touches auth, `.env`, crypto, user input + `security_pass` | `/devlearn-security` |
| New/edited `.github/workflows/*`, Dockerfile + `devops_on_ci` | `/devlearn-devops` |
| Deploy finished, live URL shared + `post_ship_verify` | `/devlearn-post-ship` |

See [../shared/ship-lifecycle.md](../shared/ship-lifecycle.md).

## Phase 3: Handoffs

| Situation | Suggest |
|-----------|---------|
| >5 files / confusion | `/devlearn-explain-diff` |
| End of session | `/devlearn-recap` |
| React/Next code | `/devlearn-react` or `/devlearn-next` |
| Errors | `/devlearn-debugging` |
| User pastes URL / "how was this built" | `/devlearn-analyze-website` |
| Learning path | `/devlearn-curriculum-router` |
| Ready to release | `/devlearn-pre-ship` → `/devlearn-security` |
| CI/CD added | `/devlearn-devops` |
| Just deployed | `/devlearn-post-ship` |

## Overrides

| User says | Effect |
|-----------|--------|
| just ship / no lessons | No block; LESSON_SKIPPED |
| more detail / less detail | Bump depth |
| explain like PR review | seasoned decision block |
| teach me like I'm new | force viber |

## STOP checkpoint

"I don't understand" → stop edits; one term; one question (what / why / where in code).

## All 21 skills (handoff index)

| Category | Skills |
|----------|--------|
| Meta | teach-while-coding, explain-diff, glossary, curriculum-router, onboard, recap, before-you-ship, lesson-review, analyze-website |
| Fundamentals | html-css, javascript, react, next, apis, git, debugging |
| Ship lifecycle | pre-ship, security, deploy, post-ship, devops |

Install or refresh: `./install.sh --verify` from [DevLearn repo](../install.sh).

## Additional resources

- Teach/skip rules → [reference.md](reference.md)
- Onboard → `devlearn-onboard`
- Session end → `devlearn-recap`
- Plan big changes → `devlearn-before-you-ship`
- Lesson QA → `devlearn-lesson-review`
