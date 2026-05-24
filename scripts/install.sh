#!/usr/bin/env bash
# DevLearn installer entry point (scripts/ path for backwards compatibility).
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec /bin/bash "${SCRIPT_DIR}/../install.sh" "$@"
