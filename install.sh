#!/usr/bin/env bash
# DevLearn Installer — macOS / Linux / WSL
# Guided setup: clone/find repo, pick agent harnesses, save settings for reruns.
#
#   ./install.sh                    Interactive wizard
#   ./install.sh --settings         Change saved harnesses / paths
#   ./install.sh --repair           Relink skills (uses saved config or auto-detect)
#   ./install.sh --upgrade          Same as --repair
#   ./install.sh --uninstall        Remove DevLearn symlinks only
#
#   curl -fsSL .../install.sh | bash
#   curl -fsSL ... | bash -s -- --no-prompt --harnesses cursor,codex --verify

set -euo pipefail

DEVLEARN_TAGLINE="Have your agents teach you to code while they work."
DEVLEARN_REPO="${DEVLEARN_REPO:-https://github.com/mrdulasolutions/DevLearn.git}"
DEVLEARN_BRANCH="${DEVLEARN_BRANCH:-main}"
DEVLEARN_DEFAULT_DIR="${DEVLEARN_DEFAULT_DIR:-$HOME/DevLearn}"
DEVLEARN_CONFIG_DIR="${DEVLEARN_CONFIG_DIR:-$HOME/.devlearn}"
DEVLEARN_CONFIG_FILE="${DEVLEARN_CONFIG_FILE:-$DEVLEARN_CONFIG_DIR/install.conf}"
MIN_SKILL_COUNT=15

# Colors
BOLD='\033[1m'
ACCENT='\033[38;2;56;189;248m'
INFO='\033[38;2;148;163;184m'
SUCCESS='\033[38;2;52;211;153m'
WARN='\033[38;2;251;191;36m'
ERROR='\033[38;2;248;113;113m'
MUTED='\033[38;2;100;116;139m'
NC='\033[0m'

# Harness registry (id|label|default_skills_path)
HARNESS_IDS=(cursor claude codex opencode factory kiro)
HARNESS_LABELS=(Cursor "Claude Code" "Codex / Agents" OpenCode Factory Kiro)

# Runtime state
INSTALL_METHOD="auto"
GIT_DIR="${DEVLEARN_GIT_DIR:-$DEVLEARN_DEFAULT_DIR}"
SELECTED_HARNESSES=()
INSTALL_TARGETS=()
CUSTOM_SKILLS_DIR=""
PROJECT_DIR=""
COPY_RULE=0
COPY_AGENTS=0
PROJECT_SKILLS=0
NO_PROMPT="${DEVLEARN_NO_PROMPT:-0}"
NO_ONBOARD="${DEVLEARN_NO_ONBOARD:-0}"
DRY_RUN="${DEVLEARN_DRY_RUN:-0}"
VERIFY="${DEVLEARN_VERIFY:-0}"
VERBOSE="${DEVLEARN_VERBOSE:-0}"
YES=0
HELP=0
MODE="install"   # install | settings | repair | uninstall | reset
AGENT_TARGET=""  # legacy CLI alias → mapped to harnesses

REPO_ROOT=""
SKILLS_DIR=""
SKILL_COUNT=0
IS_UPGRADE=false
STAGE=0
STAGE_TOTAL=6
WIZARD_ACTION="install"  # install | upgrade | settings | uninstall | fresh

TMPFILES=()
cleanup() {
  local f
  for f in "${TMPFILES[@]:-}"; do
    rm -rf "$f" 2>/dev/null || true
  done
}
trap cleanup EXIT

# ── UI ──────────────────────────────────────────────────────────────────────

is_non_interactive() {
  [[ "$NO_PROMPT" == "1" ]] && return 0
  [[ ! -t 0 || ! -t 1 ]] && return 0
  return 1
}

has_tty() {
  [[ -r /dev/tty && -w /dev/tty ]] && { : >/dev/tty 2>/dev/null; }
}

read_tty() {
  local prompt="$1"
  local var="$2"
  if has_tty; then
    printf "%s" "$prompt" >/dev/tty
    read -r "$var" </dev/tty || true
  fi
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
  printf "  ${MUTED}%-20s${NC} %s\n" "$1:" "$2"
}

ui_panel() {
  echo ""
  echo "$1" | sed 's/^/  /'
  echo ""
}

# ── Config (~/.devlearn/install.conf) ───────────────────────────────────────

config_ensure_dir() {
  mkdir -p "$DEVLEARN_CONFIG_DIR"
}

config_get() {
  local key="$1"
  [[ -f "$DEVLEARN_CONFIG_FILE" ]] || return 1
  grep -E "^${key}=" "$DEVLEARN_CONFIG_FILE" 2>/dev/null | tail -1 | cut -d= -f2- || return 1
}

config_set() {
  local key="$1" val="$2"
  local tmp
  config_ensure_dir
  tmp="$(mktemp)"
  if [[ -f "$DEVLEARN_CONFIG_FILE" ]]; then
    grep -v -E "^${key}=" "$DEVLEARN_CONFIG_FILE" >"$tmp" 2>/dev/null || true
  else
    : >"$tmp"
  fi
  printf '%s=%s\n' "$key" "$val" >>"$tmp"
  mv "$tmp" "$DEVLEARN_CONFIG_FILE"
  chmod 600 "$DEVLEARN_CONFIG_FILE" 2>/dev/null || true
}

config_load() {
  local h
  [[ -f "$DEVLEARN_CONFIG_FILE" ]] || return 1
  REPO_ROOT="$(config_get repo_dir || true)"
  GIT_DIR="${REPO_ROOT:-$GIT_DIR}"
  PROJECT_DIR="$(config_get project_dir || true)"
  COPY_RULE=0; COPY_AGENTS=0; PROJECT_SKILLS=0
  [[ "$(config_get copy_rule || echo false)" == "true" ]] && COPY_RULE=1
  [[ "$(config_get copy_agents || echo false)" == "true" ]] && COPY_AGENTS=1
  [[ "$(config_get project_skills || echo false)" == "true" ]] && PROJECT_SKILLS=1
  h="$(config_get harnesses || true)"
  if [[ -n "$h" ]]; then
    IFS=',' read -ra SELECTED_HARNESSES <<<"$h"
  fi
  return 0
}

config_save() {
  config_ensure_dir
  config_set repo_dir "$REPO_ROOT"
  config_set harnesses "$(IFS=,; echo "${SELECTED_HARNESSES[*]}")"
  config_set project_dir "${PROJECT_DIR:-}"
  config_set copy_rule "$([[ "$COPY_RULE" == "1" ]] && echo true || echo false)"
  config_set copy_agents "$([[ "$COPY_AGENTS" == "1" ]] && echo true || echo false)"
  config_set project_skills "$([[ "$PROJECT_SKILLS" == "1" ]] && echo true || echo false)"
  config_set installed_at "$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u)"
  ui_success "Settings saved → ${DEVLEARN_CONFIG_FILE}"
}

config_exists() {
  [[ -f "$DEVLEARN_CONFIG_FILE" ]]
}

# ── Repo validation (strict — no /Users false positives) ────────────────────

is_piped_install() {
  local src="${BASH_SOURCE[0]:-}"
  [[ "$src" == "-" || "$src" == "bash" || "$src" == "sh" ]] && return 0
  [[ "$src" == /dev/fd/* || "$src" == /proc/self/fd/* ]] && return 0
  [[ -n "$src" && -f "$src" ]] && return 1
  return 0
}

is_blocklisted_repo_path() {
  local p="$1"
  local norm
  norm="$(cd "$p" 2>/dev/null && pwd -P)" || return 0
  case "$norm" in
    /|/Users|/tmp|/var|/etc|/System|/Library|/private|/Volumes)
      return 0 ;;
  esac
  # macOS /Users/Shared must not count as DevLearn repo root
  if [[ "$(uname -s 2>/dev/null)" == "Darwin" ]]; then
    [[ "$norm" == "/Users/Shared" || "$norm" == "/Users/shared" ]] && return 0
  fi
  return 1
}

count_devlearn_skills() {
  local root="$1"
  find "$root" -maxdepth 1 -type d -name 'devlearn-*' 2>/dev/null | wc -l | tr -d ' '
}

validate_repo_root() {
  local root="$1"
  local count

  [[ -n "$root" && -d "$root" ]] || return 1
  is_blocklisted_repo_path "$root" && return 1
  [[ -f "$root/install.sh" ]] || return 1
  [[ -f "$root/shared/voice.md" ]] || return 1
  [[ -f "$root/devlearn-teach-while-coding/SKILL.md" ]] || return 1
  [[ -x "$root/scripts/validate-skills.sh" || -f "$root/scripts/validate-skills.sh" ]] || return 1
  count="$(count_devlearn_skills "$root")"
  [[ "${count:-0}" -ge "$MIN_SKILL_COUNT" ]] || return 1
  return 0
}

require_valid_repo() {
  local root="$1"
  local msg="${2:-Invalid DevLearn repo}"

  validate_repo_root "$root" && return 0
  if [[ "$DRY_RUN" == "1" ]]; then
    ui_info "Dry run — ${msg} (${root} would be created or updated)"
    return 0
  fi
  ui_error "$msg"
  exit 1
}

# Resolve symlinks to an absolute path (macOS/Linux, no readlink -f required).
real_path() {
  local p="$1" dir base target
  [[ -n "$p" ]] || return 1
  while [[ -L "$p" ]]; do
    dir="$(cd "$(dirname "$p")" && pwd)"
    base="$(basename "$p")"
    target="$(readlink "$p" 2>/dev/null || true)"
    [[ -n "$target" ]] || return 1
    [[ "$target" == /* ]] && p="$target" || p="$dir/$target"
  done
  if [[ -d "$p" ]]; then
    (cd "$p" && pwd -P)
  else
    echo "$(cd "$(dirname "$p")" && pwd -P)/$(basename "$p")"
  fi
}

# Infer DevLearn repo root from an installed skills directory.
repo_from_skills_target() {
  local target="$1" marker="" resolved="" repo=""
  [[ -d "$target" || -L "$target" ]] || return 1
  for marker in devlearn-teach-while-coding devlearn-onboard shared; do
    [[ -e "$target/$marker" ]] || continue
    resolved="$(real_path "$target/$marker" 2>/dev/null || true)"
    [[ -n "$resolved" ]] || continue
    repo="$(dirname "$resolved")"
    validate_repo_root "$repo" && { echo "$repo"; return 0; }
  done
  return 1
}

# Find harnesses that already have DevLearn symlinks installed.
detect_harnesses_from_symlinks() {
  local id path
  SELECTED_HARNESSES=()
  for id in "${HARNESS_IDS[@]}"; do
    path="$(skills_dir_for_harness "$id")"
    if [[ -e "$path/devlearn-teach-while-coding" || -e "$path/shared" ]]; then
      SELECTED_HARNESSES+=("$id")
    fi
  done
  [[ ${#SELECTED_HARNESSES[@]} -gt 0 ]]
}

# Load saved config, or infer repo + harnesses from disk (for --repair after git pull).
recover_install_state() {
  local id path repo="" detected=""

  config_exists && config_load && return 0

  map_legacy_agent_target
  detect_harnesses_from_symlinks || true

  for id in "${HARNESS_IDS[@]}"; do
    path="$(skills_dir_for_harness "$id")"
    repo="$(repo_from_skills_target "$path" 2>/dev/null || true)"
    [[ -n "$repo" ]] && break
  done

  if [[ -z "$repo" ]]; then
    detected="$(resolve_script_repo 2>/dev/null || true)"
    validate_repo_root "$detected" && repo="$detected"
  fi

  [[ -n "$repo" ]] || return 1
  REPO_ROOT="$repo"
  GIT_DIR="$repo"

  if [[ ${#SELECTED_HARNESSES[@]} -eq 0 ]]; then
    for id in "${HARNESS_IDS[@]}"; do
      harness_detected "$id" && SELECTED_HARNESSES+=("$id")
    done
    [[ ${#SELECTED_HARNESSES[@]} -eq 0 ]] && SELECTED_HARNESSES=(cursor)
  fi

  return 0
}

repair_usage_hint() {
  ui_info "First install: ./install.sh"
  ui_info "Or non-interactive: ./install.sh --no-prompt --method local --harnesses cursor --verify"
}

resolve_script_repo() {
  local src="${BASH_SOURCE[0]:-}"
  local script_dir="" candidate=""

  is_piped_install && return 1

  script_dir="$(cd "$(dirname "$src")" && pwd)"
  if validate_repo_root "$script_dir"; then
    echo "$script_dir"
    return 0
  fi
  candidate="$(cd "$script_dir/.." && pwd)"
  if validate_repo_root "$candidate"; then
    echo "$candidate"
    return 0
  fi
  return 1
}

find_candidate_repos() {
  local candidates=() c seen=""
  add_unique() {
    local p="$1"
    [[ -n "$p" && -d "$p" ]] || return 0
    validate_repo_root "$p" || return 0
    [[ " $seen " == *" $p "* ]] && return 0
    candidates+=("$p")
    seen="$seen $p"
  }

  add_unique "$(resolve_script_repo 2>/dev/null || true)"
  add_unique "$GIT_DIR"
  config_exists && add_unique "$(config_get repo_dir 2>/dev/null || true)"
  add_unique "$HOME/DevLearn"
  # Only trust cwd if not piped and not blocklisted
  if ! is_piped_install; then
    add_unique "$(pwd 2>/dev/null || true)"
  fi

  printf '%s\n' "${candidates[@]:-}"
}

repo_short_commit() {
  git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown"
}

# ── Harness paths ───────────────────────────────────────────────────────────

skills_dir_for_harness() {
  case "$1" in
    cursor)   echo "${CURSOR_SKILLS_DIR:-$HOME/.cursor/skills}" ;;
    claude)   echo "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}" ;;
    codex)    echo "${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}" ;;
    opencode) echo "${OPENCODE_SKILLS_DIR:-$HOME/.config/opencode/skills}" ;;
    factory)  echo "${FACTORY_SKILLS_DIR:-$HOME/.factory/skills}" ;;
    kiro)     echo "${KIRO_SKILLS_DIR:-$HOME/.kiro/skills}" ;;
    *) echo "" ;;
  esac
}

harness_label() {
  local i id="$1"
  for i in "${!HARNESS_IDS[@]}"; do
    [[ "${HARNESS_IDS[$i]}" == "$id" ]] && { echo "${HARNESS_LABELS[$i]}"; return; }
  done
  echo "$id"
}

harness_detected() {
  case "$1" in
    cursor)   return 0 ;;
    claude)   command -v claude >/dev/null 2>&1 ;;
    codex)    command -v codex >/dev/null 2>&1 ;;
    opencode) command -v opencode >/dev/null 2>&1 ;;
    factory)  command -v droid >/dev/null 2>&1 ;;
    kiro)     command -v kiro-cli >/dev/null 2>&1 ;;
    *) return 1 ;;
  esac
}

harness_is_selected() {
  local id="$1" h
  for h in "${SELECTED_HARNESSES[@]:-}"; do
    [[ "$h" == "$id" ]] && return 0
  done
  return 1
}

harness_toggle() {
  local id="$1"
  if harness_is_selected "$id"; then
    SELECTED_HARNESSES=("${SELECTED_HARNESSES[@]/$id/}")
    # bash array remove empty - rebuild
    local next=() h
    for h in "${SELECTED_HARNESSES[@]:-}"; do
      [[ -n "$h" ]] && next+=("$h")
    done
    SELECTED_HARNESSES=("${next[@]}")
  else
    SELECTED_HARNESSES+=("$id")
  fi
}

resolve_install_targets() {
  INSTALL_TARGETS=()
  local id path existing
  for id in "${SELECTED_HARNESSES[@]:-}"; do
    path="$(skills_dir_for_harness "$id")"
    [[ -n "$path" ]] || continue
    for existing in "${INSTALL_TARGETS[@]:-}"; do
      [[ "$existing" == "$path" ]] && continue 2
    done
    INSTALL_TARGETS+=("$path")
  done
  if [[ -n "$CUSTOM_SKILLS_DIR" ]]; then
    INSTALL_TARGETS+=("$CUSTOM_SKILLS_DIR")
  fi
}

map_legacy_agent_target() {
  [[ -n "$AGENT_TARGET" ]] || return 0
  case "$AGENT_TARGET" in
    cursor|claude|codex|opencode|factory|kiro)
      SELECTED_HARNESSES=("$AGENT_TARGET") ;;
    both)
      SELECTED_HARNESSES=(cursor claude) ;;
    all)
      SELECTED_HARNESSES=(cursor claude codex opencode) ;;
    agents|codex)
      SELECTED_HARNESSES=(codex) ;;
    auto)
      SELECTED_HARNESSES=()
      local id
      for id in "${HARNESS_IDS[@]}"; do
        harness_detected "$id" && SELECTED_HARNESSES+=("$id")
      done
      [[ ${#SELECTED_HARNESSES[@]} -eq 0 ]] && SELECTED_HARNESSES=(cursor) ;;
    custom)
      : ;;
    *)
      ui_error "Unknown --agent value: ${AGENT_TARGET}"
      exit 2
      ;;
  esac
}

# ── Git / clone ─────────────────────────────────────────────────────────────

detect_os() {
  case "${OSTYPE:-unknown}" in
    darwin*) echo "macOS" ;;
    linux-gnu*) echo "Linux" ;;
    *)
      [[ -n "${WSL_DISTRO_NAME:-}" ]] && echo "WSL" || echo "unknown"
      ;;
  esac
}

ensure_git() {
  command -v git >/dev/null 2>&1 || {
    ui_error "Git is required. macOS: xcode-select --install"
    exit 1
  }
}

clone_or_update_repo() {
  ensure_git
  if [[ -d "$GIT_DIR/.git" ]]; then
    ui_info "Updating DevLearn at ${GIT_DIR}"
    if [[ "$DRY_RUN" == "1" ]]; then
      REPO_ROOT="$GIT_DIR"
      return 0
    fi
    git -C "$GIT_DIR" fetch origin "$DEVLEARN_BRANCH" --quiet 2>/dev/null || true
    git -C "$GIT_DIR" checkout "$DEVLEARN_BRANCH" --quiet 2>/dev/null || true
    git -C "$GIT_DIR" pull --ff-only origin "$DEVLEARN_BRANCH" --quiet 2>/dev/null || {
      ui_warn "Could not fast-forward; using existing checkout"
    }
    REPO_ROOT="$GIT_DIR"
    ui_success "Repo ready at ${REPO_ROOT} ($(repo_short_commit))"
    return 0
  fi

  ui_info "Cloning DevLearn → ${GIT_DIR}"
  if [[ "$DRY_RUN" == "1" ]]; then
    REPO_ROOT="$GIT_DIR"
    return 0
  fi
  mkdir -p "$(dirname "$GIT_DIR")"
  git clone --depth 1 --branch "$DEVLEARN_BRANCH" "$DEVLEARN_REPO" "$GIT_DIR"
  REPO_ROOT="$GIT_DIR"
  ui_success "Cloned → ${REPO_ROOT} ($(repo_short_commit))"
}

resolve_repo_for_install() {
  local candidates=() choice="" detected="" i=1

  if [[ "$INSTALL_METHOD" == "git" ]]; then
    clone_or_update_repo
    require_valid_repo "$REPO_ROOT" "Cloned repo failed validation"
    return 0
  fi

  if [[ "$INSTALL_METHOD" == "local" ]]; then
    detected="$(resolve_script_repo 2>/dev/null || true)"
    validate_repo_root "$detected" || {
      ui_error "Not inside a valid DevLearn repo. Use --method git or run from a clone."
      exit 1
    }
    REPO_ROOT="$detected"
    ui_success "Using local repo: ${REPO_ROOT} ($(repo_short_commit))"
    return 0
  fi

  # auto method
  if is_piped_install; then
    ui_info "Remote install detected — cloning to ${GIT_DIR} (recommended)"
    INSTALL_METHOD="git"
    clone_or_update_repo
    require_valid_repo "$REPO_ROOT" "Clone validation failed"
    return 0
  fi

  while IFS= read -r c; do
    [[ -n "$c" ]] && candidates+=("$c")
  done < <(find_candidate_repos)

  if [[ ${#candidates[@]} -eq 1 ]]; then
    REPO_ROOT="${candidates[0]}"
    ui_success "Found valid repo: ${REPO_ROOT} ($(repo_short_commit))"
    GIT_DIR="$REPO_ROOT"
    return 0
  fi

  if [[ ${#candidates[@]} -gt 1 ]] && ! is_non_interactive && has_tty; then
    ui_section "Multiple DevLearn repos found"
    for c in "${candidates[@]}"; do
      echo "  $i) $c ($(count_devlearn_skills "$c") skills)"
      i=$((i + 1))
    done
    echo "  $i) Clone/update → ${GIT_DIR}"
    read_tty "Choose [1-$i] (default 1): " choice
    choice="${choice:-1}"
    if [[ "$choice" -eq "$i" ]] 2>/dev/null; then
      INSTALL_METHOD="git"
      clone_or_update_repo
    else
      REPO_ROOT="${candidates[$((choice - 1))]:-${candidates[0]}}"
      GIT_DIR="$REPO_ROOT"
    fi
    validate_repo_root "$REPO_ROOT" || { ui_error "Invalid repo: ${REPO_ROOT}"; exit 1; }
    return 0
  fi

  if [[ ${#candidates[@]} -gt 0 ]]; then
    REPO_ROOT="${candidates[0]}"
    GIT_DIR="$REPO_ROOT"
    validate_repo_root "$REPO_ROOT" && {
      ui_success "Using repo: ${REPO_ROOT}"
      return 0
    }
  fi

  ui_info "No valid local repo — cloning to ${GIT_DIR}"
  INSTALL_METHOD="git"
  clone_or_update_repo
  require_valid_repo "$REPO_ROOT" "Clone validation failed"
}

# ── Wizard steps ────────────────────────────────────────────────────────────

wizard_welcome() {
  local when="" choice=""
  config_exists || return 0
  is_non_interactive && return 0
  has_tty || return 0
  [[ "$MODE" == "settings" || "$MODE" == "repair" || "$MODE" == "uninstall" || "$MODE" == "reset" ]] && return 0

  config_load || true
  when="$(config_get installed_at 2>/dev/null || echo unknown)"
  ui_section "Previous install found"
  ui_kv "Last installed" "$when"
  ui_kv "Repo" "${REPO_ROOT:-$(config_get repo_dir 2>/dev/null || echo —)}"
  ui_kv "Harnesses" "$(config_get harnesses 2>/dev/null || echo —)"
  echo ""
  echo "  1) Upgrade / relink (keep settings) [default]"
  echo "  2) Change settings"
  echo "  3) Uninstall symlinks only"
  echo "  4) Fresh install (reset config)"
  echo "  5) Exit"
  read_tty "Choose [1-5]: " choice
  case "${choice:-1}" in
    1|"") WIZARD_ACTION="upgrade"; config_load || true ;;
    2) WIZARD_ACTION="settings"; MODE="settings"; wizard_settings_menu; exit 0 ;;
    3) MODE="uninstall"; run_uninstall; exit 0 ;;
    4) WIZARD_ACTION="fresh"; rm -f "$DEVLEARN_CONFIG_FILE"; SELECTED_HARNESSES=() ;;
    5) exit 0 ;;
    *) ui_warn "Invalid choice; continuing with upgrade" ;;
  esac
}

wizard_pick_harnesses() {
  local id label path det mark choice="" choice_lc="" all_ids="" i=1
  [[ ${#SELECTED_HARNESSES[@]} -gt 0 && -n "$AGENT_TARGET" ]] && return 0
  map_legacy_agent_target
  [[ ${#SELECTED_HARNESSES[@]} -gt 0 ]] && return 0
  is_non_interactive && { SELECTED_HARNESSES=(cursor); return 0; }
  has_tty || { SELECTED_HARNESSES=(cursor); return 0; }

  ui_section "Choose agent harnesses (one or many)"
  echo "  Enter numbers separated by commas (e.g. 1,3,5), 'all', or press Enter for Cursor only."
  echo ""
  for id in "${HARNESS_IDS[@]}"; do
    label="$(harness_label "$id")"
    path="$(skills_dir_for_harness "$id")"
    if harness_detected "$id"; then det="${SUCCESS}detected${NC}"; else det="${MUTED}not detected${NC}"; fi
    if harness_is_selected "$id"; then mark="x"; else mark=" "; fi
    printf "  %d) [%s] %-18s %s  (%s)\n" "$i" "$mark" "$label" "$path" "$(echo -e "$det")"
    all_ids="${all_ids}${id},"
    i=$((i + 1))
  done
  echo "  a) Select ALL listed harnesses"
  echo ""
  read_tty "Selection [1/default]: " choice
  choice="${choice:-1}"

  choice_lc="$(echo "$choice" | tr '[:upper:]' '[:lower:]')"
  if [[ "$choice_lc" == "all" || "$choice_lc" == "a" ]]; then
    SELECTED_HARNESSES=("${HARNESS_IDS[@]}")
    return 0
  fi

  SELECTED_HARNESSES=()
  IFS=',' read -ra picks <<<"$choice"
  for choice in "${picks[@]}"; do
    choice="$(echo "$choice" | tr -d ' ')"
    [[ -z "$choice" ]] && continue
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
      id="${HARNESS_IDS[$((choice - 1))]:-}"
      [[ -n "$id" ]] && SELECTED_HARNESSES+=("$id")
    fi
  done

  if [[ ${#SELECTED_HARNESSES[@]} -eq 0 ]]; then
    SELECTED_HARNESSES=(cursor)
    ui_warn "No valid selection — defaulting to Cursor"
  fi

  ui_success "Selected: $(IFS=,; echo "${SELECTED_HARNESSES[*]}")"
}

wizard_project_setup() {
  local ans="" r="" a="" p=""
  [[ -n "$PROJECT_DIR" ]] && return 0
  is_non_interactive && return 0
  has_tty || return 0

  ui_section "Project setup (optional)"
  read_tty "Project path (Enter to skip): " ans
  [[ -z "${ans:-}" ]] && return 0
  PROJECT_DIR="${ans/#\~/$HOME}"

  read_tty "Copy DEVLEARN.md? [Y/n]: " r
  [[ "${r:-y}" =~ ^[Nn] ]] && PROJECT_DIR="" && return 0

  read_tty "Cursor rule (.cursor/rules/devlearn.mdc)? [y/N]: " r
  case "${r:-n}" in y|Y|yes|Yes) COPY_RULE=1 ;; esac

  read_tty "Codex AGENTS.md? [y/N]: " a
  case "${a:-n}" in y|Y|yes|Yes) COPY_AGENTS=1 ;; esac

  read_tty "Repo-local skills (.agents/skills for team)? [y/N]: " p
  case "${p:-n}" in y|Y|yes|Yes) PROJECT_SKILLS=1 ;; esac
}

wizard_confirm() {
  local ans=""
  [[ "$YES" == "1" ]] && return 0
  is_non_interactive && return 0
  has_tty || return 0

  ui_section "Install plan — confirm?"
  ui_kv "Repo" "${REPO_ROOT} ($(repo_short_commit))"
  ui_kv "Skills" "$(count_devlearn_skills "$REPO_ROOT") devlearn-* + shared"
  local id path
  for id in "${SELECTED_HARNESSES[@]:-}"; do
    path="$(skills_dir_for_harness "$id")"
    ui_kv "$(harness_label "$id")" "$path"
  done
  [[ -n "$PROJECT_DIR" ]] && ui_kv "Project" "$PROJECT_DIR"
  [[ "$COPY_RULE" == "1" ]] && ui_kv "Cursor rule" "yes"
  [[ "$COPY_AGENTS" == "1" ]] && ui_kv "AGENTS.md" "yes"
  [[ "$PROJECT_SKILLS" == "1" ]] && ui_kv "Project skills" ".agents/skills"
  echo ""
  read_tty "Proceed? [Y/n]: " ans
  [[ "${ans:-y}" =~ ^[Nn] ]] && { ui_info "Cancelled."; exit 0; }
}

wizard_settings_menu() {
  local choice=""
  config_load || true
  while true; do
    ui_section "DevLearn settings"
    ui_kv "Config file" "$DEVLEARN_CONFIG_FILE"
    ui_kv "Repo" "${REPO_ROOT:-—}"
    ui_kv "Harnesses" "$(IFS=,; echo "${SELECTED_HARNESSES[*]:-—}")"
    ui_kv "Project" "${PROJECT_DIR:-—}"
    echo ""
    echo "  1) Change harnesses"
    echo "  2) Change repo location (clone/path)"
    echo "  3) Change project options"
    echo "  4) Apply (relink skills + save)"
    echo "  5) Validate only"
    echo "  6) Back / exit"
    read_tty "Choose [1-6]: " choice
    case "${choice:-6}" in
      1) wizard_pick_harnesses ;;
      2)
        read_tty "Repo path [${GIT_DIR}]: " choice
        GIT_DIR="${choice:-$GIT_DIR}"
        REPO_ROOT="$GIT_DIR"
        validate_repo_root "$REPO_ROOT" || ui_warn "Path does not validate yet — clone/update on apply"
        ;;
      3) PROJECT_DIR=""; wizard_project_setup ;;
      4)
        REPO_ROOT="${REPO_ROOT:-$GIT_DIR}"
        validate_repo_root "$REPO_ROOT" || {
          resolve_repo_for_install
        }
        run_install_apply
        config_save
        print_next_steps
        exit 0
        ;;
      5)
        REPO_ROOT="${REPO_ROOT:-$GIT_DIR}"
        validate_repo_root "$REPO_ROOT" && verify_install || ui_error "Validation failed"
        ;;
      6|*) exit 0 ;;
    esac
  done
}

# ── Install / unlink ────────────────────────────────────────────────────────

link_skills_to_dir() {
  local target="$1" name dir
  [[ -n "$target" ]] || return 1
  if [[ "$DRY_RUN" == "1" ]]; then
    ui_info "(dry-run) would link → ${target}"
    return 0
  fi
  mkdir -p "$target"
  [[ -L "$target/shared" || -d "$target/shared" ]] && IS_UPGRADE=true
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

unlink_skills_from_dir() {
  local target="$1" name
  [[ -d "$target" || -L "$target" ]] || return 0
  rm -f "$target/shared" 2>/dev/null || true
  for name in "$target"/devlearn-*; do
    [[ -e "$name" ]] || continue
    rm -f "$name" 2>/dev/null || true
  done
  ui_success "Removed DevLearn symlinks from ${target}"
}

setup_project() {
  [[ -n "$PROJECT_DIR" ]] || return 0
  [[ -d "$PROJECT_DIR" ]] || { ui_warn "Project not found: ${PROJECT_DIR}"; return 0; }
  [[ "$DRY_RUN" == "1" ]] && return 0

  cp "$REPO_ROOT/DEVLEARN.md" "$PROJECT_DIR/DEVLEARN.md"
  ui_success "DEVLEARN.md → ${PROJECT_DIR}/"
  mkdir -p "$PROJECT_DIR/.devlearn"
  [[ -f "$PROJECT_DIR/.devlearn/progress.md" ]] || \
    cp "$REPO_ROOT/.devlearn/progress-template.md" "$PROJECT_DIR/.devlearn/progress.md" 2>/dev/null || true

  if [[ "$COPY_RULE" == "1" ]]; then
    mkdir -p "$PROJECT_DIR/.cursor/rules"
    cp "$REPO_ROOT/.cursor/rules/devlearn.example.mdc" "$PROJECT_DIR/.cursor/rules/devlearn.mdc"
    ui_success "Cursor rule installed"
  fi
  if [[ "$COPY_AGENTS" == "1" ]]; then
    if [[ ! -f "$PROJECT_DIR/AGENTS.md" ]]; then
      cp "$REPO_ROOT/AGENTS.md.example" "$PROJECT_DIR/AGENTS.md"
      ui_success "AGENTS.md installed"
    else
      ui_warn "AGENTS.md exists — merge from AGENTS.md.example manually"
    fi
  fi
  if [[ "$PROJECT_SKILLS" == "1" ]]; then
    link_skills_to_dir "$PROJECT_DIR/.agents/skills"
  fi
}

verify_install() {
  local target ok=true count
  resolve_install_targets
  [[ ${#INSTALL_TARGETS[@]} -gt 0 ]] || { ui_error "No harness targets selected"; return 1; }

  for target in "${INSTALL_TARGETS[@]}"; do
    ui_info "Checking ${target}..."
    if [[ ! -f "$target/shared/voice.md" ]]; then
      ui_error "Missing ${target}/shared/voice.md"
      ok=false
    else
      ui_success "shared/voice.md OK"
    fi
    if [[ ! -f "$target/devlearn-teach-while-coding/SKILL.md" ]]; then
      ui_error "Missing meta skill at ${target}"
      ok=false
    fi
    count="$(find "$target" -maxdepth 1 \( -type l -o -type d \) -name 'devlearn-*' 2>/dev/null | wc -l | tr -d ' ')"
    if [[ "${count:-0}" -lt "$MIN_SKILL_COUNT" ]]; then
      ui_error "Only ${count} skills at ${target} (expected ${MIN_SKILL_COUNT}+)"
      ok=false
    else
      ui_success "${count} devlearn-* skills OK"
    fi
  done

  if [[ -x "$REPO_ROOT/scripts/validate-skills.sh" ]]; then
    bash "$REPO_ROOT/scripts/validate-skills.sh" >/dev/null && ui_success "Skill spec validation passed" || {
      ui_error "Skill spec validation failed"
      ok=false
    }
  fi

  [[ "$ok" == "true" ]]
}

run_install_apply() {
  local target
  resolve_install_targets
  [[ ${#INSTALL_TARGETS[@]} -gt 0 ]] || { ui_error "Select at least one harness"; exit 1; }
  ui_stage "Installing skills"
  for target in "${INSTALL_TARGETS[@]}"; do
    link_skills_to_dir "$target"
  done
  SKILLS_DIR="${INSTALL_TARGETS[0]}"
  ui_stage "Project setup"
  setup_project
  if [[ "$VERIFY" == "1" || "$YES" == "1" ]]; then
    ui_stage "Verifying"
    verify_install || exit 1
    ui_success "Verification passed"
  fi
  config_save
}

run_uninstall() {
  recover_install_state || {
    ui_error "No install found — nothing to uninstall"
    repair_usage_hint
    exit 1
  }
  map_legacy_agent_target
  resolve_install_targets
  [[ ${#INSTALL_TARGETS[@]} -gt 0 ]] || {
    ui_error "No harnesses in config — pass --harnesses or run --settings first"
    exit 1
  }
  ui_section "Uninstall DevLearn symlinks"
  local target
  for target in "${INSTALL_TARGETS[@]}"; do
    unlink_skills_from_dir "$target"
  done
  ui_success "Uninstall complete (config kept at ${DEVLEARN_CONFIG_FILE})"
}

run_repair() {
  if recover_install_state; then
    if ! config_exists; then
      ui_info "No saved config — recovered install settings from disk"
    fi
  else
    ui_error "Could not recover install settings"
    repair_usage_hint
    exit 1
  fi

  # Prefer the repo we're running from when user did git pull in a clone.
  local script_repo=""
  script_repo="$(resolve_script_repo 2>/dev/null || true)"
  if validate_repo_root "$script_repo"; then
    if [[ "$script_repo" != "$REPO_ROOT" ]]; then
      ui_info "Using repo from this checkout: ${script_repo}"
    fi
    REPO_ROOT="$script_repo"
    GIT_DIR="$script_repo"
  fi

  REPO_ROOT="${REPO_ROOT:-$GIT_DIR}"
  validate_repo_root "$REPO_ROOT" || {
    ui_warn "Saved repo invalid — attempting clone/update"
    INSTALL_METHOD="git"
    GIT_DIR="${REPO_ROOT:-$DEVLEARN_DEFAULT_DIR}"
    clone_or_update_repo
    require_valid_repo "$REPO_ROOT" "Cloned repo failed validation"
  }
  VERIFY=1
  run_install_apply
  print_next_steps
}

print_next_steps() {
  resolve_install_targets
  ui_section "You're ready to learn while you vibe"
  [[ "$IS_UPGRADE" == "true" ]] && echo -e "  ${MUTED}Skills updated — restart agent or open new chat.${NC}"
  local lines="" t id
  for id in "${SELECTED_HARNESSES[@]:-}"; do
    lines="${lines}     • $(harness_label "$id") → $(skills_dir_for_harness "$id")"$'\n'
  done
  ui_panel "$(cat <<EOF
Installed to:
${lines}
Next:
  • /devlearn-onboard  (Cursor / Claude) or "use devlearn-onboard skill" (Codex)
  • Settings file: ${DEVLEARN_CONFIG_FILE}
  • Re-run: ./install.sh --settings | --repair | --uninstall
  • Docs: ${REPO_ROOT}/shared/agent-compatibility.md
EOF
)"
}

print_usage() {
  cat <<EOF
DevLearn Installer — guided setup for Cursor, Claude, Codex, OpenCode, etc.

Usage:
  ./install.sh                      Interactive wizard
  ./install.sh --settings           Change harnesses / paths / re-apply
  ./install.sh --repair             Relink skills (config, symlinks, or local clone)
  ./install.sh --upgrade            Same as --repair
  ./install.sh --uninstall          Remove symlinks (keeps config)
  ./install.sh --reset              Delete config + fresh wizard

Options:
  --harnesses LIST                  Comma list: cursor,claude,codex,opencode,factory,kiro
  --agent TARGET                    Legacy alias for --harnesses (cursor, all, auto, …)
  --method local|git|auto           Repo source (curl defaults to git clone)
  --git-dir PATH                    Clone directory (default: ~/DevLearn)
  --project PATH                    Enable DEVLEARN.md in project
  --copy-rule / --copy-agents / --project-skills
  --yes, -y                         Skip confirm prompt
  --verify                          Validate after install
  --no-prompt                       Non-interactive
  --dry-run                         Show plan only
  -h, --help

Config: ${DEVLEARN_CONFIG_FILE}
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --settings) MODE="settings" ;;
      --repair|--upgrade) MODE="repair" ;;
      --uninstall) MODE="uninstall" ;;
      --reset)    MODE="reset" ;;
      --harnesses)
        IFS=',' read -ra SELECTED_HARNESSES <<<"$2"
        shift
        ;;
      --agent)
        AGENT_TARGET="$2"
        shift
        ;;
      --skills-dir)
        CUSTOM_SKILLS_DIR="$2"
        shift
        ;;
      --method)
        INSTALL_METHOD="$2"
        shift
        ;;
      --git-dir|--dir)
        GIT_DIR="$2"
        shift
        ;;
      --project)
        PROJECT_DIR="$2"
        shift
        ;;
      --copy-rule) COPY_RULE=1 ;;
      --copy-agents) COPY_AGENTS=1 ;;
      --project-skills) PROJECT_SKILLS=1 ;;
      --no-onboard) NO_ONBOARD=1 ;;
      --no-prompt) NO_PROMPT=1 ;;
      --verify) VERIFY=1 ;;
      --dry-run) DRY_RUN=1 ;;
      --verbose) VERBOSE=1 ;;
      --yes|-y) YES=1 ;;
      -h|--help) HELP=1 ;;
      *)
        ui_error "Unknown option: $1"
        exit 2
        ;;
    esac
    shift
  done
}

main() {
  [[ "$HELP" == "1" ]] && { print_usage; exit 0; }
  [[ "$VERBOSE" == "1" ]] && set -x

  print_banner
  ui_success "Detected: $(detect_os)"

  case "$MODE" in
    reset)
      rm -f "$DEVLEARN_CONFIG_FILE"
      ui_success "Config reset — starting fresh wizard"
      MODE="install"
      ;;
    repair)
      run_repair
      exit 0
      ;;
    uninstall)
      run_uninstall
      exit 0
      ;;
    settings)
      wizard_settings_menu
      exit 0
      ;;
  esac

  # Piped curl: force clone unless explicit --method local
  if is_piped_install && [[ "$INSTALL_METHOD" == "auto" ]]; then
    INSTALL_METHOD="git"
    ui_info "Piped install — will clone to ${GIT_DIR} (not using cwd)"
  fi

  wizard_welcome

  ui_stage "Locate or clone DevLearn"
  resolve_repo_for_install

  ui_stage "Choose harnesses"
  wizard_pick_harnesses

  ui_stage "Project setup"
  wizard_project_setup

  ui_stage "Review plan"
  resolve_install_targets
  ui_kv "Repo" "${REPO_ROOT} ($(repo_short_commit))"
  ui_kv "Harness count" "${#SELECTED_HARNESSES[@]}"
  for t in "${INSTALL_TARGETS[@]:-}"; do ui_kv "Target" "$t"; done

  wizard_confirm

  if [[ "$DRY_RUN" == "1" ]]; then
    ui_success "Dry run complete"
    exit 0
  fi

  VERIFY="${VERIFY:-1}"
  run_install_apply
  [[ "$NO_ONBOARD" != "1" ]] && print_next_steps || ui_success "Done (${SKILL_COUNT} skills × ${#INSTALL_TARGETS[@]} targets)"
}

parse_args "$@"
main "$@"
