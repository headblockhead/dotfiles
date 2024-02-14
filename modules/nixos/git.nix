{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    difftastic
    gh
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    prompt.enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      diff.external = "difft";
    };
  };
}
