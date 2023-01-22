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
];
}
