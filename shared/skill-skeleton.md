# DevLearn fat skill skeleton

Every DevLearn topic skill should follow this structure so agents behave consistently across the curriculum.

## Required sections (in order)

1. **YAML frontmatter** — `name`, multi-line `description` with triggers + voice aliases
2. **Iron law** — one line: teach without blocking ship (or skill-specific variant)
3. **Voice + blocks** — links to `../shared/voice.md`, `lesson-block.md`, `decision-block.md`
4. **Context** — who this skill is for, what problem it solves (2–4 sentences)
5. **Prerequisites** — prior skills or knowledge
6. **Before you start** — parse `DEVLEARN.md`: persona, depth, stack, lifecycle flags
7. **Phased workflow** — numbered phases with concrete outputs
8. **Persona integration** — table: viber vs seasoned vs autodetect behavior
9. **Domain table** — terms, smells/fixes, or checklist rows
10. **Lesson integration** — when to emit lesson vs decision block; glossary/progress hooks
11. **Lifecycle handoffs** — links to `../shared/ship-lifecycle.md` and sibling skills
12. **Common mistakes** — smell → fix table
13. **Red flags / STOP** — when to pause, ask one question, or escalate
14. **Required footer** — DevLearn status block per `completion-protocol.md`
15. **Additional resources** — `reference.md`, `examples.md`, related skills

## Target size

| Skill type | SKILL.md lines | reference.md |
|------------|----------------|--------------|
| Meta / utility | 120–200 | optional, 80–150 if present |
| Topic (html, js, react) | 200–350 | 80–120 |
| Lifecycle (pre-ship, security) | 150–250 | 60–100 + examples where useful |

## DEVLEARN.md fields every skill should respect

```yaml
enabled, persona, depth, glossary, progress, decisions
topics, stack, before_big_changes
lifecycle.pre_ship_checklist, security_pass, post_ship_verify, devops_on_ci
seasoned_lessons_on  # architecture, security, breaking, deps, perf
```

## User overrides (honor in every skill)

| User says | Effect |
|-----------|--------|
| just ship / no lessons | Skip lesson blocks; complete task |
| more detail / less detail | Bump depth one step |
| explain like PR review | Force seasoned decision block |
| /devlearn-recap | End-of-session summary |

## Install reference (when pointing users to skills)

```bash
git clone https://github.com/mrdulasolutions/DevLearn.git && cd DevLearn && ./install.sh
./install.sh --agent all --verify          # Cursor + Claude + Codex + OpenCode
./install.sh --agent codex --verify        # ~/.agents/skills (Codex)
./install.sh --project ~/code/my-app --copy-rule --copy-agents --project-skills
```

Platform paths and invocation: [agent-compatibility.md](agent-compatibility.md)

## Cross-links checklist

When updating any skill, verify links to:

- `devlearn-teach-while-coding` (ambient)
- `devlearn-curriculum-router` (lost / what's next)
- `devlearn-explain-diff` (large diffs)
- `devlearn-glossary` (new terms)
- Ship chain: `before-you-ship` → `pre-ship` → `security` → `deploy` → `post-ship`
- `devlearn-devops` when CI/Docker appears

## Persona block templates

**Viber:** What → Why → How (file:line) → Term → Try it (curious+)

**Seasoned:** Decision → Alternatives → Risk & verify → Anchor (if non-obvious)

See `lesson-block.md` and `decision-block.md` for exact markdown shapes.
