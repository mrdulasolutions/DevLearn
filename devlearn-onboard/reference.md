# DevLearn onboard — reference

## Glossary file header

```markdown
# DevLearn glossary

Terms learned while building this project. Updated by `/devlearn-glossary` and ambient lessons.

| Term | Definition | Where we used it | Reference |
|------|------------|------------------|-----------|
```

## Minimal progress.md (if template unavailable)

```markdown
# DevLearn progress

## Last session
- Date: [today]
- Focus: [goal from onboard]
- Next: [first skill or feature]

## Concepts touched
| Concept | One-line | Date |
|---------|----------|------|
```

## Minimal decisions.md (seasoned)

```markdown
# DevLearn decisions (ADR-lite)

| Date | Decision | Alternatives considered | Risk / verify |
|------|----------|-------------------------|---------------|
```

## First prompt samples by goal

### Webpage (viber, vibe)

> Build a simple landing page for [topic]. Teach me in short blocks after each change. Use `/devlearn-html-css`. Keep it shippable — one page, no framework unless I ask.

### Interactive app (curious)

> Add a todo list I can click and type into. Teach What/Why/How after each step. Start with HTML/CSS then JavaScript. Update DEVLEARN_GLOSSARY.md with new terms.

### Save data (curious, apis)

> Wire todos to persist across refresh (localStorage first). Explain client vs server when we outgrow it. Use devlearn-apis patterns. No secrets in code.

### Go live (curious + lifecycle)

> Help me get this on a public URL. Before deploy run through pre-ship and security. Teach each step. Stack: [vanilla|react|next from detect].

### Learn from a website (curious)

> Analyze https://example.com with `/devlearn-analyze-website`. Teach me how the layout and hero work, then help me rebuild a simplified version with placeholders.

### Fix something (any persona)

> Here's the error: [paste]. Fix it first, then explain the cause in plain English. Use `/devlearn-debugging`.

### Seasoned (quiet default)

> Implement [feature]. Only explain non-obvious architecture or security choices as decision blocks. Log decisions to `.devlearn/decisions.md`.

## AskQuestion option sets

**Experience:** viber | seasoned | autodetect

**Goal:** webpage | interactive | save data | go live | fix bug | not sure

**Depth:** vibe (ship first) | curious (sometimes teach) | deep (teach lots)

## Merge vs replace DEVLEARN.md

When file exists:

1. Read current persona, depth, lifecycle
2. Ask: "Keep your current depth [X] and only update goal/stack?" unless user said "start fresh"
3. Preserve user comments outside YAML block if any

## Verify install

```bash
ls ~/.cursor/skills/devlearn-teach-while-coding/SKILL.md
# Or project-local skills path from install.sh output
./install.sh --verify
```
