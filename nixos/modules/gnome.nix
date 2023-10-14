{ pkgs, lib, ... }: {
  # Allow gnome theming
  programs.dconf.enable = true;
  # Exclude certain default gnome apps.
  # See https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/x11/desktop-managers/gnome.nix#L251 for a list of all apps.
  services.gnome.gnome-keyring.enable = lib.mkForce false; # set SSH_AUTH_SOCK correctly
  environment.gnome.excludePackages = (with pkgs.gnome; [
    pkgs.gnome-tour # Tour
    # gnome-logs # Logs
    yelp # Help
    gnome-maps # Maps
    gnome-music # Music
    geary # Geary (Mail)
    epiphany # Web
    gnome-characters # Characters
    pkgs.gnome-console # the Console - a "simplified" terminal emulator :P
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
