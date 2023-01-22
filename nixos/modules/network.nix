{ pkgs, ... }: {
  programs.mtr.enable = true;
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.155.1" "1.1.1.1" ];
}
