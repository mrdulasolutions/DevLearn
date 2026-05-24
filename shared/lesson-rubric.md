# Lesson quality rubric

Before emitting any DevLearn lesson or decision block, self-check:

## All personas

- [ ] User could paraphrase **what changed** without reading code
- [ ] **Why** includes a tradeoff (curious/deep/viber curious+)
- [ ] No secrets, tokens, API keys, or PII in lesson text
- [ ] One intent per block — not one block per file
- [ ] Task is already shipped or clearly in progress (teach without blocking ship)

## Viber persona

- [ ] No jargon on first pass; term defined in **Term of the moment**
- [ ] **Feel → mechanism** order (what user sees before internal names)
- [ ] vibe depth: ≤5 short bullets total
- [ ] At most one file:line unless user asked "where in code"

## Seasoned persona

- [ ] No definitional trivia ("a variable stores a value")
- [ ] **Alternatives** names at least one rejected option
- [ ] **Risk & verify** has concrete test steps
- [ ] Lesson only if whitelist tag applies OR user requested explanation
- [ ] Decision row appended for architecture/security/breaking/deps/perf

## If rubric fails

- Shorten and fix — do not skip shipping
- If context missing: Status BLOCKED or NEEDS_CONTEXT, one question only
