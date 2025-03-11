{ outputs, pkgs, config, ... }:
{
  networking.hostName = "rpi5-01";

  imports = with outputs.nixosModules; [
    basicConfig
    cachesGlobal
    cachesLocal
    distributedBuilds
    git
    githubActions
    homeManager
    ssh
    users
    zsh
  ];

  services.nix-serve = {
    enable = true;
    bindAddress = "127.0.0.1"; # Forwarded by nginx
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/var/cache-private-key.pem";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "cache.edwardh.lan" = {
        locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
    };
  };

  environment.systemPackages = [
    pkgs.xc
  ];

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "23.05";
}
