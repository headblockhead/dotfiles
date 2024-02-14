{ pkgs, lib, ... }: {
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
      };
    };
    desktopManager.gnome = {
      enable = true;

    };
  };

  # Touchpad/touchscreen support.
  services.xserver.libinput.enable = true;

  # Exclude certain xserver packages.
  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = with pkgs; [
    xorg.xhost
    gnomeExtensions.appindicator # Tray icons
  ];

  # GNOME terminal - replaces the console.
  programs.gnome-terminal.enable = true;

  services.gnome.gnome-keyring.enable = lib.mkForce false; # Dont mess with SSH_AUTH_SOCK

  # Exclude certain default gnome apps.
  # See https://github.com/NixOS/nixpkgs/blob/127579d6f40593f9b9b461b17769c6c2793a053d/nixos/modules/services/x11/desktop-managers/gnome.nix#L468 for a list of apps.
  environment.gnome.excludePackages = (with pkgs.gnome; [
    pkgs.gnome-tour # Tour
    # gnome-logs # Logs
    yelp # Help
    gnome-maps # Maps
    gnome-music # Music
    geary # Geary (Mail)
    epiphany # Web
    gnome-characters # Characters
    pkgs.gnome-console # Console - basic terminal emulator
    totem # Videos
    pkgs.gnome-photos # Photos
    gnome-contacts # Contacts
    gnome-maps # Maps
    gnome-music # Music
    gnome-weather # Weather
    pkgs.gnome-connections # Connections
  ]);

  # Add udev rules.
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  environment.sessionVariables = {
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  qt.style = "adwaita-dark";

  # Symlink fonts into /run/current-system/sw/share/X11/fonts
  fonts.fontDir.enable = true;

  # Install fonts
  fonts.packages = with pkgs; [
    powerline
    ubuntu_font_family
    nerdfonts
    ibm-plex
    source-code-pro
  ];

}
