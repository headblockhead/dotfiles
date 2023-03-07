{ config, lib, pkgs, modulesPath, ... }:

{
    imports = [];

    boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [];

    fileSystems."/" = 
    { device = "/dev/disk/by-uuid/e9d20159-b7d2-449f-9b33-5a348925ccc3";
    fsType = "ext4";
};
fileSystems."/boot" = 
{device = "/dev/disk/by-uuid/5EAB-526A";
fsType = "vfat";
};
swapDevices = 
[ { device = "/dev/disk/by-uuid/943bf86a-9052-4b64-8daa-584e50b7da24";}
];

networking.useDHCP = lib.mkDefault true;

nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
virtualisation.virtualbox.guest.enable = true;
}
