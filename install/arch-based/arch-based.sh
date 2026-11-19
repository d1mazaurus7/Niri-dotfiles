#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$SCRIPT_DIR/dependenses.sh" ]]; then
    DEPS_FILE="$SCRIPT_DIR/dependenses.sh"
elif [[ -f "$SCRIPT_DIR/../arch-based/dependenses.sh" ]]; then
    DEPS_FILE="$SCRIPT_DIR/../arch-based/dependenses.sh"
else
    echo "Ошибка: не найден dependenses.sh" >&2
    exit 1
fi

source "$DEPS_FILE"

install_all_dependencies
