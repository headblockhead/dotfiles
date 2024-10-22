{ inputs, outputs, lib, config, pkgs, agenix, ... }:
let
  snapweb = pkgs.fetchzip {
    url = "https://github.com/badaix/snapweb/releases/download/v0.7.0/snapweb.zip";
    hash = "sha256-lyUmEgmyOvg4W19ruu6DwoeK8+Xs7akCMQlfIDo1OXA=";
    stripRoot = false; # Flat list of files
  };
in
{
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
    router
    ssd
    ssh
    users
    zsh
  ];

  services.vault = {
    enable = true;
    address = "192.168.1.1:8200";
  };

  services.avahi = {
    enable = true;
    #reflector = true;
    #allowInterfaces = [ "enp5s0" "enp4s0" ];
    publish = {
      enable = true;
      #workstation = true;
      userServices = true;
    };
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      /srv/mpd 192.168.1.1/24(rw,insecure,sync)
    '';
    createMountPoints = true;
  };

  services.mpd = {
    enable = true;
    network.listenAddress = "192.168.1.1";
    musicDirectory = "/srv/mpd";
    extraConfig = ''
      audio_output {
        type            "fifo"
        encoder         "flac"
        name            "snapserver"
        format          "44100:16:2"
      	path		"/run/snapserver/mpd"
      	compression	"8"
      	mixer_type	"software"
      }
    '';
  };

  services.snapserver = {
    enable = true;
    http = {
      enable = true;
      port = 1780;
      listenAddress = "192.168.1.1";
      docRoot = snapweb;
    };
    sampleFormat = "44100:16:2";
    codec = "flac";
    sendToMuted = true;
    streams = {
      "Spotify" = {
        type = "process";
        location = "${pkgs.librespot}/bin/librespot";
        query = {
          params = "--zeroconf-port=5354 --name House --bitrate 320 --backend pipe --initial-volume 100 --quiet";
        };
      };
      "mpd" = {
        type = "pipe";
        location = "/run/snapserver/mpd";
        sampleFormat = "44100:16:2";
        codec = "flac";
      };
      "Home Assistant" = {
        type = "tcp";
        location = "192.168.1.1:4953";
        sampleFormat = "48000:16:2";
      };
    };
  };

  #services.unifi = {
  #enable = true;
  #unifiPackage = pkgs.unifi7;
  #maximumJavaHeapSize = 256;
  #};

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "local-cache.lan" = {
        locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
    };
  };

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "04:00" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

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
