# /etc/nixos/home/default.nix
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./environment.nix
    ./xdg-default.nix
    ./fastfetch.nix
    ./set-wallpaper.nix
    ./firefox.nix
    ./zsh.nix
    ./cursor.nix
    ./services.nix
    ./easyeffects/bass.nix
    ./easyeffects/video.nix
    ./easyeffects/default.nix
    ./easyeffects/atmosphere.nix
  ];
  home.sessionPath = [ "$HOME/.cargo/bin" ];
  home.username = "valtrynx";
  home.homeDirectory = "/home/valtrynx";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
