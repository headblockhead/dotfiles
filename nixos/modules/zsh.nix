{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.zsh
    pkgs.git
  ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
