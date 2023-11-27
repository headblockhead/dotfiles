{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];

  nix.settings.trusted-users = [ "headb" ];

  nix.settings = {
    substituters = [ "http://nixcachepi:8080/global" ];
    trusted-public-keys = [ "global:Q9Pgq8Pz0Momvpv/wIAbyeN8TykO0nR8KFOnoYTMP0Y=" ];
  };

}
