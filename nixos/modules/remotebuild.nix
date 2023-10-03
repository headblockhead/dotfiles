{config,pkgs,...}:
{
  nix.buildMachines= [
    {
    hostName = "compute-01";
    system = "x86_64-linux";
    sshKey = "/home/headb/.ssh/id_rsa";
    sshUser = "headb";
    protocol = "ssh";
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
    maxJobs = 4;
  }
];
  nix.distributedBuilds = true;
    nix.extraOptions = ''
      builders-use-substitutes = true
  '';
}