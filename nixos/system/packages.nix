# /etc/nixos/packages.nix
{ pkgs, inputs,  ... }:
{
 environment.systemPackages = with pkgs; [

#---------------------------#
#--  WM & GRAPHICAL UTILS --#
#---------------------------#

   niri  # WM
   rofi  # launcher
   waybar  # dock-bar
   alacritty  # terminal emulator
   foot  # terminal
   xwayland-satellite  #  xwayland-satellite
   xdg-utils  # xdg-utils  
   awww  # live wallpapers
   hyprpicker  # color picker 
   swaybg  # wallpapers
   waypaper  # GUI for wallpapers
   hyprlock  # lock
   imv
   easyeffects  # equalizer
   sound-theme-freedesktop  # sounds
   playerctl  # player-daemon library

#------------------#
#-- HOME-MANAGER --#
#------------------#

   inputs.matugen.packages.${system}.default

#--------------------# 
#-- TERMINAL UTILS --#
#--------------------#
   ripgrep  # better grep
   curl  # CLI HTTP-client 
   wget  # file downloader
   zip  # zip files 
   git  # git 
   unzip  # unzip files 
   gcc  # C compiler
   gnumake  # makepkg
   tree-sitter  # syntax parser 
   wl-clipboard  # clipboard 
   libnotify  # notifications library
   tree  # directory-tree
   power-profiles-daemon  # power modes
   iw

#----------#
#-- LARP --#
#----------#
   sl
   cbonsai
   cava
   fastfetch


#-------------------------#
#-- MP4 & MP3 & EDITORS --#
#-------------------------#

    yazi  # file-manager
    neovim  # editor
    mpd  # music player daemon
    yt-dlp  # mp4 downloader
    mpv  # MP4 & GIF

#------------------#
#-- GUI PROGRAMS --#
#------------------#

    obsidian  # notes
    pavucontrol  # gui for sound
    localsend  # sharing files
    telegram-desktop  # messenger
    blueman  # gui for bluetooth
    mullvad-vpn  # vpn
    cherry-studio  # AI chat
    firefox  # browser
    obs-studio
    freetube
    vesktop
    swaynotificationcenter
    audacity
    steam
    cassette

#---------------------------#
#-- PROGRAMMING LANGUAGES --#
#---------------------------#

    rustup
    gcc
    pkg-config
    openssl.dev
    cargo
    rustfmt
    clippy

#--------------------#
#-- SHELL PROGRAMS --#
#--------------------#

    zsh  # shell 
    eza  # eza = ls
    starship  # prompt
    opencode  # tui agent 
    btop  # system info

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
