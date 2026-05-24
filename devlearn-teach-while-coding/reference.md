# devlearn-teach-while-coding — reference

Detailed rules for when to emit lessons, how to batch, and domain-specific teaching hooks.

## Substantive vs trivial changes

### Substantive (emit lesson)

| Signal | Example | Term ideas |
|--------|---------|------------|
| New file with logic | `app.js`, `route.ts` | module, component, handler |
| Behavior change | fix submit, add validation | event, state, guard |
| New dependency | `package.json` entry | dependency, semver |
| Config / env | `.env.example`, `vite.config` | env var, build config |
| API / network | fetch, route, CORS header | request, endpoint, JSON |
| Data persistence | localStorage, DB migration | schema, migration |
| Auth | login, session, JWT | token, session |
| Deploy / CI | Dockerfile, GitHub Action | build, artifact, pipeline |
| Error fix | root cause not obvious | regression, edge case |

### Trivial (LESSON_SKIPPED)

| Signal | Example |
|--------|---------|
| Spelling / typo | comment text |
| Formatting only | prettier, eslint auto-fix |
| Import reorder | no new imports |
| Lockfile only | `package-lock.json` churn |
| Comment-only diff | no code path change |
| Version bump only | patch dep with no API use |

### Gray area

| Signal | Rule |
|--------|------|
| Rename symbol | Skip if 1:1 rename; teach if behavior changed |
| CSS color tweak | Skip in vibe; one-line what in curious if user cares about design |
| Test-only change | Teach in deep if it documents behavior; skip in vibe |

## Batching rules

**One intent = one lesson block.**

Good batches:

- "Added todo list UI + click handlers" → one lesson (DOM + events)
- "Fixed CORS + env API URL" → one lesson (API origin)

Split batches (deep mode only, max 3 blocks):

- Unrelated bug fix + new feature in same request → two lessons
- Refactor + feature → teach feature; mention refactor in one sentence

Never:

- One lesson per line changed
- One lesson per file when files share one intent

## Mapping change type → topic skill

| Files / keywords | Suggest skill |
|------------------|---------------|
| `.html`, `.css`, layout, flex, grid | devlearn-html-css |
| `.js`, `.ts`, DOM, click, async | devlearn-javascript |
| `fetch`, `/api`, REST, JSON, auth | devlearn-apis |
| `git`, commit, branch, PR, merge | devlearn-git |
| Deploy / CI yaml | devlearn-deploy |
| GitHub Actions / Dockerfile | devlearn-devops |
| Auth, secrets, user input | devlearn-security |
| Before merge / "ready to ship" | devlearn-pre-ship |
| After deploy URL live | devlearn-post-ship |
| >5 files planned | devlearn-before-you-ship |

## DEVLEARN.md parsing

Expected YAML-ish fields (be tolerant of markdown code fences):

```yaml
enabled: true
depth: vibe          # vibe | curious | deep
glossary: true
topics: []           # optional: html-css, javascript, apis, git, deploy
```

If file is missing: teaching only when user explicitly asks.

## Glossary file format

When updating `DEVLEARN_GLOSSARY.md` directly:

```markdown
# DevLearn glossary

| Term | Definition | Where we used it | Reference |
|------|------------|------------------|-----------|
| localStorage | Browser key-value storage per site | Save button | app.js:42 |
```

Dedupe: if term exists with same meaning, add a new "Where we used it" in the Reference column or merge rows.

## Lesson quality checklist

Before emitting:

- [ ] User can paraphrase **what changed** without reading code
- [ ] **Why** mentions at least one alternative or tradeoff (curious+)
- [ ] **How** has a real file path from this repo
- [ ] **Term** is defined in plain language, not circular jargon
- [ ] No secrets, tokens, or PII in the lesson text

## Interaction with explicit skills

| After ambient lesson | User might invoke |
|----------------------|-------------------|
| Large diff | devlearn-explain-diff |
| "What does X mean?" | devlearn-glossary |
| "What's next to learn?" | devlearn-curriculum-router |
| Domain deep dive | devlearn-{topic} |

Ambient skill does **not** replace explicit skills; it teases them.

## Plan mode / read-only

When the agent cannot edit files:

- Do not promise lessons "after edits"
- Offer to explain existing code or diff read-only
- Status: NEEDS_CONTEXT if user expected build + teach

## Multi-agent / compaction recovery

If context was compacted:

1. Re-read DEVLEARN.md
2. Skim last lesson block or DEVLEARN_GLOSSARY.md if present
3. Re-ground in one sentence before continuing teaching
