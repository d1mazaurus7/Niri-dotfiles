{ lib, ... }:
let
  v = import ./vars.nix;
in
{
  programs.zsh.enable = lib.mkIf v.useZsh true;
  hardware.bluetooth.enable = v.bluetooth;
  system.stateVersion = v.stateVersion;
  services.blueman.enable = v.bluetooth;

}
