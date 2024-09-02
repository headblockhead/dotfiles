{ config, ... }:
{
  system.autoUpgrade = {
    enable = true;
    dates = "03:10";
    flake = "${config.users.users.headb.home}/dotfiles";
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixpkgs-unstable"
      "--update-input"
      "home-manager"
      "--commit-lock-file"
    ];
    allowReboot = true;
  };
}
