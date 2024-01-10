{ pkgs, ... }:

{
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  networking.firewall.allowedTCPPorts = [ 6742 ];

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
  ];

  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";
}
