{ pkgs, ... }: {
  programs.mtr.enable = true;
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.0.1" "1.1.1.1" "1.0.0.1" ];
}
