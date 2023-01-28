# NixOS Thinkpad Dock

Small NixOS module for ThinkPads to perform certain tasks during docking and
undocking on the docking station. Technically this is realized by creating an
`acpid` handler.

See https://github.com/oxzi/nixos-thinkpad-dock for orininal repo. This is a direct clone, it is not a submodule as nix does not recognise submodules.

## Usage

This repository needs to be included in the NixOS configuration. An example
follows.

```nix
{ config, pkgs, ... }:

{
  imports = [
    /path/to/nixos-thinkpad-dock
  ];

  hardware = {
    thinkpad-dock = {
      enable = true;

      # Those are needed for xrandr.
      environment = ''
        export DISPLAY=:0
        export XAUTHORITY=/home/user/.Xauthority
      '';

      # Add a second monitor while docking and remove it again.
      dockEvent = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2-1 --mode 1920x1080 --right-of eDP-1
      '';
      undockEvent = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2-1 --off
      '';
    };
  };
}
```
