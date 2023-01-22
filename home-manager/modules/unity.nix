{ pkgs, ... }: {
  home.packages = with pkgs; [
    pkgs.unityhub # Game-making tool - Launcher for Unity. Overlayed by definition in custom-packages/unityhub.nix - nixpkgs is outdated https://github.com/huantianad/nixos-config/blob/main/packages/unityhub.nix.
  ];
  }
