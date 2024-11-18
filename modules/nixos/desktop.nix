{ pkgs, ... }: {
  programs.hyprland.enable = true;

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = [
      pkgs.libsForQt5.qt5.qtgraphicaleffects
    ];
    wayland.enable = true;
    enableHidpi = true;
    theme = "where_is_my_sddm_theme";
  };

  environment.systemPackages = [
    pkgs.kitty
    pkgs.where-is-my-sddm-theme
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Symlink fonts into /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Install fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
}
