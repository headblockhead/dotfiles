{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.gnupg
    pkgs.pinentry
  ];
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #    pinentryFlavor = "curses"; # works in console interactive only, does not work with vscode
    #    pinentryFlavor = "gtk2"; # creates a gtk popup
    pinentryFlavor = "gnome3"; # creates a gnome popup.
    enableSSHSupport = true;
  };
}
