{ pkgs, ... }: {
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    zeroconf.publish.enable = true;
    zeroconf.discovery.enable = true;
    tcp.anonymousClients.allowedIpRanges = "192.168.155.5";
  };
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.daemon.config = { enable-deferred-volume = false; };
}
