# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  # Use the GRUB bootloader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
    # Enable plymouth for boot animations
    plymouth = { enable = true; };
    # Silent Boot
    # https://wiki.archlinux.org/title/Silent_boot
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd = { verbose = false; };
  };

  # Allow nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Clear the tmp directory on boot.
  boot.cleanTmpDir = true;

  # Allow proprietary packages.
  nixpkgs.config.allowUnfree = true;

  # Networking settings.
  networking.hostName = "edwards-laptop-2";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.155.1" "1.1.1.1" ];

  # Localisation.
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  # Bluetooth support.
  hardware.bluetooth.enable = true;

  # Audio configuration.
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  sound.enable = true;
  security.rtkit.enable = true;

  # Printing support.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  # Touchpad support.
  services.xserver.libinput.enable = true;

  # Define users. Passwords need to be defined manually using passwd. This config will not set passwords.
  # There is an option to set a password hash for a user, however it is hard to store secrets safely in a public github repo.
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root.hashedPassword = "!"; # Disable root login
      headb = {
        description = "Edward Hesketh";
        isNormalUser = true;
        extraGroups =
          [ "wheel" "networkmanager" "docker" "dialout" "transmission" ];
      };
    };
  };
  # Global system packages - available to all users.
  environment.systemPackages = [
    pkgs.neovim
    pkgs.git
    pkgs.zsh
    pkgs.home-manager
  ];

  # Fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    ibm-plex
    source-code-pro
    ubuntu_font_family
    (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
  ];

  # Use the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
      };
    };
    desktopManager.gnome.enable = true;
  };

  # Exclude certain xserver packages.
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Disable nixos-help apps.
  documentation.nixos.enable = false;

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

  # Add udev rules.
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  # Allow gnome theming
  programs.dconf.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

