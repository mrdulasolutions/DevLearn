# DevLearn completion protocol

Every DevLearn skill session ends with an explicit status block.

## Status values

| Status | Meaning |
|--------|---------|
| `DONE` | Task completed; lesson/decision delivered (or intentionally skipped) |
| `LESSON_SKIPPED` | Work completed; no lesson (trivial, seasoned quiet mode, or user override) |
| `BLOCKED` | Cannot proceed or teach accurately; missing input listed |
| `NEEDS_CONTEXT` | Partial work; user must answer one question before continuing |

## Required footer

```markdown
---
DevLearn status: DONE
Persona: viber | seasoned
Lesson depth: vibe | curious | deep
Block type: lesson | decision | none
Glossary updated: yes | no
Progress updated: yes | no
Suggested next: /devlearn-explain-diff | none
---
```

## Handoff suggestions

| Situation | Suggest |
|-----------|---------|
| Large diff, user confused | `/devlearn-explain-diff` |
| Many new terms | `/devlearn-glossary` |
| Session summary | `/devlearn-recap` |
| First-time setup | `/devlearn-onboard` |
| Before big refactor (>5 files) | `/devlearn-before-you-ship` |
| Lesson tone wrong | `/devlearn-lesson-review` |
| Error / stack trace | `/devlearn-debugging` |
| User unsure what to learn | `/devlearn-curriculum-router` |
| React components | `/devlearn-react` |
| Next.js app router | `/devlearn-next` |
| HTML/CSS | `/devlearn-html-css` |
| JS/DOM | `/devlearn-javascript` |
| APIs | `/devlearn-apis` |
| Git/PR | `/devlearn-git` |
| Deploy / hosting | `/devlearn-deploy` |
| Pre-release checklist | `/devlearn-pre-ship` |
| Security / secrets / auth | `/devlearn-security` |
| CI/CD, Docker, workflows | `/devlearn-devops` |
| After live URL | `/devlearn-post-ship` |
| Plan before big code edit | `/devlearn-before-you-ship` |

## Red flags

- User overwhelmed → vibe, one term, offer `/devlearn-recap`
- >8 files changed → offer explain-diff or before-you-ship first
- Secret in diff → env var pattern only; never repeat value
- Seasoned user annoyed by trivia → switch persona seasoned + quiet whitelist

## 3-strike rule

Same explanation failed twice → STOP; one multiple-choice question. No third repeat.
