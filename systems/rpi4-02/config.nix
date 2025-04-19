{ outputs, ... }:
{
  networking.hostName = "rpi4-02";

  imports = with outputs.nixosModules; [
    basicConfig
    distributedBuilds
    fzf
    git
    homeManager
    ssh
    users
    zsh
  ];

  networking.firewall.allowedTCPPorts = [ 8123 ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "Europe/London";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
      ];
    };
  };

  environment.systemPackages = [
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.05";
}
