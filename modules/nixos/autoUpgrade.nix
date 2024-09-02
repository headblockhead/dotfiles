{ config, pkgs, ... }:
{
  system.autoUpgrade = {
    enable = true;
    operation = "switch";
    dates = "03:00"; # autoBuild runs at 2am, so it should have been cached by now.
    flake = "github:headblockhead/dotfiles";
    randomizedDelaySec = "15min"; # Randomize the upgrade time by up to 30 minutes, to avoid all systems upgrading at the same time.
    # only allow rebooting between 3 and 4am
    rebootWindow.lower = "03:00";
    rebootWindow.upper = "04:00";
    allowReboot = true;
  };
}
