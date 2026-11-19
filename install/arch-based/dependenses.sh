#!/usr/bin/env bash
set -euo pipefail

PACMAN_PACKAGES=(
    niri
    xwayland-satellite
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    polkit-gnome

    foot
    neovim
    fastfetch
    zsh
    git
    base-devel
    jq
    bc
    curl
    wget

    pipewire
    pipewire-pulse
    wireplumber
    mpd
    mpv
    cava
    grim
    slurp
    wl-clipboard
    cliphist
    brightnessctl
    playerctl

    networkmanager
    bluez
    bluez-utils

    ttf-jetbrains-mono-nerd
    noto-fonts
    noto-fonts-emoji
    papirus-icon-theme
)

YAY_PACKAGES=(
    quickshell-git
    matugen-bin
    awww-git
    mpvpaper

    rmpc
)

install_pacman_packages() {
    echo ":: Обновление базы и установка пакетов из pacman..."
    sudo pacman -Syu --needed --noconfirm "${PACMAN_PACKAGES[@]}"
}

ensure_yay() {
    if ! command -v yay &>/dev/null; then
        echo ":: yay не найден. Устанавливаем yay-bin из AUR..."
        local tmp_dir
        tmp_dir="$(mktemp -d)"
        git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir/yay-bin"
        (cd "$tmp_dir/yay-bin" && makepkg -si --noconfirm)
        rm -rf "$tmp_dir"
    fi
}

install_yay_packages() {
    if [[ ${#YAY_PACKAGES[@]} -eq 0 ]]; then
        return
    fi
    ensure_yay
    echo ":: Установка пакетов из AUR (yay)..."
    yay -S --needed --noconfirm "${YAY_PACKAGES[@]}"
}

install_all_dependencies() {
    install_pacman_packages
    install_yay_packages
}
