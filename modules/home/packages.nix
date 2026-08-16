# home/packages.nix
{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [

#---------------------------#
#--  WM & GRAPHICAL UTILS --#
#---------------------------#

    alacritty  # terminal emulator
    cava  # music graph

#-------------------------#
#-- MP4 & MP3 & EDITORS --#
#-------------------------#

    yazi  # file-manager
    neovim  # editor
    vlc  # MP4
    mpd  # music player daemon
    mpc  # music player daemon client
    yt-dlp  # mp4 downloader

#------------------#
#-- GUI PROGRAMS --#
#------------------#

    obsidian  # notes
    tor-browser  # private browser
    localsend  # sharing files
    telegram-desktop  # messenger
    cherry-studio  # AI chat

#---------------------------#
#-- PROGRAMMING LANGUAGES --#
#---------------------------#

    rustc
    cargo
    rustfmt
    clippy

#------------------#
#-- TUI PROGRAMS --#
#------------------#

    eza  # eza = ls
    opencode  # tui agent
    btop  # system info
    rmpc  # music player

#-----------------#
#--  ANALYZERS  --#
#-----------------#

    rust-analyzer # rust-analyzer
    typescript-language-server # js
    typescript # ts
    vscode-langservers-extracted # html + css + json
    basedpyright # python
    nil # nix
    taplo # toml

  ] ++ [
    inputs.quickshell.packages.${pkgs.system}.default  # quickshell
  ];
}
