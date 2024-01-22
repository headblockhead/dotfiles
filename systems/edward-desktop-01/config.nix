{ inputs, outputs, lib, config, pkgs, agenix, ... }:

{
  networking.hostName = "edward-desktop-01";

  imports = with outputs.nixosModules; [
    adb
    basicConfig
    bluetooth
    cachesGlobal
    # cachesLocal
    distributedBuilds
    docker
    fileSystems
    firewall
    fonts
    gnome
    gpg
    grub
    homeManager
    network
    openrgb
    printer
    qt
    sheepit
    sound
    ssd
    ssh
    transmission
    users
    # wireguard
    xserver
    yubikey
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

  # Extra packages to install
  environment.systemPackages = [
    agenix.packages.x86_64-linux.default
    pkgs.cachix
    pkgs.git
    pkgs.vim
    pkgs.deploy-rs
  ];

  # Grub settings.
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.gfxmodeEfi = "1920x1080x32";


  # https://www.mankier.com/5/tmpfiles.d
  systemd.tmpfiles.rules = [
    ''C /run/gdm/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  users.extraGroups.vboxusers.members = [ "headb" ];







  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

