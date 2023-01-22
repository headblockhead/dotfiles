{ pkgs, ... }: {
# Use the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        #walyand = false; # Disable wayland to allow for legacy screen share (Steam, Zoom etc.)
      };
    };
    desktopManager.gnome.enable = true;
  };
  services.xserver.libinput.enable = true;
  # Exclude certain xserver packages.
  services.xserver.excludePackages = [ pkgs.xterm ];
}
