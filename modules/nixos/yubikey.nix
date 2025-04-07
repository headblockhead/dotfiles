{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.yubikey-personalization
    pkgs.yubikey-manager
    pkgs.yubikey-touch-detector
    pkgs.yubikey-personalization-gui
  ];
}
