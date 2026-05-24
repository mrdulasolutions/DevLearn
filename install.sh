#!/usr/bin/env bash
# DevLearn Installer — macOS / Linux / WSL
# Learn while you vibe: agent skills that teach while they work.
#
# Local:
#   ./install.sh
#
# Remote (once published on GitHub):
#   curl -fsSL https://raw.githubusercontent.com/mrdulasolutions/DevLearn/main/install.sh | bash
#
# Non-interactive:
#   curl -fsSL ... | bash -s -- --no-prompt --agent both --verify

set -euo pipefail

DEVLEARN_TAGLINE="Have your agents teach you to code while they work."
DEVLEARN_REPO="${DEVLEARN_REPO:-https://github.com/mrdulasolutions/DevLearn.git}"
DEVLEARN_BRANCH="${DEVLEARN_BRANCH:-main}"
DEVLEARN_DEFAULT_DIR="${DEVLEARN_DEFAULT_DIR:-$HOME/DevLearn}"

# Colors (OpenClaw-inspired, DevLearn palette)
BOLD='\033[1m'
ACCENT='\033[38;2;56;189;248m'    # sky-400
INFO='\033[38;2;148;163;184m'     # slate-400
SUCCESS='\033[38;2;52;211;153m'   # emerald-400
WARN='\033[38;2;251;191;36m'      # amber-400
ERROR='\033[38;2;248;113;113m'    # red-400
MUTED='\033[38;2;100;116;139m'    # slate-500
NC='\033[0m'

# Defaults
INSTALL_METHOD="auto"   # auto | local | git
GIT_DIR="${DEVLEARN_GIT_DIR:-$DEVLEARN_DEFAULT_DIR}"
AGENT_TARGET="cursor"   # cursor | claude | codex | opencode | agents | factory | kiro | both | all | auto | custom
CUSTOM_SKILLS_DIR=""
PROJECT_DIR=""
COPY_RULE=0
COPY_AGENTS=0
PROJECT_SKILLS=0
INSTALL_TARGETS=()
NO_PROMPT="${DEVLEARN_NO_PROMPT:-0}"
NO_ONBOARD="${DEVLEARN_NO_ONBOARD:-0}"
DRY_RUN="${DEVLEARN_DRY_RUN:-0}"
VERIFY="${DEVLEARN_VERIFY:-0}"
VERBOSE="${DEVLEARN_VERBOSE:-0}"
HELP=0

REPO_ROOT=""
SKILLS_DIR=""
SKILL_COUNT=0
IS_UPGRADE=false
STAGE=0
STAGE_TOTAL=4

TMPFILES=()
cleanup() {
  local f
  for f in "${TMPFILES[@]:-}"; do
    rm -rf "$f" 2>/dev/null || true
  done
}
trap cleanup EXIT

mktempfile() {
  local f
  f="$(mktemp)"
  TMPFILES+=("$f")
  echo "$f"
}

# ── UI helpers ──────────────────────────────────────────────────────────────

is_non_interactive() {
  [[ "$NO_PROMPT" == "1" ]] && return 0
  [[ ! -t 0 || ! -t 1 ]] && return 0
  return 1
}

has_tty() {
  [[ -r /dev/tty && -w /dev/tty ]] && { : >/dev/tty 2>/dev/null; }
}

print_banner() {
  echo -e "${ACCENT}${BOLD}"
  echo "  📚 DevLearn Installer"
  echo -e "${NC}${INFO}  ${DEVLEARN_TAGLINE}${NC}"
  echo ""
}

ui_info()    { echo -e "${MUTED}·${NC} $*"; }
ui_warn()    { echo -e "${WARN}!${NC} $*"; }
ui_success() { echo -e "${SUCCESS}✓${NC} $*"; }
ui_error()   { echo -e "${ERROR}✗${NC} $*" >&2; }

ui_section() {
  echo ""
  echo -e "${ACCENT}${BOLD}$*${NC}"
}

ui_stage() {
  STAGE=$((STAGE + 1))
  ui_section "[${STAGE}/${STAGE_TOTAL}] $*"
}

ui_kv() {
  printf "  ${MUTED}%-18s${NC} %s\n" "$1:" "$2"
}

ui_panel() {
  echo ""
  echo "$1" | sed 's/^/  /'
  echo ""
}

print_usage() {
  cat <<EOF
DevLearn Installer — agent skills that teach while you work

Usage:
  ./install.sh [options]
  curl -fsSL https://raw.githubusercontent.com/mrdulasolutions/DevLearn/main/install.sh | bash
  curl -fsSL ... | bash -s -- --no-prompt --agent both --verify

Options:
  --agent TARGET               Install target (default: cursor). TARGET:
                               cursor, claude, codex, opencode, agents, factory,
                               kiro, both (cursor+claude), all, auto, custom
  --skills-dir PATH            Custom skills directory (implies --agent custom)
  --method local|git|auto      local=use this repo; git=clone/update; auto=detect
  --git-dir PATH               Clone directory (default: ~/DevLearn)
  --project PATH               Copy DEVLEARN.md (+ optional extras) into project
  --copy-rule                  Copy Cursor rule → .cursor/rules/devlearn.mdc
  --copy-agents                Copy AGENTS.md.example → project AGENTS.md (Codex)
  --project-skills             Link skills into project .agents/skills (team/Codex)
  --no-onboard                 Skip friendly next-steps prompts
  --no-prompt                  Non-interactive (CI / pipe from curl)
  --verify                     Verify install after linking skills
  --dry-run                    Show plan only
  --verbose                    Debug output (set -x)
  -h, --help                   Show this help

Environment:
  DEVLEARN_NO_PROMPT=1         Same as --no-prompt
  DEVLEARN_DRY_RUN=1           Same as --dry-run
  DEVLEARN_VERIFY=1            Same as --verify
  DEVLEARN_GIT_DIR=...         Clone directory
  DEVLEARN_REPO=...            Git remote URL
  CURSOR_SKILLS_DIR=...        Override Cursor skills path
  CLAUDE_SKILLS_DIR=...        Override Claude Code skills path
  AGENTS_SKILLS_DIR=...        Override ~/.agents/skills (Codex / Agent Skills)
  OPENCODE_SKILLS_DIR=...      Override OpenCode skills path

Examples:
  ./install.sh
  ./install.sh --agent all --verify
  ./install.sh --agent codex --verify
  ./install.sh --project ~/code/my-app --copy-rule --copy-agents --project-skills
  curl -fsSL https://raw.githubusercontent.com/mrdulasolutions/DevLearn/main/install.sh | bash -s -- --no-prompt --agent all --verify

See shared/agent-compatibility.md for Cursor, Claude, Codex, OpenCode, etc.
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --agent)
        AGENT_TARGET="$2"
        shift 2
        ;;
      --skills-dir)
        CUSTOM_SKILLS_DIR="$2"
        AGENT_TARGET="custom"
        shift 2
        ;;
      --method)
        INSTALL_METHOD="$2"
        shift 2
        ;;
      --git-dir|--dir)
        GIT_DIR="$2"
        shift 2
        ;;
      --project)
        PROJECT_DIR="$2"
        shift 2
        ;;
      --copy-rule)
        COPY_RULE=1
        shift
        ;;
      --copy-agents)
        COPY_AGENTS=1
        shift
        ;;
      --project-skills)
        PROJECT_SKILLS=1
        shift
        ;;
      --no-onboard)
        NO_ONBOARD=1
        shift
        ;;
      --no-prompt)
        NO_PROMPT=1
        shift
        ;;
      --verify)
        VERIFY=1
        shift
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --verbose)
        VERBOSE=1
        shift
        ;;
      -h|--help)
        HELP=1
        shift
        ;;
      *)
        ui_error "Unknown option: $1"
        echo "Run with --help for usage."
        exit 2
        ;;
    esac
  done
}

detect_os() {
  case "${OSTYPE:-unknown}" in
    darwin*) echo "macOS" ;;
    linux-gnu*) echo "Linux" ;;
    *)
      if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
        echo "WSL"
      else
        echo "unknown"
      fi
      ;;
  esac
}

resolve_repo_root() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Running from DevLearn repo (install.sh at root)
  if [[ -d "$script_dir/shared" && -d "$script_dir/devlearn-teach-while-coding" ]]; then
    echo "$script_dir"
    return 0
  fi

  # Running from scripts/install.sh wrapper
  if [[ -d "$script_dir/../shared" ]]; then
    echo "$(cd "$script_dir/.." && pwd)"
    return 0
  fi

  return 1
}

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    ui_success "Git found: $(git --version | head -1)"
    return 0
  fi
  ui_error "Git is required but not installed."
  echo "  macOS: xcode-select --install"
  echo "  Linux: sudo apt install git  (or your package manager)"
  exit 1
}

clone_or_update_repo() {
  ensure_git

  if [[ -d "$GIT_DIR/.git" ]]; then
    ui_info "Updating existing DevLearn checkout at ${GIT_DIR}"
    if [[ "$DRY_RUN" == "1" ]]; then
      ui_info "(dry-run) would git pull in ${GIT_DIR}"
      REPO_ROOT="$GIT_DIR"
      return 0
    fi
    git -C "$GIT_DIR" fetch origin "$DEVLEARN_BRANCH" --quiet 2>/dev/null || true
    git -C "$GIT_DIR" checkout "$DEVLEARN_BRANCH" --quiet 2>/dev/null || true
    git -C "$GIT_DIR" pull --ff-only origin "$DEVLEARN_BRANCH" --quiet 2>/dev/null || {
      ui_warn "Could not fast-forward; using existing checkout"
    }
    ui_success "DevLearn repo ready at ${GIT_DIR}"
    REPO_ROOT="$GIT_DIR"
    return 0
  fi

  ui_info "Cloning DevLearn to ${GIT_DIR}"
  if [[ "$DRY_RUN" == "1" ]]; then
    ui_info "(dry-run) would git clone ${DEVLEARN_REPO} ${GIT_DIR}"
    REPO_ROOT="$GIT_DIR"
    return 0
  fi

  mkdir -p "$(dirname "$GIT_DIR")"
  git clone --depth 1 --branch "$DEVLEARN_BRANCH" "$DEVLEARN_REPO" "$GIT_DIR"
  ui_success "Cloned DevLearn to ${GIT_DIR}"
  REPO_ROOT="$GIT_DIR"
}

resolve_install_source() {
  local detected=""
  detected="$(resolve_repo_root 2>/dev/null || true)"

  if [[ "$INSTALL_METHOD" == "git" ]]; then
    clone_or_update_repo
    return 0
  fi

  if [[ "$INSTALL_METHOD" == "local" ]]; then
    if [[ -z "$detected" ]]; then
      ui_error "Not inside DevLearn repo. Use --method git or run from a clone."
      exit 1
    fi
    REPO_ROOT="$detected"
    ui_success "Using local DevLearn repo: ${REPO_ROOT}"
    return 0
  fi

  # auto
  if [[ -n "$detected" ]]; then
    REPO_ROOT="$detected"
    ui_success "Using local DevLearn repo: ${REPO_ROOT}"
    return 0
  fi

  ui_info "No local repo detected — cloning from GitHub"
  INSTALL_METHOD="git"
  clone_or_update_repo
}

pick_agent_target_interactive() {
  if is_non_interactive; then
    return 0
  fi
  if ! has_tty; then
    return 0
  fi

  echo ""
  echo -e "${BOLD}Where should DevLearn skills live?${NC}"
  echo "  1) Cursor           (~/.cursor/skills)              [default]"
  echo "  2) Claude Code      (~/.claude/skills)"
  echo "  3) Codex / Agents   (~/.agents/skills)"
  echo "  4) OpenCode         (~/.config/opencode/skills)"
  echo "  5) All common       (Cursor + Claude + Agents + OpenCode)"
  echo "  6) Auto-detect      (installed CLIs)"
  echo "  7) Custom path"
  echo ""
  printf "Choose [1-7]: "
  read -r choice </dev/tty || return 0

  case "${choice:-1}" in
    1|"") AGENT_TARGET="cursor" ;;
    2) AGENT_TARGET="claude" ;;
    3) AGENT_TARGET="codex" ;;
    4) AGENT_TARGET="opencode" ;;
    5) AGENT_TARGET="all" ;;
    6) AGENT_TARGET="auto" ;;
    7)
      AGENT_TARGET="custom"
      printf "Skills directory path: "
      read -r CUSTOM_SKILLS_DIR </dev/tty || CUSTOM_SKILLS_DIR=""
      ;;
    *) ui_warn "Invalid choice; using Cursor" ;;
  esac
}

pick_project_interactive() {
  if [[ -n "$PROJECT_DIR" || "$NO_ONBOARD" == "1" ]]; then
    return 0
  fi
  if is_non_interactive || ! has_tty; then
    return 0
  fi

  echo ""
  printf "Enable DevLearn in a project now? Enter project path (or press Enter to skip): "
  read -r ans </dev/tty || return 0
  if [[ -n "${ans:-}" ]]; then
    PROJECT_DIR="${ans/#\~/$HOME}"
    printf "Also install Cursor rule (.cursor/rules/devlearn.mdc)? [y/N]: "
    read -r rule </dev/tty || return 0
    case "${rule:-n}" in
      y|Y|yes|Yes) COPY_RULE=1 ;;
    esac
  fi
}

skills_dir_for_agent() {
  case "$1" in
    cursor)   echo "${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}" ;;
    claude)   echo "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}" ;;
    codex)    echo "${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}" ;;
    agents)   echo "${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}" ;;
    opencode) echo "${OPENCODE_SKILLS_DIR:-$HOME/.config/opencode/skills}" ;;
    factory)  echo "${FACTORY_SKILLS_DIR:-$HOME/.factory/skills}" ;;
    kiro)     echo "${KIRO_SKILLS_DIR:-$HOME/.kiro/skills}" ;;
    *) echo "$2" ;;
  esac
}

# Append path to INSTALL_TARGETS if not already present
add_install_target() {
  local path="$1"
  local existing
  [[ -n "$path" ]] || return 0
  for existing in "${INSTALL_TARGETS[@]:-}"; do
    [[ "$existing" == "$path" ]] && return 0
  done
  INSTALL_TARGETS+=("$path")
}

detect_auto_agents() {
  ui_info "Auto-detecting agent environments..."
  add_install_target "$(skills_dir_for_agent cursor)"
  command -v claude >/dev/null 2>&1 && add_install_target "$(skills_dir_for_agent claude)"
  command -v codex >/dev/null 2>&1 && add_install_target "$(skills_dir_for_agent codex)"
  command -v opencode >/dev/null 2>&1 && add_install_target "$(skills_dir_for_agent opencode)"
  command -v droid >/dev/null 2>&1 && add_install_target "$(skills_dir_for_agent factory)"
  command -v kiro-cli >/dev/null 2>&1 && add_install_target "$(skills_dir_for_agent kiro)"
  if [[ ${#INSTALL_TARGETS[@]} -eq 0 ]]; then
    add_install_target "$(skills_dir_for_agent cursor)"
  fi
}

resolve_install_targets() {
  INSTALL_TARGETS=()
  case "$AGENT_TARGET" in
    cursor|claude|codex|agents|opencode|factory|kiro)
      add_install_target "$(skills_dir_for_agent "$AGENT_TARGET")"
      ;;
    both)
      add_install_target "$(skills_dir_for_agent cursor)"
      add_install_target "$(skills_dir_for_agent claude)"
      ;;
    all)
      add_install_target "$(skills_dir_for_agent cursor)"
      add_install_target "$(skills_dir_for_agent claude)"
      add_install_target "$(skills_dir_for_agent codex)"
      add_install_target "$(skills_dir_for_agent opencode)"
      ;;
    auto)
      detect_auto_agents
      ;;
    custom)
      if [[ -z "$CUSTOM_SKILLS_DIR" ]]; then
        ui_error "Custom install requires --skills-dir PATH"
        exit 1
      fi
      add_install_target "$CUSTOM_SKILLS_DIR"
      ;;
    *)
      ui_error "Invalid --agent: ${AGENT_TARGET}"
      ui_error "Valid: cursor, claude, codex, opencode, agents, factory, kiro, both, all, auto, custom"
      exit 2
      ;;
  esac
}

show_install_plan() {
  resolve_install_targets
  ui_section "Install plan"
  ui_kv "OS" "$(detect_os)"
  ui_kv "Method" "$INSTALL_METHOD"
  ui_kv "Repo" "${REPO_ROOT:-pending}"
  ui_kv "Agent target" "$AGENT_TARGET"
  local t
  for t in "${INSTALL_TARGETS[@]}"; do
    ui_kv "Skills dir" "$t"
  done
  [[ -n "$PROJECT_DIR" ]] && ui_kv "Project setup" "$PROJECT_DIR"
  [[ "$COPY_RULE" == "1" ]] && ui_kv "Cursor rule" "yes"
  [[ "$COPY_AGENTS" == "1" ]] && ui_kv "AGENTS.md (Codex)" "yes"
  [[ "$PROJECT_SKILLS" == "1" ]] && ui_kv "Project .agents/skills" "yes"
  [[ "$DRY_RUN" == "1" ]] && ui_kv "Dry run" "yes"
  [[ "$VERIFY" == "1" ]] && ui_kv "Verify" "yes"
}

link_skills_to_dir() {
  local target="$1"
  local name dir

  if [[ -z "$target" ]]; then
    ui_error "Skills directory is empty"
    return 1
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    ui_info "(dry-run) would link skills to ${target}"
    return 0
  fi

  mkdir -p "$target"

  if [[ -L "$target/shared" || -d "$target/shared" ]]; then
    IS_UPGRADE=true
  fi

  ln -sfn "$REPO_ROOT/shared" "$target/shared"

  SKILL_COUNT=0
  for dir in "$REPO_ROOT"/devlearn-*/; do
    [[ -d "$dir" ]] || continue
    name="$(basename "$dir")"
    ln -sfn "$dir" "$target/$name"
    SKILL_COUNT=$((SKILL_COUNT + 1))
  done

  ui_success "Linked ${SKILL_COUNT} skills + shared → ${target}"
}

install_skills() {
  resolve_install_targets
  local target
  for target in "${INSTALL_TARGETS[@]}"; do
    link_skills_to_dir "$target"
  done
  SKILLS_DIR="${INSTALL_TARGETS[0]}"
}

setup_project() {
  [[ -n "$PROJECT_DIR" ]] || return 0

  if [[ ! -d "$PROJECT_DIR" ]]; then
    ui_warn "Project path does not exist: ${PROJECT_DIR} (skipping project setup)"
    return 0
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    ui_info "(dry-run) would copy DEVLEARN.md to ${PROJECT_DIR}"
    [[ "$COPY_RULE" == "1" ]] && ui_info "(dry-run) would copy Cursor rule"
    return 0
  fi

  cp "$REPO_ROOT/DEVLEARN.md" "$PROJECT_DIR/DEVLEARN.md"
  ui_success "Copied DEVLEARN.md → ${PROJECT_DIR}/"

  mkdir -p "$PROJECT_DIR/.devlearn"
  if [[ ! -f "$PROJECT_DIR/.devlearn/progress.md" ]]; then
    cp "$REPO_ROOT/.devlearn/progress-template.md" "$PROJECT_DIR/.devlearn/progress.md" 2>/dev/null || true
  fi

  if [[ "$COPY_RULE" == "1" ]]; then
    mkdir -p "$PROJECT_DIR/.cursor/rules"
    cp "$REPO_ROOT/.cursor/rules/devlearn.example.mdc" "$PROJECT_DIR/.cursor/rules/devlearn.mdc"
    ui_success "Copied Cursor rule → ${PROJECT_DIR}/.cursor/rules/devlearn.mdc"
  fi

  if [[ "$COPY_AGENTS" == "1" ]]; then
    if [[ ! -f "$PROJECT_DIR/AGENTS.md" ]]; then
      cp "$REPO_ROOT/AGENTS.md.example" "$PROJECT_DIR/AGENTS.md"
      ui_success "Copied AGENTS.md → ${PROJECT_DIR}/AGENTS.md (Codex ambient teaching)"
    else
      ui_warn "AGENTS.md already exists — merge DevLearn section manually (see AGENTS.md.example)"
    fi
  fi

  if [[ "$PROJECT_SKILLS" == "1" ]]; then
    link_skills_to_dir "$PROJECT_DIR/.agents/skills"
    ui_success "Linked skills → ${PROJECT_DIR}/.agents/skills (repo-local for Codex/OpenCode)"
  fi
}

verify_install() {
  ui_stage "Verifying install"

  if [[ "$DRY_RUN" == "1" ]]; then
    ui_info "(dry-run) would verify install targets"
    return 0
  fi

  resolve_install_targets
  local target ok=true count
  for target in "${INSTALL_TARGETS[@]}"; do
    ui_info "Checking ${target}..."
    if [[ ! -f "$target/shared/voice.md" ]]; then
      ui_error "Missing ${target}/shared/voice.md"
      ok=false
    else
      ui_success "shared/voice.md present"
    fi

    if [[ ! -f "$target/devlearn-teach-while-coding/SKILL.md" ]]; then
      ui_error "Missing meta skill at ${target}"
      ok=false
    else
      ui_success "Meta skill present"
    fi

    count="$(find "$target" -maxdepth 1 \( -type l -o -type d \) -name 'devlearn-*' 2>/dev/null | wc -l | tr -d ' ')"
    if [[ "${count:-0}" -lt 5 ]]; then
      ui_warn "Only ${count} devlearn-* skills at ${target} (expected 15+)"
    else
      ui_success "${count} devlearn-* skills at ${target}"
    fi
  done

  if [[ -x "$REPO_ROOT/scripts/validate-skills.sh" ]]; then
    ui_info "Running skill spec validation..."
    if bash "$REPO_ROOT/scripts/validate-skills.sh"; then
      ui_success "Skill frontmatter validation passed"
    else
      ui_error "Skill validation failed — run scripts/validate-skills.sh"
      ok=false
    fi
  fi

  if [[ "$ok" != "true" ]]; then
    ui_error "Verification failed"
    exit 1
  fi

  ui_success "DevLearn install verified"
}

print_next_steps() {
  local onboard_hint project_hint

  [[ ${#INSTALL_TARGETS[@]} -gt 0 ]] || resolve_install_targets

  ui_section "You're ready to learn while you vibe"

  if [[ "$IS_UPGRADE" == "true" ]]; then
    echo -e "  ${MUTED}DevLearn skills updated. Restart your agent or start a new chat.${NC}"
  else
    echo -e "  ${SUCCESS}${BOLD}DevLearn installed successfully!${NC}"
  fi

  local targets_list=""
  local t
  for t in "${INSTALL_TARGETS[@]}"; do
    targets_list="${targets_list}     - ${t}"$'\n'
  done

  ui_panel "$(cat <<EOF
Next steps:

  1. Skills installed to:
${targets_list}
  2. In any project, enable teaching:
     /devlearn-onboard   (Cursor / Claude slash)
     or "use devlearn-onboard skill" (Codex / OpenCode)

  3. Copy config into a project:
     cp "${REPO_ROOT}/DEVLEARN.md" /path/to/your/project/
     ./install.sh --project /path/to/app --copy-rule --copy-agents

  4. Codex users: AGENTS.md in project root points at ambient teaching
     (use --copy-agents or copy AGENTS.md.example)

  5. Release day skill chain:
     devlearn-pre-ship → devlearn-security → devlearn-deploy → devlearn-post-ship

  Platform guide: ${REPO_ROOT}/shared/agent-compatibility.md
  Docs: ${REPO_ROOT}/README.md
EOF
)"

  if [[ -n "$PROJECT_DIR" && -f "$PROJECT_DIR/DEVLEARN.md" ]]; then
    ui_success "Project enabled: ${PROJECT_DIR}"
    echo -e "  ${MUTED}Tell your agent: \"Build something and teach me while you work\"${NC}"
  fi

  echo -e "  ${INFO}FAQ / issues:${NC} https://github.com/mrdulasolutions/DevLearn"
  echo ""
}

main() {
  if [[ "$HELP" == "1" ]]; then
    print_usage
    exit 0
  fi

  [[ "$VERBOSE" == "1" ]] && set -x

  print_banner

  local os
  os="$(detect_os)"
  if [[ "$os" == "unknown" ]]; then
    ui_error "Unsupported OS. DevLearn installer supports macOS, Linux, and WSL."
    exit 1
  fi
  ui_success "Detected: ${os}"

  ui_stage "Finding DevLearn"
  resolve_install_source

  if [[ ! -d "$REPO_ROOT/shared" ]]; then
    ui_error "Invalid DevLearn repo (missing shared/): ${REPO_ROOT}"
    exit 1
  fi

  pick_agent_target_interactive
  pick_project_interactive

  show_install_plan

  if [[ "$DRY_RUN" == "1" ]]; then
    ui_success "Dry run complete — no changes made"
    exit 0
  fi

  ui_stage "Installing skills"
  install_skills

  ui_stage "Project setup (optional)"
  setup_project

  if [[ "$VERIFY" == "1" ]]; then
    verify_install
  fi

  if [[ "$NO_ONBOARD" != "1" ]]; then
    print_next_steps
  else
    ui_success "Done. ${SKILL_COUNT} skills installed → ${SKILLS_DIR:-skills dir}"
  fi
}

parse_args "$@"
main "$@"
