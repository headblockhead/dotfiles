{ outputs, pkgs, config, ... }:
{
  networking.hostName = "rpi5-01";

  imports = with outputs.nixosModules; [
    basicConfig
    cachesGlobal
    cachesLocal
    distributedBuilds
    git
    homeManager
    ssh
    users
    zsh
  ];

  # TODO: add harmonia cert
  #services.harmonia = {
  #enable = true;
  #signKeyPaths = [ config.age.secrets.harmonia-signing-key.path ];
  #};

  # TODO: add NCPS
  #  services.ncps = {
  #enable = true;
  #server.addr = "127.0.0.1:8501";
  #upstream.caches = [
  ## TODO: add harmonia
  #"https://nix-community.cachix.org"
  #"https://cache.nixos.org/"
  #];
  #};

  #networking.firewall.allowedTCPPorts = [ 80 ]; # TODO: switch to HTTPS

  #  services.nginx = {
  #enable = true;
  #recommendedProxySettings = true;
  #virtualHosts = {
  #"cache.edwardh.lan" = {
  #locations."/".proxyPass = "http://${config.services.ncps.server.addr}:8501";
  #};
  #};
  #};

  environment.systemPackages = [
  ];

  security.sudo.wheelNeedsPassword = false;
  system.stateVersion = "23.05";
}
