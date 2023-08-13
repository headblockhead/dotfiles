{ config, pkgs, bash, ... }:

{
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
  ];

  systemd.services.openrgb = {
    enable = true;
  description = "Run an OpenRGB server for controlling RGB devices";
  script = ''
    ${pkgs.openrgb}/bin/openrgb --server
    '';
  wantedBy = [ "multi-user.target" ]; # starts after login
};

  services.udev.extraRules =  ''
    ${builtins.readFile ./60-openrgb.rules}
    '';
}
