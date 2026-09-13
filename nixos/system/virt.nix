{ config, pkgs, ... }:

{
virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
  };
};

programs.virt-manager.enable = true;

virtualisation.spiceUSBRedirection.enable = true;

users.users.valtrynx = {   # ← свой логин
  extraGroups = [ "libvirtd" "kvm" ];
};

environment.systemPackages = with pkgs; [
  virt-manager
  qemu_kvm
  libvirt
  spice-gtk
];
}
