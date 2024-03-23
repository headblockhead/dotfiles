let
  # Computer specific keys:
  router-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh root@compute-01'';
  edward-desktop-01-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh root@compute-01'';
  edward-laptop-01-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh root@compute-01'';
  edward-laptop-02-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh root@compute-01'';
  barkup-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh root@compute-01'';
in
{
  users.users.nixbuilder = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirt" "docker" "nixbld" ];
    openssh.authorizedKeys.keys = [
      router-key
      edward-desktop-01-key
      edward-laptop-01-key
      edward-laptop-02-key
      barkup-key
    ];
  };
  nix.buildMachines = [
    {
      hostName = "edward-desktop-01";
      system = "x86_64-linux";
      sshUser = "headb";
      protocol = "ssh-ng";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
      maxJobs = 16;
      speedFactor = 10;
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
