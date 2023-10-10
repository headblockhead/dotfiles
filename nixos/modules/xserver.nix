{ pkgs, ... }: {
# Use the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
#        wayland = false; # Disable wayland, causes glitches.
      };
    };
    desktopManager.gnome.enable = true;
  };
  environment.systemPackages = with pkgs; [
    xorg.xhost
  ];
  services.xserver.libinput.enable = true;
  # Exclude certain xserver packages.
  services.xserver.excludePackages = [ pkgs.xterm ];
}
