{ pkgs, ... }: {
  home.packages = with pkgs; [
    unityhub # Game-making tool - Launcher for Unity.
  ];
}
