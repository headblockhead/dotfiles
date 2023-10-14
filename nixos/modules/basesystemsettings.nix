{ config, pkgs, lib, ... }:

{
  # Allow reading of NTFS partitions
  boot.supportedFilesystems = [ "ntfs" ];
  # Allow nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Clear the tmp directory on boot.
  boot.tmp.cleanOnBoot = true;
  # Allow proprietary packages.
  nixpkgs.config.allowUnfree = true;
  # Enable nixos-help apps.
  documentation.nixos.enable = true;
}
