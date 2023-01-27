{ pkgs, ... }: {
  # Allow gnome theming
  programs.dconf.enable = true;
# Exclude certain default gnome apps.
  # See https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/x11/desktop-managers/gnome.nix#L251 for a list of all apps.
  environment.gnome.excludePackages = (with pkgs.gnome; [
    pkgs.gnome-tour # Tour
    gnome-logs # Logs
    yelp # Help
    cheese # Cheese
    gnome-maps # Maps
    gnome-music # Music
    geary # Geary (Mail)
    epiphany # Web
    gnome-characters # Characters
    pkgs.gnome-console # the dreaded Console
    totem # Videos
    pkgs.gnome-photos # Photos
    gnome-contacts # Contacts
    gnome-maps # Maps
    gnome-music # Music
    gnome-weather # Weather
    pkgs.gnome-connections # Connections
  ]);

  # Do not enable gnome remote desktop - it enables pipewire which can cause memory leaks.
  services.gnome.gnome-remote-desktop.enable = false;
  # Add udev rules.
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];
  }