# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  # Include the results of the hardware scan.
  imports = [ ./hardware-configuration.nix ];

  # Use the GRUB bootloader.
  boot.loader = {
    efi = { canTouchEfiVariables = true; };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  # Allow nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Clear the tmp directory on boot.
  boot.cleanTmpDir = true;

  # Allow proprietary packages.
  nixpkgs.config.allowUnfree = true;

  # Networking settings.
  networking.hostName = "edwards-laptop";
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

  # Enable virtualisation with virtualbox.
  virtualisation.virtualbox.host.enable = true;
  # VirtualBox Oracle Extensions
  virtualisation.virtualbox.host.enableExtensionPack = true;
  # VirtualBox Guest Additions
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;

  # Enable virtualisation with docker.
  virtualisation.docker.enable = true;

  # Sheepit Renderfarm is a blender renderfarm service. This image allows you to render other people's projects to earn points.
  virtualisation.oci-containers.containers.sheepit = {
    image = "sheepitrenderfarm/client:text";
    autoStart = false; # Only run when I ask. Do not start automatically.
    environment = {
      SHEEP_LOGIN = "headblockhead";
      SHEEP_PASSWORD =
        "xfbzVlWFQRTa5vUHnhCMVrswAy1HMiiEOLnpWMXW"; # This is a render key. This is not a password. It can only be used to render. It is randomly generated and can be revoked at any time.
      SHEEP_HOSTNAME = "nixos-thinkpad-docker";
      SHEEP_CORES = "2"; # Use only 2 cores.
      SHEEP_MEMORY = "8GB"; # Limit to 8GB to leave 4GB for the system.
    };
  };

  # Define users. Passwords need to be defined manually using passwd. This config will not set passwords.
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      headb = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
          "dialout"
          "vboxusers"
          "transmission"
        ];
      };
    };
  };
  # Global system packages - available to all users.
  environment.systemPackages = with pkgs; [
    neovim
    git
    zsh
    gnupg
    pinentry
    docker
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #    pinentryFlavor = "curses"; # works in console interactive only, does not work with vscode
    pinentryFlavor = "gtk2"; # creates a GUI window always, works with vscode
    enableSSHSupport = true;
  };

  # ZSH autocomplete
  programs.zsh.enable = true;

  # Network diagnostic tool.
  programs.mtr.enable = true;

  # SSH login support.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # Allow SSH connections.
    allowedUDPPorts = [ ];
  };

  # Fonts
  fonts.fonts = with pkgs; [
    ibm-plex
    powerline
    ubuntu_font_family
    siji
    unifont
    font-awesome
    roboto
  ];

  # Use the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm = { enable = true; };
    desktopManager.gnome = { enable = true; };
  };

  # Exclude certain xserver packages.
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Disable nixos-help apps.
  documentation.nixos.enable = false;

  # Exclude certain default gnome apps.
  # https://github.com/NixOS/nixpkgs/tree/master/pkgs/desktops/gnome/apps
  environment.gnome.excludePackages = (with pkgs; [ gnome-tour ])
    ++ (with pkgs.gnome; [
      gnome-music
      epiphany # web browser
      geary # email reader
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-calendar # calenidar
      gnome-characters # full unicode list to copy and paste from
      gnome-maps # maps
      gnome-todo # todo list
      gnome-weather # weather viewer
      vinagre # remote desktop viewer
      accerciser # accsesibility tester
    ]
  );

  # Do not enable gnome remote desktop - it enables pipewire which can cause memory leaks.
  services.gnome.gnome-remote-desktop.enable = false;

  # Add gnome udev rules.
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Allow gnome theming
  programs.dconf.enable = true;

  # Transmission service
  # Downloads in /var/lib/transmission/Downloads
  services.transmission = {
    enable = true;
    settings = {
      # The RPC is the web interface to communicate with transmission.
      rpc-whitelist = "127.0.0.1,::1"; # Only allow connections from localhost.
      rpc-host-whitelist = "127.0.0.1,::1"; # Only connect to localhost.
      rpc-user = "headb";
      rpc-username = "";
      rpc-password = "";

      start-added-torrents =
        false; # Do not start torrents as soon as they are added.
      encryption =
        1; # 0 - prefer unencrypted, 1 - prefer encrypted, 2 - require encrypted.
      lpd-enabled = true; # Local Peer Discovery

      port-forwarding-enabled = true; # Allow seeding.
      peer-port-random-on-start = true; # Randomise the port.
      peer-port-random-high = 65535;
      peer-port-random-low = 1000;

      speed-limit-down-enabled = false; # Do not limit the download speed.
      speed-limit-down = 800;
      speed-limit-up-enabled = true; # Do limit the upload speed.
      speed-limit-up = 500;

      upload-slots-per-torrent = 8;

      download-queue-enabled =
        true; # Only download a maximum of 3 torrents at once.
      download-queue-size = 3;

      queue-stalled-enabled =
        true; # If a torrent has not shared data for 1 hour, do not count it for the queue limits.
      queue-stalled-minutes = 60;

      seed-queue-enabled =
        false; # Don't limit the amount of torrents that can be seeded at once.
      seed-queue-size = 10;
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

