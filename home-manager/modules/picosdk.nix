{ pkgs, ... }: {
  home.packages = with pkgs; [
    pico-sdk
    gcc
    cmake
    ccls
    gcc-arm-embedded
    picotool
    #  python39 
    minicom
    gnumake
  ];
  programs.zsh.initExtra = ''
    export PICO_SDK_PATH=~/pico-sdk
      if [ ! -d ~/pico-sdk ]
          then
            git clone https://github.com/raspberrypi/pico-sdk.git ~/pico-sdk
            git -C ~/pico-sdk submodule update --init ~/pico-sdk
            cp -r ${pkgs.pico-sdk}/lib/pico-sdk ~/pico-sdk
          fi
  '';


}
