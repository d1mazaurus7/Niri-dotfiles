{  pkgs, ...}: 
{
  imports =
    [
      ./hardware-configuration.nix
      ./system/packages.nix
      ./system/services.nix
      ./system/users.nix
      ./system/network.nix
      ./system/locale.nix
      ./system/autologin.nix
    ];
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "root" "valtrynx" ];
        fallback = true;
        warn-dirty = false;

    substituters = pkgs.lib.mkForce [
      "https://cache.nixos.org"
    ];

    trusted-public-keys = pkgs.lib.mkForce [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    configPackages = [ pkgs.niri ];
    config = {
      niri = {
        default = [ "gnome" "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
      common = {
        default = [ "gnome" "gtk" ];
      };
    };
  };
  environment.localBinInPath = true;
    environment.variables = {
    XDG_DATA_DIRS = [
      "$HOME/.local/share/flatpak/exports/share"
      "/var/lib/flatpak/exports/share"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
        "electron-40.10.5"
        "pnpm-10.29.2"
        ];
    };
  system.stateVersion = "26.05";

}
