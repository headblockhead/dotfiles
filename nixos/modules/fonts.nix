{ pkgs, ... }: {
# Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    ibm-plex
    powerline
    source-code-pro
    ubuntu_font_family
    nerdfonts
  ];
}
