{ pkgs, ... }:
{
  environment.sessionVariables = {
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  qt.style = "adwaita-dark";
}
