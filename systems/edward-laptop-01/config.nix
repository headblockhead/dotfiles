{ inputs, outputs, lib, config, pkgs, agenix, ... }:
{
  networking.hostName = "edward-laptop-01";

  imports = with outputs.nixosModules; [
    basicConfig
    bluetooth
    bootloaderGraphical
    cachesGlobal
    cachesLocal
    desktop
    development
    distributedBuilds
    fileSystems
    firewall
    fzf
    git
    gpg
    homeManager
    network
    printer
    sdr
    sound
    ssd
    ssh
    users
    zsh
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
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

  # Extra packages to install.
  environment.systemPackages = [
    agenix.packages.x86_64-linux.default
    pkgs.xc

    pkgs.firefox
    pkgs.tor-browser-bundle-bin
    pkgs.musescore
    pkgs.audacity
    pkgs.ardour
    pkgs.vlc
    pkgs.x32edit
    pkgs.p7zip
    pkgs.libreoffice
    pkgs.super-slicer
  ];

  # Grub settings.
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.gfxmodeEfi = "1600x900x32";

  # Do not sleep on lid close when docked/plugged in.
  services.logind.extraConfig = ''
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
  '';

  # find / -name '*.desktop' 2> /dev/null
  services.xserver.desktopManager.gnome.favoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[ 'firefox.desktop', 'torbrowser.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Settings.desktop','org.gnome.Calculator.desktop', 'org.rncbc.qjackctl.desktop', 'ardour8.desktop', 'vlc.desktop', 'audacity.desktop' ]
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

