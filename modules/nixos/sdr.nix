{ pkgs, account, ... }:
{
  environment.systemPackages = [
    pkgs.cubicsdr
  ];
  hardware.rtl-sdr.enable = true;
  users.users.${account.username}.extraGroups = [ "plugdev" ];
}
