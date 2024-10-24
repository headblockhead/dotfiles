{ inputs, outputs, lib, config, pkgs, agenix, ... }:

{
  networking.hostName = "brick";

  imports = with outputs.nixosModules; [
    basicConfig
    bluetooth
    bootloaderGraphical
    cachesGlobal
    desktop
    fileSystems
    fonts
    fzf
    git
    gpg
    homeManager
    network
    sound
    ssh
    ssd
    openrgb
    users
    zsh
  ];

  networking.firewall.enable = lib.mkForce false;

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
    pkgs.ccls
    pkgs.cmake
    pkgs.unstable.freecad-wayland
    pkgs.gcc
    pkgs.gcc-arm-embedded
    pkgs.gnumake
    pkgs.go
    pkgs.gopass
    pkgs.gopls
    pkgs.inetutils
    pkgs.killall
    pkgs.lm_sensors
    pkgs.lua5_4
    pkgs.minicom
    pkgs.neofetch
    pkgs.ngrok
    pkgs.nixfmt-rfc-style
    pkgs.nmap
    pkgs.nodejs
    pkgs.p7zip
    pkgs.pico-sdk
    pkgs.picotool
    pkgs.platformio
    pkgs.pulseview
    pkgs.python39
    pkgs.rustc
    pkgs.tmux
    pkgs.usbutils
    pkgs.wireshark
    pkgs.neovim
    pkgs.xc

    pkgs.libimobiledevice
    pkgs.ifuse
    pkgs.arduino
    pkgs.audacity
    #pkgs.blender-hip
    pkgs.firefox
    pkgs.fractal
    pkgs.gimp
    pkgs.google-chrome
    #pkgs.kdenlive
    pkgs.kicad
    pkgs.libreoffice
    pkgs.unstable.musescore
    pkgs.obs-studio
    pkgs.remmina
    pkgs.spotify
    pkgs.slack
    pkgs.thunderbird
    pkgs.unstable.rpi-imager
    pkgs.vlc
    pkgs.zoom-us
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
