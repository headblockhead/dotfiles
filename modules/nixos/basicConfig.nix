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

  services.kmscon = {
    enable = true;
    fonts = [{ name = "SauceCodePro Nerd Font Mono"; package = (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; }); }];
    hwRender = true;
  };
}
