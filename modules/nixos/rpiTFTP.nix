{ config, pkgs, systemname, systemserial, ... }:
{
  imports = [ ./rpiBoot.nix ./rpiFirmware.nix ];
  system.build.rpiTFTP = pkgs.callPackage
    ({ stdenv, fetchurl, ... }: stdenv.mkDerivation {
      name = "rpiTFTP";
      src = fetchurl {
        url = "https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz";
        hash = "sha256-JQub2QlF02FZanpplD0L3F/AwJF6pWJgn40wWKLDazo=";
      };
      buildCommand = ''
        # Create the directory structure
        mkdir -p $out
        mkdir -p $out/dtb
        mkdir -p $out/${systemname}
        mkdir -p $out/pxelinux.cfg

        # Copy the boot firmware (config.txt, start.elf, etc)
        # This is what is first read by the Raspberry Pi, contains u-boot.
        cp -r ${config.system.build.rpiFirmware}/firmware/* $out/

        # Copy the kernel (dtbs, Image, lib, System.map)
        # This is the Linux kernel, which is loaded by u-boot.
        cp -r ${config.system.build.kernel}/* $out/${systemname}/

        # Make a second copy of the dtbs, because u-boot needs them in a different place
        cp -r ${config.system.build.kernel}/dtbs/* $out/dtb/

        # Copy the ramdisk (initrd)
        # This is the temporary root filesystem, which is loaded by the kernel.
        cp -r ${config.system.build.netbootRamdisk}/* $out/${systemname}/

        # Copy syslinux.
        tar -xzf $src
        cp -r syslinux-6.03/bios/com32/chain/chain.c32 $out/
        cp -r syslinux-6.03/bios/com32/mboot/mboot.c32 $out/
        cp -r syslinux-6.03/bios/memdisk/memdisk $out/
        cp -r syslinux-6.03/bios/com32/menu/menu.c32 $out/
        cp -r syslinux-6.03/bios/core/pxelinux.0 $out/
      '';
    }
    )
    { };
}

