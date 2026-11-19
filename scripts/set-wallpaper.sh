#!/usr/bin/env bash
set -euo pipefail
WALLPAPER="''${1:-}"
STATE_FILE="${stateFile}"
LINK_FILE="${linkFile}"
if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
  echo "Usage: set-wallpaper /path/to/image-or-video" >&2
  exit 1
fi 
WALLPAPER="$(realpath "$WALLPAPER")"
if ! awww query &>/dev/null; then
  awww-daemon &
  for _ in $(seq 1 50); do
    awww query &>/dev/null && break
    sleep 0.05
  done
fi 
mkdir -p "$(dirname "$STATE_FILE")"
pkill -u "$USER" -f '(^|/)mpvpaper( |$)' || true
case "''${WALLPAPER,,}" in
  *.mp4|*.webm|*.mkv|*.mov|*.avi|*.m4v)
    FRAME="${cache}/current_wallpaper_frame.png"
    mpv --no-config --really-quiet --no-audio --frames=1 --vf=scale=1280:-2 -o "$FRAME" "$WALLPAPER"
    awww img "$FRAME" --transition-type fade --transition-duration 0.5
    setsid -f mpvpaper -p -o "no-audio loop panscan=1.0 hwdec=auto-safe" '*' "$WALLPAPER" >/dev/null 2>&1 </dev/null
    ln -sfn "$FRAME" "$LINK_FILE"
    ;;
  *)
    awww img "$WALLPAPER" --transition-type fade --transition-duration 0.5
    ln -sfn "$WALLPAPER" "$LINK_FILE"
    ;;
esac
echo "$WALLPAPER" > "$STATE_FILE"
matugen image ~/.cache/current_wallpaper_link --source-color-index 0
clear

