{ pkgs, ... }: {
  # GnuPG and smart card pinentry tools.
  environment.systemPackages = [
    pkgs.gnupg
    pkgs.pinentry
  ];

  # Smart card daemon.
  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses"; # works in console interactive only, does not work with GUI apps.
    # pinentryFlavor = "gtk2"; # creates a gtk popup
    # pinentryFlavor = "gnome3"; # creates a gnome popup.
    enableSSHSupport = true;
  };
}
