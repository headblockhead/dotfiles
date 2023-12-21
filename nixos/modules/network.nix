{ pkgs, ... }: {
  programs.mtr.enable = true;
  networking.networkmanager.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  networking.nameservers = [ "192.168.0.1" "1.1.1.1" "1.0.0.1" ];
}
