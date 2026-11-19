#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/d1mazaurus7/Niri-dotfiles.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo ":: Клонируем $REPO_URL..."
git clone --depth=1 "$REPO_URL" "$TMP_DIR/Niri-dotfiles"
cd "$TMP_DIR/Niri-dotfiles"

if [[ -f "$TMP_DIR/Niri-dotfiles/arch-based/dependenses.sh" ]]; then
    cp -f "$TMP_DIR/Niri-dotfiles/arch-based/dependenses.sh" "$SCRIPT_DIR/dependenses.sh"
    chmod +x "$SCRIPT_DIR/dependenses.sh"
    echo ":: Обновлён $SCRIPT_DIR/dependenses.sh"

    if [[ -d "$SCRIPT_DIR/../install" ]]; then
        cp -f "$TMP_DIR/Niri-dotfiles/arch-based/dependenses.sh" "$SCRIPT_DIR/../install/dependenses.sh"
        chmod +x "$SCRIPT_DIR/../install/dependenses.sh"
        echo ":: Обновлён $SCRIPT_DIR/../install/dependenses.sh"
    fi
fi

mkdir -p "$CONFIG_DIR"
BACKUP_DIR="$CONFIG_DIR/backup_$(date +%Y%m%d_%H%M%S)"
HAS_BACKUPS=false

EXCLUDE_DIRS=("install" "scripts" "arch-based" ".git")

echo ":: Переносим конфигурации в $CONFIG_DIR..."
for item in "$TMP_DIR/Niri-dotfiles"/*; do
    [[ -d "$item" ]] || continue

    name="$(basename "$item")"
    skip=false
    for ex in "${EXCLUDE_DIRS[@]}"; do
        if [[ "$name" == "$ex" ]]; then
            skip=true
            break
        fi
    done
    [[ "$skip" == true ]] && continue

    target="$CONFIG_DIR/$name"
    if [[ -e "$target" || -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        HAS_BACKUPS=true
    fi

    mv "$item" "$target"
    echo "  -> $name перемещена в $target"
done

if [[ "$HAS_BACKUPS" == true ]]; then
    echo ":: Предыдущие конфиги сохранены в: $BACKUP_DIR"
fi

echo ":: Обновление завершено."
