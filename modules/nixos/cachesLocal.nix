{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];

  nix.settings = {
    substituters = [ "http://192.168.1.1?priority=10" ];
    trusted-substituters = [ "http://192.168.1.1?priority=10" ];
    trusted-public-keys = [ "h6cache:N9Ghc9O46jxUCwsN7JDFomuobHwUOls7tiSFKjHo2Gs=" ];
  };
}
