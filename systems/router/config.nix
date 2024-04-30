{ inputs, outputs, lib, config, pkgs, agenix, ... }:
let
  snapweb = pkgs.fetchzip {
    url = "https://github.com/badaix/snapweb/releases/download/v0.7.0/snapweb.zip";
    hash = "sha256-lyUmEgmyOvg4W19ruu6DwoeK8+Xs7akCMQlfIDo1OXA=";
    stripRoot = false; # Flat list of files
  };
in
{
  age.secrets.edward-spotify-username.file = ../../secrets/edward-spotify-username.age;
  age.secrets.edward-spotify-password.file = ../../secrets/edward-spotify-password.age;
  networking.hostName = "router";

  imports = with outputs.nixosModules; [
    basicConfig
    bootloaderText
    cachesGlobal
    cachesLocal
    distributedBuilds
    fileSystems
    git
    homeManager
    minecraftServer
    router # The main one!
    ssd
    ssh
    users
    zsh

    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  services.avahi = {
    enable = true;
    reflector = true;
    #allowInterfaces = [ "enp5s0" "enp4s0" ];
    publish = {
      enable = true;
      workstation = true;
      userServices = true;
    };
  };

  services.snapserver = {
    enable = true;
    http = {
      enable = true;
      port = 1780;
      docRoot = snapweb;
    };
    sampleFormat = "44100:16:2";
    streams = {
      "SpotifyLAN" = {
        type = "process";
        location = "${pkgs.librespot}/bin/librespot";
        query = {
          params = "--zeroconf-port=5354 --name House --bitrate 320 --backend pipe --initial-volume 100 --quiet";
        };
      };
      "SpotifyEdward" = {
        type = "process";
        location = "${pkgs.librespot}/bin/librespot";
        query = {
          params = ''--name Snapcast --bitrate 320 --backend pipe --initial-volume 100 --quiet --username ${(builtins.readFile config.age.secrets.edward-spotify-username.path)} --password ${(builtins.readFile config.age.secrets.edward-spotify-password.path)}'';
        };
      };
    };
  };

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi7;
    maximumJavaHeapSize = 256;
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "h6cache.lan" = {
        locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.nix-minecraft.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; }))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

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
    pkgs.xc
  ];

  # Passwordless sudo for wheel group.
  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

