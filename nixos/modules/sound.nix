{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pavucontrol
    paprefs
    qjackctl
    jack2
  ];
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };
  users.extraUsers.headb.extraGroups = [ ];
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  #  hardware.pulseaudio.daemon.config = { enable-deferred-volume = false; };
}
