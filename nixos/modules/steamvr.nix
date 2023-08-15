{config,pkgs,...}:
{
  environment.systemPackages = [
    pkgs.sidequest
    pkgs.alvr
  ];
}
