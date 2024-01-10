{
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark"; # Enable dark mode for GTK2
    };
    iconTheme = { name = "Adwaita"; };
    gtk2.extraConfig = ''gtk-application-prefer-dark-theme = "true"'';
    gtk3.extraConfig = { "gtk-application-prefer-dark-theme" = "true"; };
    gtk4.extraConfig = { "gtk-application-prefer-dark-theme" = "true"; };
  };
}
