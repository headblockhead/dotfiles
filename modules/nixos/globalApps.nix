{ pkgs, agenix, ... }:
{
  environment.systemPackages = with pkgs; [
    xc
    cachix
    agenix.packages.x86_64-linux.default
  ];
}
