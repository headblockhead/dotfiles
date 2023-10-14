{ pkgs, ... }: {
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  sound.enable = true;
  security.rtkit.enable = true;
  hardware.pulseaudio.daemon.config = { enable-deferred-volume = false; };
}
