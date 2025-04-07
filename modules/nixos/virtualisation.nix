{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.virt-manager
  ];
  virtualisation.libvirtd = {
    enable = true;
  };
}
