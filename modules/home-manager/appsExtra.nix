{ pkgs, ... }: {
  home.packages = with pkgs; [
    furnace # chiptune tracker
    remmina
    zoom-us
    blender
    fractal # matrix messenger
    musescore
    obs-studio
    cura
    onedrive
    deja-dup
    kdenlive
    gimp
    transgui
    monero-gui
    rpi-imager
    lmms
    arduino
    thonny
    chiaki

    # Games
    prismlauncher
    clonehero
    mcpelauncher # Not in nixpkgs, defined by override in flake.nix (source: github.com/headblockhead/nix-mcpelauncher)
  ];
}
