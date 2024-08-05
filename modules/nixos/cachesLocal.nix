{ pkgs, lib, ... }:
{
  nix.settings = {
    extra-substituters = [ "http://192.168.1.1?priority=10" ]; # extra-substituters is for non-reliable substituters to prevent build failures.
    trusted-substituters = [ "http://192.168.1.1?priority=10" ];
    trusted-public-keys = [ "h6cache:N9Ghc9O46jxUCwsN7JDFomuobHwUOls7tiSFKjHo2Gs=" ];
  };
}
