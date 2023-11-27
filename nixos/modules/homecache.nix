{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];
}
