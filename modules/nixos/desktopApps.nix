{ pkgs, ... }: {
  services.usbmuxd.enable = true;
  environment.systemPackages = with pkgs; [
    arduino
    audacity
    chiaki
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
    prusa-slicer
    rpi-imager
    slack
    spotify
    thonny
    unstable.thunderbird-latest
    tor-browser-bundle-bin
    vlc
    zoom-us
  ];
}
