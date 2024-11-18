{ pkgs, ... }:
{
  # Clear the tmp directory on boot.
  boot.tmp.cleanOnBoot = true;

  # Enable nixos-help apps.
  documentation.nixos.enable = true;

  # Set regonal settings.
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "us";

  # Set the trusted users.
  nix.settings.trusted-users = [ "headb" ];

  console = {
    earlySetup = true;
    #font = ./font.psf;
    packages = with pkgs; [ (nerdfonts.override { fonts = [ "SourceCodePro" ]; }) ];
  };
}
