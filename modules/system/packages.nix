# /etc/nixos/packages.nix
{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [

#---------------------------#
#--  WM & GRAPHICAL UTILS --#
#---------------------------#

    niri  # WM
    xwayland-satellite  #  xwayland-satellite
    xdg-utils  # xdg-utils
    awww  # live wallpapers
    hyprpicker  # color picker
    swaybg  # wallpapers
    waypaper  # GUI for wallpapers
    wl-clipboard  # clipboard
    libnotify  # notifications library

#--------------------#
#-- TERMINAL UTILS --#
#--------------------#

    curl  # CLI HTTP-client
    wget  # file downloader
    zip  # zip files
    git  # git
    unzip  # unzip files
    gcc  # C compiler
    gnumake  # makepkg

#------------------#
#-- GUI PROGRAMS --#
#------------------#

    pavucontrol  # gui for sound
    blueman  # gui for bluetooth
    mullvad-vpn  # vpn
    firefox  # browser
  ];
}
