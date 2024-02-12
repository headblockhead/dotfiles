{ pkgs, ... }:

{
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
  ];

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    package = pkgs.openrgb-with-all-plugins;
  };

}
