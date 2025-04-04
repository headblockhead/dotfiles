{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.gnome-boxes
  ];
  virtualisation.libvirtd = {
    enable = true;
  };
}
