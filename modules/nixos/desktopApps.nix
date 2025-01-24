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
    kicad
    openscad-unstable
    inkscape
    libreoffice
    lmms
    monero-gui
    musescore
    obs-studio
    onedrive
    prismlauncher
    remmina
    spotify
    prusa-slicer
    slack
    thonny
    thunderbird
    rpi-imager
    vlc
    zoom-us
  ];
}
