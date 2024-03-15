{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    blender
    furnace # chiptune tracker
    remmina
    kicad
    zoom-us
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
    unstable.rpi-imager
    lmms
    arduino
    thonny
    chiaki

    # Games
    prismlauncher
    clonehero
    mcpelauncher # Not in nixpkgs, defined by override in flake.nix (source: github.com/headblockhead/nix-mcpelauncher)

    firefox

    google-chrome
    discord
    vlc
    spotify
    thunderbird
    libreoffice
    # obsidian # uses electron-25.9.0, outdated :(
    audacity
  ];
}
