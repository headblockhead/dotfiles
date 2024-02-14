{
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      }; # Use the systemd-boot EFI boot loader.
      systemd-boot = {
        enable = true;
      };
    };
    # Enable plymouth for boot animations
    plymouth = { enable = false; };
    consoleLogLevel = 6; # informational
    initrd = { verbose = true; };
  };
}
