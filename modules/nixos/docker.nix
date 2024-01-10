{ pkgs, ... }: {
  # Include docker-compose in the environment.
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # Enable docker and management of docker without root.
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
