{ pkgs, ... }: {
# Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    ibm-plex
    source-code-pro
    (nerdfonts.override { fonts = [ "IBMPlexMono" "SourceCodePro"]; })
  ];
}
