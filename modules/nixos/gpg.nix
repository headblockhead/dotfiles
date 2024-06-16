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
    pinentryPackage = pkgs.pinentry-tty;
    enableSSHSupport = true;
  };
}
