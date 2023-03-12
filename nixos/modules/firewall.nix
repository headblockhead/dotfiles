{ pkgs, ... }: {
  networking.firewall = {
    enable = false;
    logReversePathDrops = true;
    allowedTCPPorts = [8000];
  };
}
