{ config, ... }:
{
  system.autoUpgrade = {
    enable = true;
    operation = "boot"; # Reboot to apply upgrades.
    dates = "03:00";
    flake = "${config.users.users.headb.home}/dotfiles";
    randomizedDelaySec = "30min"; # Randomize the upgrade time by up to 30 minutes, to avoid all systems upgrading at the same time.
    flags = [
      "--update-input"
      "nixpkgs"
      "--update-input"
      "nixpkgs-unstable"
      "--update-input"
      "home-manager"
    ];
    allowReboot = false;
  };
}
