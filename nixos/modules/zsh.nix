{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.zsh
    pkgs.git
  ];
  users.defaultUserShell = pkgs.bash;
  users.users.headb.shell = pkgs.zsh;
}
