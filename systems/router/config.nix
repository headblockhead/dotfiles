{ outputs, config, pkgs, ... }:
let
  snapweb = pkgs.fetchzip {
    url = "https://github.com/badaix/snapweb/releases/download/v0.8.0/snapweb.zip";
    hash = "sha256-IpT1pcuzcM8kqWJUX3xxpRQHlfPNsrwhemLmY0PyzjI=";
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

  environment.systemPackages = [
    pkgs.xc
  ];

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.snapserver = {
    enable = true;

    listenAddress = "192.168.2.1";
    port = 1704;

    sampleFormat = "44100:16:2";
    codec = "pcm";
    buffer = 1000;
    sendToMuted = true;

    streams = {
      "Spotify" = {
        type = "process";
        location = "${pkgs.librespot}/bin/librespot";
        query = {
          params = "--zeroconf-port=5354 --name House --bitrate 320 --backend pipe --initial-volume 100 --quiet";
        };
      };
    };

    http = {
      enable = true;
      port = 1780;
      listenAddress = "192.168.1.1";
      docRoot = snapweb;
    };
  };

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-7_0;
  };

  services.nix-serve = {
    enable = true;
    bindAddress = "cache.router.lan";
    secretKeyFile = "/var/cache-private-key.pem";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      cache = {
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

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.05";
}
