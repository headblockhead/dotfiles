{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.zsh
  ];
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.bash;
  programs.zsh.enable = true;
}
