{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
    virtualisation.virtualbox.guest = {
enable = true;
seamless = true;
draganddrop = true;
clipboard = true;
};
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
