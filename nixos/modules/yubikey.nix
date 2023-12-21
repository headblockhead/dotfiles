{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.yubikey-personalization
    pkgs.yubikey-manager
    pkgs.yubikey-manager-qt
    pkgs.yubikey-touch-detector
    pkgs.yubikey-personalization-gui
  ];
}
