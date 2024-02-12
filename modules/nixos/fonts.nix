{ pkgs, ... }: {
  # Symlink fonts into /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Install fonts
  fonts.packages = with pkgs; [
    powerline
    ubuntu_font_family
    nerdfonts
    ibm-plex
    source-code-pro
  ];
}
