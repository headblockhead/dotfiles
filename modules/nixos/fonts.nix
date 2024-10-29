{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    powerline
    google-fonts.out
    ubuntu_font_family
    nerdfonts
    ibm-plex
    source-code-pro
  ];
}
