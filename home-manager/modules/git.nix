{ pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    git-lfs
    git
  ];
programs.gh = {
  enable = true;
  settings = {
    git_protocol = "ssh";
    prompt = "enabled";
    editor = "";
    pager = "";
    http_unix_socket = "";
    browser = "";
  };
};
programs.git = {
  enable = true;
  userName = "Edward Hesketh";
  userEmail = "headblockhead@gmail.com";
  difftastic = {
    enable = true;
    background = "dark";
    display = "inline";
  };
  signing = {
    key = "76C6E96B6A561DBE8F92B2E1AE25B4F5B6346CCF";
    gpgPath = "/run/current-system/sw/bin/gpg2";
    signByDefault = true;
  };
  extraConfig = { pull.rebase = false; commit.gpgsign = true;};
};

}
