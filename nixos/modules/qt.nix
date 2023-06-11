{pkgs,...}:
{
environment.sessionVariables = {
    QT_STYLE_OVERRIDE="adwaita-dark";
  };

  qt5.style = "adwaita-dark";
}
