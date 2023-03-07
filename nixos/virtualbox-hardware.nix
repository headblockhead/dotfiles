{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [];

    boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [];

    fileSystems."/" = 
    { device = "/dev/disk/by-uuid/f1d73a15-c320-4647-ab79-0f3f8d399e2f";
    fsType = "ext4";
};
fileSystems."/boot" = 
{device = "/dev/disk/by-uuid/7F93-FC02";
fsType = "vfat";
};
swapDevices = 
[ { device = "/dev/disk/by-uuid/435e86a2-6c84-44eb-a8a1-398c33827a5d";}
];

networking.useDHCP = lib.mkDefault true;

nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
virtualisation.virtualbox.guest.enable = true;
}
