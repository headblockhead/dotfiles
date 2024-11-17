{ pkgs, ... }: {
  programs.hyprland.enable = true;

  environment.systemPackages = [
    pkgs.kitty
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Symlink fonts into /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Install fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
}
