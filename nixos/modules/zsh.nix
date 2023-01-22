{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.zsh
  ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
