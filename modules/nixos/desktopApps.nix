{ pkgs, ... }: {
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
    obsidian
    arduino
    audacity
    blender-hip
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
    unstable.musescore
    obs-studio
    onedrive
    prismlauncher
    remmina
    spotify
    prusa-slicer
    slack
    thonny
    thunderbird
    unstable.rpi-imager
    vlc
    zoom-us
  ];
}
