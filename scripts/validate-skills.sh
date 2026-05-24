#!/usr/bin/env bash
# Validate DevLearn skills for Agent Skills spec (Cursor, Claude, Codex, OpenCode).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

NAME_RE='^[a-z0-9]+(-[a-z0-9]+)*$'
errors=0
warnings=0
skill_count=0

err() { echo "ERROR: $*" >&2; errors=$((errors + 1)); }
warn() { echo "WARN: $*" >&2; warnings=$((warnings + 1)); }
ok() { echo "OK: $*"; }

check_skill() {
  local dir="$1"
  local name="$2"
  local skill_md="$dir/SKILL.md"
  skill_count=$((skill_count + 1))

  [[ -f "$skill_md" ]] || { err "$name: missing SKILL.md"; return; }

  if [[ ! "$name" =~ $NAME_RE ]]; then
    err "$name: directory name fails Agent Skills regex (lowercase, hyphens only)"
  fi

  local fm_name fm_desc
  fm_name="$(grep -m1 '^name:' "$skill_md" 2>/dev/null | sed 's/^name:[[:space:]]*//' | tr -d '[:space:]' || true)"
  fm_desc="$(awk '/^---$/{n++; next} n==1 && /^description:/ {sub(/^description:[[:space:]]*/,""); gsub(/^[|>][[:space:]]*/,""); print; exit}' "$skill_md" | head -1)"

  if [[ -z "$fm_name" ]]; then
    err "$name: missing frontmatter name:"
  elif [[ "$fm_name" != "$name" ]]; then
    err "$name: frontmatter name '$fm_name' != directory '$name'"
  fi

  if [[ -z "$(grep -m1 '^description:' "$skill_md" || true)" ]]; then
    err "$name: missing frontmatter description:"
  fi

  local desc_len
  desc_len="$(python3 - <<PY 2>/dev/null || echo 0
import re, pathlib
text = pathlib.Path("$skill_md").read_text()
m = re.search(r"^---\n(.*?)\n---", text, re.S)
if not m:
    print(0)
    exit()
block = m.group(1)
dm = re.search(r"^description:\s*\|\s*\n((?: .*\n?)*)", block, re.M) or re.search(r"^description:\s*(.+)$", block, re.M)
if not dm:
    print(0)
elif dm.lastindex and "\n" in dm.group(0):
    body = dm.group(1)
    print(len(re.sub(r"^ ", "", body, flags=re.M).strip()))
else:
    print(len(dm.group(1).strip()))
PY
)"
  if [[ "${desc_len:-0}" -gt 1024 ]]; then
    err "$name: description exceeds 1024 chars ($desc_len)"
  fi

  # Shared link resolves from skill dir (symlink-safe: use real path)
  local real_dir
  real_dir="$(cd "$dir" && pwd)"
  if [[ ! -f "$real_dir/../shared/voice.md" ]]; then
    err "$name: ../shared/voice.md not reachable from $dir"
  fi
}

echo "Validating DevLearn skills in $REPO_ROOT"
echo ""

if [[ ! -d "$REPO_ROOT/shared" ]]; then
  err "missing shared/ directory"
fi

for dir in "$REPO_ROOT"/devlearn-*/; do
  [[ -d "$dir" ]] || continue
  check_skill "$dir" "$(basename "$dir")"
done

if [[ ! -f "$REPO_ROOT/install.sh" ]]; then
  warn "install.sh missing at repo root"
fi

echo ""
echo "Checked $skill_count skills — errors: $errors, warnings: $warnings"

if [[ "$errors" -gt 0 ]]; then
  exit 1
fi

ok "All skills pass Agent Skills validation"
exit 0
