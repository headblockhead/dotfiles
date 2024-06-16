{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.cubicsdr
  ];
  hardware.rtl-sdr.enable = true;
  users.users.headb.extraGroups = [ "plugdev" ];
}
