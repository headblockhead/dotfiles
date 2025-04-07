{ outputs, config, ... }:
{
  networking.hostName = "rpi5-01";

  disabledModules = [
    "services/networking/ncps.nix" # upstream nixpkgs has errors, remove when #396901 merged
  ];

  imports = with outputs.nixosModules; [
    basicConfig
    distributedBuilds
    git
    homeManager
    ssh
    users
    zsh

    ncps # custom module
  ];

  age.secrets.harmonia-signing-key.file = ../../secrets/harmonia-signing-key.age;
  age.secrets.ncps-signing-key.file = ../../secrets/ncps-signing-key.age;

  services.harmonia = {
    enable = true;
    signKeyPaths = [ config.age.secrets.harmonia-signing-key.path ];
  };

  services.ncps = {
    enable = true;
    server.addr = "127.0.0.1:8501";
    upstream.caches = [
      "http://localhost:5000" # Harmonia
      "https://nix-community.cachix.org"
      "https://cachix.cachix.org"
      "https://cache.nixos.org/"
    ];
    upstream.publicKeys = [
      "localhost-1:399MbAJBhAFFfUt+JVjnnCvcM4iWkhlIYMLV4eAvEec="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    cache = {
      secretKeyPath = config.age.secrets.ncps-signing-key.path;
      hostName = "cache.edwardh.dev";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "cache.edwardh.dev" = {
        locations."/".proxyPass = "http://127.0.0.1:8501";
      };
    };
  };

  environment.systemPackages = [
  ];

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "23.05";
}
