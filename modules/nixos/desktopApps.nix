{ pkgs, ... }: {
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
    obsidian
    arduino
    audacity
    unstable.blender-hip
    chiaki
    clonehero
    deja-dup
    discord
    firefox
    fractal # matrix messenger
    furnace # chiptune tracker
    gimp
    google-chrome
    unstable.kicad
    openscad-unstable
    inkscape
    libreoffice
    lmms
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
