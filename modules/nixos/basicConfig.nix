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

  # Set the trusted settings
  systemd.tmpfiles.rules = [
    "f /home/headb/.local/share/nix/trusted-settings.json 0644 headb users - ${./trusted-settings.json}"
  ];
}
