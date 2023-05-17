{ pkgs, ... }: {
  home.packages = with pkgs; [
  remmina
  zoom-us
  blender
  musescore
  obs-studio
  cura 
  onedrive 
  deja-dup
  kdenlive
  gimp
  transgui
  monero-gui
    teams
    rpi-imager
    lmms
    arduino
    thonny
    chiaki
  ];
}
