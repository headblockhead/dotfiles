{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.home-manager
  ];
}
