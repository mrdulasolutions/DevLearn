# DevLearn project config (template)

Copy this file into the **root of any project** where you want your coding agent to teach you while it works.

Or run **`/devlearn-onboard`** for a guided setup that writes this file for you.

```yaml
enabled: true
persona: autodetect    # viber | seasoned | autodetect
depth: vibe            # vibe | curious | deep
glossary: true         # DEVLEARN_GLOSSARY.md or .devlearn/glossary.md
progress: true         # .devlearn/progress.md session memory
decisions: true        # .devlearn/decisions.md (seasoned ADR-lite)
topics: []             # optional focus: [react, next, apis, git]
seasoned_lessons_on:   # seasoned: only teach on these (quiet otherwise)
  - architecture
  - security
  - breaking
  - deps
  - perf
stack: autodetect      # autodetect | vanilla | react | next
before_big_changes: true   # offer devlearn-before-you-ship when >5 files
lifecycle:
  pre_ship_checklist: true   # /devlearn-pre-ship before merge/deploy
  security_pass: true        # /devlearn-security on auth/secrets/input
  post_ship_verify: true     # /devlearn-post-ship after live URL
  devops_on_ci: true         # /devlearn-devops when adding workflows/Docker
```

## Personas

| Persona | Best for | Lesson shape |
|---------|----------|--------------|
| **viber** | New / vibe coding | What / Why / How + term ([lesson-block.md](shared/lesson-block.md)) |
| **seasoned** | Experienced devs | Decision / Alternatives / Risk ([decision-block.md](shared/decision-block.md)) |
| **autodetect** | Mixed | Infer from messages; default viber unless user uses senior language |

## Depth modes

| Mode | What you get |
|------|----------------|
| **vibe** | Short blocks. Jargon-light. Ship first. |
| **curious** | + try-it-yourself + one tradeoff |
| **deep** | + multi-file flow + topic skill links |

## Artifacts (when enabled)

| File | Purpose |
|------|---------|
| `DEVLEARN_GLOSSARY.md` | Terms learned |
| `.devlearn/progress.md` | Session memory + concepts table |
| `.devlearn/decisions.md` | ADR-lite for seasoned mode |

Templates ship in the DevLearn repo under `.devlearn/`.

## Ship lifecycle

Full flow: [shared/ship-lifecycle.md](shared/ship-lifecycle.md)

| Stage | Skill |
|-------|-------|
| Plan before coding | `/devlearn-before-you-ship` |
| Checklist before release | `/devlearn-pre-ship` |
| Security pass | `/devlearn-security` |
| Go live | `/devlearn-deploy` |
| Verify production | `/devlearn-post-ship` |
| CI/CD & Docker | `/devlearn-devops` |

## User overrides (say anytime)

- **"just ship"** / **"no lessons"** — no lesson blocks this turn
- **"more detail"** / **"less detail"** — adjust depth
- **"explain like PR review"** — force seasoned decision block
- **"/devlearn-recap"** — 60-second session summary

## Install DevLearn skills

Works with **Cursor, Claude Code, Codex, OpenCode**, and other Agent Skills tools.

**Easiest:**

```bash
git clone https://github.com/mrdulasolutions/DevLearn.git && cd DevLearn && ./install.sh
```

**All common agent paths:**

```bash
./install.sh --agent all --verify
```

**Codex / ~/.agents/skills:**

```bash
./install.sh --agent codex --verify
```

**Or from anywhere (clones to `~/DevLearn`):**

```bash
curl -fsSL https://raw.githubusercontent.com/mrdulasolutions/DevLearn/main/install.sh | bash
```

**Into a project (Cursor rule + Codex AGENTS.md + optional repo skills):**

```bash
./install.sh --project ~/code/my-app --copy-rule --copy-agents --project-skills --verify
```

Platform guide: [shared/agent-compatibility.md](shared/agent-compatibility.md)

See [install.sh](install.sh) for all flags (`--agent opencode`, `--agent auto`, `--dry-run`, etc.).

## Optional Cursor rule

Copy [`.cursor/rules/devlearn.example.mdc`](.cursor/rules/devlearn.example.mdc) to your project's `.cursor/rules/devlearn.mdc`.
