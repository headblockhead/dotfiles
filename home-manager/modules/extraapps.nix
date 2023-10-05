{ pkgs, ... }: {
  home.packages = with pkgs; [
  remmina
  zoom-us
  (blender.override {
    cudaSupport = true;
  })
  fractal
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
  ];
}
