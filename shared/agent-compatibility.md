# DevLearn agent compatibility

DevLearn skills use the **Agent Skills** format: one folder per skill with `SKILL.md` (YAML frontmatter + markdown body). The same files work across agents; only **install location** and **how you invoke** a skill differ.

## Supported agents

| Agent | Global skills path | Project skills path | Ambient config |
|-------|-------------------|---------------------|----------------|
| **Cursor** | `~/.cursor/skills/` | `.cursor/skills/` | `.cursor/rules/devlearn.mdc` + `DEVLEARN.md` |
| **Claude Code** | `~/.claude/skills/` | `.claude/skills/` | `DEVLEARN.md` |
| **Codex CLI** | `~/.agents/skills/` | `.agents/skills/` | `AGENTS.md` + `DEVLEARN.md` |
| **OpenCode** | `~/.config/opencode/skills/` | `.opencode/skills/` | `DEVLEARN.md` (also reads `.claude/` + `.agents/`) |
| **Factory Droid** | `~/.factory/skills/` | — | `DEVLEARN.md` |
| **Kiro CLI** | `~/.kiro/skills/` | — | `DEVLEARN.md` |

OpenCode also discovers skills in `~/.claude/skills/` and `~/.agents/skills/` — installing to **agents** helps both Codex and OpenCode.

## Install (all platforms)

```bash
git clone https://github.com/mrdulasolutions/DevLearn.git && cd DevLearn && ./install.sh
```

Interactive menu picks your agent(s). Non-interactive examples:

```bash
# Cursor only (default)
./install.sh --no-prompt --agent cursor --verify

# Claude Code
./install.sh --no-prompt --agent claude --verify

# Codex / Agent Skills spec (~/.agents/skills)
./install.sh --no-prompt --agent codex --verify

# OpenCode native path
./install.sh --no-prompt --agent opencode --verify

# All common paths (Cursor + Claude + Agents + OpenCode)
./install.sh --no-prompt --agent all --verify

# Auto-detect installed CLIs
./install.sh --no-prompt --agent auto --verify

# Team project: config + repo-local skills for Codex/OpenCode
./install.sh --project ~/code/my-app --copy-agents --project-skills --verify
```

## How to invoke skills

| Agent | Explicit invoke | Discovery |
|-------|-----------------|-----------|
| **Cursor** | `/devlearn-onboard` in chat | Agent reads skill `description` from frontmatter |
| **Claude Code** | `/devlearn-onboard` or "use devlearn-onboard" | Same — description triggers |
| **Codex** | "Use the devlearn-onboard skill" or skill picker | Metadata preloaded; body on selection |
| **OpenCode** | Native `skill` tool with `name: devlearn-onboard` | Listed in `<available_skills>` |

Skill folder name and frontmatter `name:` must match (e.g. `devlearn-onboard`).

## Shared `../shared/` links

Each skill references `../shared/voice.md` etc. The installer symlinks:

```
~/.cursor/skills/shared → /path/to/DevLearn/shared
~/.cursor/skills/devlearn-onboard → /path/to/DevLearn/devlearn-onboard
```

Because symlinks point at the repo, relative paths inside skill files resolve correctly on **all** platforms.

## Project files (any agent)

| File | Purpose |
|------|---------|
| `DEVLEARN.md` | Persona, depth, lifecycle flags — **required for teaching** |
| `DEVLEARN_GLOSSARY.md` | Session vocabulary |
| `.devlearn/progress.md` | Session memory |
| `.devlearn/decisions.md` | ADR-lite (seasoned) |

Optional per agent:

| File | Agent |
|------|-------|
| `.cursor/rules/devlearn.mdc` | Cursor ambient teaching |
| `AGENTS.md` | Codex — points at `devlearn-teach-while-coding` when `DEVLEARN.md` enabled |
| `.agents/skills/` | Codex repo-local skills (use `--project-skills`) |
| `.opencode/skills/` | OpenCode repo-local (same as `.agents/` if you use project install) |

## Skill name rules (OpenCode / Codex)

- 1–64 chars, lowercase alphanumeric + single hyphens
- Must match directory name: `devlearn-onboard/SKILL.md` → `name: devlearn-onboard`
- `description` 1–1024 chars

Run `./scripts/validate-skills.sh` before release.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Skill not listed | Re-run `./install.sh --verify`; restart agent / new session |
| `../shared/` not found | Re-install — `shared` symlink missing in skills dir |
| Lessons not ambient | Add `DEVLEARN.md` with `enabled: true`; Cursor needs rule too |
| Codex ignores teaching | Copy `AGENTS.md.example` → project `AGENTS.md` |
| Duplicate skills in Codex | Install to `agents` OR `codex` path, not both with different copies |

## Environment overrides

```bash
export CURSOR_SKILLS_DIR=~/.cursor/skills
export CLAUDE_SKILLS_DIR=~/.claude/skills
export AGENTS_SKILLS_DIR=~/.agents/skills
export OPENCODE_SKILLS_DIR=~/.config/opencode/skills
export FACTORY_SKILLS_DIR=~/.factory/skills
export KIRO_SKILLS_DIR=~/.kiro/skills
```
