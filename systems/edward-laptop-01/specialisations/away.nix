{ lib, ... }:
{
  specialisation.away = {
    inheritParentConfig = true;
    configuration = {
      nix.settings.substituters = lib.mkForce [ "https://cache.nixos.org" ];
      nix.distributedBuilds = lib.mkForce false;
      services.transmission.enable = lib.mkForce false;
      services.openssh.enable = lib.mkForce false;
      networking.firewall.enable = lib.mkForce true;
      networking.firewall.allowedTCPPorts = lib.mkForce [ ];
      networking.firewall.allowedUDPPorts = lib.mkForce [ ];
      services.logind.extraConfig = lib.mkForce "";
    };
  };
}
