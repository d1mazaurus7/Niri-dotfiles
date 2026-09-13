{ ... }:
{
  networking = {
    useDHCP = false;
    dhcpcd.enable = false;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };
}
