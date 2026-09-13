#!/usr/bin/env bash
if ! command -v playerctl >/dev/null 2>&1; then
  echo ""
  exit 0
fi
status=$(playerctl status 2>/dev/null) || true
if [ "$status" != "Playing" ] && [ "$status" != "Paused" ]; then
  echo ""
  exit 0
fi
artist=$(playerctl metadata artist 2>/dev/null)
title=$(playerctl metadata title 2>/dev/null)
if [ -z "$title" ]; then
  echo ""
  exit 0
fi
if [ -n "$artist" ]; then
  echo "  Now playing: $title"
else
  echo "  Now playing: $title "
fi
