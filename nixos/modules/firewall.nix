{ pkgs, ... }: {
  networking.firewall = {
    enable = true;
    logReversePathDrops = true;
    allowedTCPPorts = [8000];
  };
}
