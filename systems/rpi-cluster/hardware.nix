{ lib, ... }:
{
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;

  # The serial ports listed here are:
  # - ttyS0: for Tegra (Jetson TX1)
  # - ttyAMA0: for QEMU's -machine virt
  boot.kernelParams = [ "console=ttyS0,115200n8" "console=ttyAMA0,115200n8" "console=tty0" ];
}
