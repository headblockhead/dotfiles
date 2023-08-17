{ pkgs, ... }: {
  home.packages = with pkgs; [
  pdc # PlayDateCompiler - Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
  pdutil # PlayDateUtility - Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
  PlaydateSimulator # Not in nixpkgs, overlayed by github:headblockhead/nix-playdatesdk. See flake.nix.
  gnumake
  gcc
  cmake
  ccls 
  gcc-arm-embedded
  playdatemirror
];
programs.zsh.initExtra = ''
export PLAYDATE_SDK_PATH="~/playdatesdk-`pdc --version`"
    if [ ! -d ~/pico-sdk ]
    then
      git clone https://github.com/raspberrypi/pico-sdk.git ~/pico-sdk
      git -C ~/pico-sdk submodule update --init ~/pico-sdk
      cp -r ${pkgs.pico-sdk}/lib/pico-sdk ~/pico-sdk
    fi
  '';
}
