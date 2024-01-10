{ pkgs, lib, inputs, ... }:

{
  imports = [
    ../modules/basicConfig.nix
    ../modules/ssh.nix
    ../modules/minecraftServer.nix
    ../modules/users.nix
    ../modules/firewall.nix
    ../modules/zsh.nix

    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  environment.systemPackages = [
    pkgs.home-manager
    pkgs.neovim
    pkgs.git
  ];

  # Hostname of the machine.
  networking.hostName = "barkup";

  # No root!
  services.openssh.settings.PermitRootLogin = lib.mkForce "no";

  # Passwordless sudo for wheel group.
  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
