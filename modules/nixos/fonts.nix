{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    powerline
    ubuntu_font_family
    nerdfonts
    ibm-plex
    source-code-pro
  ];
}
