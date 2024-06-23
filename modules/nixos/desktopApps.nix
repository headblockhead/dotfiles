{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    obsidian
    arduino
    audacity
    blender
    chiaki
    clonehero
    deja-dup
    discord
    firefox
    fractal # matrix messenger
    furnace # chiptune tracker
    gimp
    google-chrome
    kdenlive
    kicad
    libreoffice
    lmms
    mcpelauncher # Not in nixpkgs, defined by override in flake.nix (source: github.com/headblockhead/nix-mcpelauncher)
    monero-gui
    musescore
    obs-studio
    onedrive
    prismlauncher
    remmina
    spotify
    #    unstable.super-slicer
    thonny
    thunderbird
    transgui
    unstable.rpi-imager
    vlc
    zoom-us
  ];
}
