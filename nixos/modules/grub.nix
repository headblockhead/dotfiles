{ pkgs, ... }: {
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
  # Use the GRUB bootloader.
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
    # Enable plymouth for boot animations
    plymouth = { enable = true; };
    # Silent Boot
    # https://wiki.archlinux.org/title/Silent_boot
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd = { verbose = false; };
  };
}
