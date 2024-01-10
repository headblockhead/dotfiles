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
        theme = pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "47f983185d0de4f2f38254df12bc791520666a6e";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "47f983185d0de4f2f38254df12bc791520666a6e";
            sha256 = "ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
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
