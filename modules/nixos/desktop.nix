{ pkgs, ... }: {
  programs.hyprland.enable = true;

  services.displayManager.sddm = {
    package = pkgs.kdePackages.sddm;
    enable = true;
    enableHidpi = true;
    theme = "where_is_my_sddm_theme";
  };

  environment.systemPackages = [
    pkgs.kitty
    pkgs.where-is-my-sddm-theme.override
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Symlink fonts into /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Install fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
}
