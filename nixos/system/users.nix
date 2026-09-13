# /etc/nixos/system/users.nix
{ pkgs, ... }: 
{ 
  # /etc/nixos/ write setting
  systemd.tmpfiles.rules = [
    	"d /etc/nixos 0775 root wheel - -"
    	"Z /etc/nixos 0775 root wheel - -"
  ];

  # users settings
  users.users."valtrynx" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "valtrynx";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [];
  };
}
