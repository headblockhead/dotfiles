{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Do open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Do open ports in the firewall for Source Dedicated Server
  };
}
