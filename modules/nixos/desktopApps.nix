{ pkgs, ... }: {
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    arduino
    audacity
    chiaki
    clonehero
    deja-dup
    discord
    firefox
    fractal # matrix messenger
    furnace # chiptune tracker
    gimp
    google-chrome
    ifuse # optional, to mount using 'ifuse'
    inkscape
    kicad
    libimobiledevice
    libreoffice
    lmms
    monero-gui
    musescore
    obs-studio
    obsidian
    onedrive
    openscad-unstable
    prismlauncher
    prusa-slicer
    remmina
    rpi-imager
    slack
    spotify
    thonny
    thunderbird
    tor-browser-bundle-bin
    unstable.blender-hip
    vlc
    zoom-us
  ];
}
