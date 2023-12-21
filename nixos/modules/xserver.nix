{ pkgs, ... }: {
  # Use the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        autoSuspend = false;
        #        wayland = false; # Disable wayland, this removes support for starting gnome as wayland as well!
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
