{ pkgs, ... }:
{

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  systemd.user.sessionVariables = {
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };
}
