{ pkgs, lib, sshkey, ... }:

{
  imports = [
    ./modules/basicpackages.nix
    ./modules/firewall.nix
    ./modules/region.nix
    ./modules/ssh.nix
    ./modules/minecraftserver.nix
    ./modules/users.nix
    ./modules/zsh.nix
  ];

  # Allow nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Clear the tmp directory on boot.
  boot.cleanTmpDir = true;

  # Allow proprietary packages.
  nixpkgs.config.allowUnfree = true;

  # Disable nixos-help apps.
  documentation.nixos.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
