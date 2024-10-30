{ inputs, outputs, lib, config, pkgs, ... }:

{
  networking.hostName = "edward-desktop-01";

  imports = with outputs.nixosModules; [
    autoUpgrade
    basicConfig
    bluetooth
    bootloaderGraphical
    cachesGlobal
    cachesLocal
    desktop
    desktopApps
    development
    distributedBuilds
    docker
    fileSystems
    firewall
    fonts
    fzf
    git
    globalApps
    gpg
    homeManager
    network
    openrgb
    printer
    sdr
    sound
    ssd
    ssh
    users
    virtualBox
    yubikey
    zsh
  ];

  networking.firewall.enable = lib.mkForce false;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.distributedBuilds = lib.mkForce false; # Don't try to build on other machines

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  environment.systemPackages = [
    pkgs.deploy-rs
  ];

  # Grub settings.
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.gfxmodeEfi = "1920x1080x32";

  # find / -name '*.desktop' 2> /dev/null
  services.xserver.desktopManager.gnome.favoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[ 'firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Settings.desktop', 'org.gnome.Calculator.desktop', 'org.freecad.FreeCAD.desktop', 'org.kicad.kicad.desktop', 'gnome-system-monitor.desktop', 'thunderbird.desktop', 'slack.desktop', 'spotify.desktop', 'org.openrgb.OpenRGB.desktop']
  '';

  # https://www.mankier.com/5/tmpfiles.d
  systemd.tmpfiles.rules = [
    ''L+ /run/gdm/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
    ''L+ /home/headb/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

