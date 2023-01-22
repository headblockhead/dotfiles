{ pkgs, ... }: {
  home.packages = with pkgs; [
    pico-sdk
  gcc
  cmake
  ccls 
  gcc-arm-embedded
  picotool
  python39 
  minicom
  gnumake
];
}
