{ outputs, pkgs, ... }:

{
  networking.hostName = "edward-dell-01";

  imports = with outputs.nixosModules; [
    basicConfig
    bluetooth
    bootloaderGraphical
    cachesGlobal
    desktop
    fileSystems
    fonts
    fzf
    git
    gpg
    homeManager
    network
    sound
    ssh
    ssd
    users
    zsh
  ];

  # Extra packages to install
  environment.systemPackages = [
    pkgs.arduino
    pkgs.audacity
    pkgs.cachix
    pkgs.ccls
    pkgs.ciscoPacketTracer8
    pkgs.cmake
    pkgs.deja-dup
    pkgs.discord
    pkgs.firefox
    pkgs.fractal # matrix messenger
    pkgs.furnace # chiptune tracker
    pkgs.gcc
    pkgs.gcc-arm-embedded
    pkgs.gimp
    pkgs.gnumake
    pkgs.go
    pkgs.google-chrome
    pkgs.gopass
    pkgs.gopls
    pkgs.ifuse # optional, to mount using 'ifuse'
    pkgs.inetutils
    pkgs.inkscape
    pkgs.killall
    pkgs.libimobiledevice
    pkgs.libreoffice
    pkgs.lm_sensors
    pkgs.lua5_4
    pkgs.minicom
    pkgs.neofetch
    pkgs.neovim
    pkgs.ngrok
    pkgs.nixfmt-rfc-style
    pkgs.nmap
    pkgs.nodejs
    pkgs.obs-studio
    pkgs.obsidian
    pkgs.onedrive
    pkgs.onedrivegui
    pkgs.openscad-unstable
    pkgs.p7zip
    pkgs.pico-sdk
    pkgs.picotool
    pkgs.platformio
    pkgs.pulseview
    pkgs.python39
    pkgs.remmina
    pkgs.rustc
    pkgs.slack
    pkgs.spotify
    pkgs.thunderbird
    pkgs.tmux
    pkgs.unstable.freecad-wayland
    pkgs.unstable.musescore
    pkgs.unstable.rpi-imager
    pkgs.usbutils
    pkgs.vlc
    pkgs.wireshark
    pkgs.xc
    pkgs.zoom-us
  ];

  services.xserver.desktopManager.gnome.favoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[ 'firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Settings.desktop', 'org.gnome.Calculator.desktop', 'org.freecad.FreeCAD.desktop', 'org.kicad.kicad.desktop', 'gnome-system-monitor.desktop', 'thunderbird.desktop', 'slack.desktop', 'spotify.desktop']
  '';

  system.stateVersion = "22.05";
}
