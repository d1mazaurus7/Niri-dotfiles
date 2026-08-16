{ pkgs, ... }:
  let
    v = import ./vars.nix;
  in

{
  imports = [
    ./packages.nix
    ./services.nix
  ];

  #------------#
  #--- USER ---#
  #------------#
  networking.hostName = v.hostname;
  networking.networkmanager.enable = v.networkManager;
  time.timeZone = v.timeZone;
  i18n.defaultLocale = v.defaultLocale;
  i18n.extraLocaleSettings = v.extraLocaleSettings;
  services.xserver.xkb = {
    layout = v.keyboardLayout;
    variant = v.keyboardVariant;
  };
  users.users.${v.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ]
      ++ lib.optionals v.bluetooth [ "bluetooth" ];
    shell = if v.useZsh then pkgs.zsh else pkgs.bash;
  };

  #------------#
  #--- BOOT ---#
  #------------#
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  

}
