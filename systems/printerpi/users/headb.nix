{ outputs, ... }:
{
  imports = with outputs.homeManagerModules; [
    basicConfig
    neovim
    zsh
  ];

  home.username = "headb";
  home.homeDirectory = "/home/headb";

  home.packages = [ ];

  home.stateVersion = "22.05";
}
