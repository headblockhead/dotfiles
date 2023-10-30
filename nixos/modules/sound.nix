{ pkgs, ... }: {
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    zeroconf.publish.enable = true;
    zeroconf.discovery.enable = true;
    tcp.enable = true;
    tcp.anonymousClients.allowAll = true;
  };
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.daemon.config = { enable-deferred-volume = false; };
}
