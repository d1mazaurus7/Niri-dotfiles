#!/bin/sh
set -eu

systemctl --user set-environment \
  XDG_CURRENT_DESKTOP=niri \
  XDG_SESSION_TYPE=wayland \
  WAYLAND_DISPLAY="${WAYLAND_DISPLAY}" \
  DISPLAY="${DISPLAY:-:0}" \
  XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR}"

systemctl --user import-environment \
  WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DISPLAY XDG_RUNTIME_DIR

dbus-update-activation-environment --systemd \
  WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DISPLAY XDG_RUNTIME_DIR

systemctl --user start \
  niri-graphical-session.target \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal
