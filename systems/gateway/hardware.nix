{ config, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];

  boot.blacklistedKernelModules = [ "r8169" ];
  boot.kernelModules = [ "r8125" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    r8125
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
