{ config, pkgs, ... }:
{
  system.build.rpiBoot = pkgs.callPackage
    ({ stdenv, fetchurl, ... }: stdenv.mkDerivation {
      name = "rpiBoot";
      buildCommand = ''
        mkdir -p $out/boot
          ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d $out/boot
      '';
    }
    )
    { };
}

