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
    key = "7B485B936DB40FD57939E2A8A5D1F48A8CDD4F44";
    gpgPath = "/run/current-system/sw/bin/gpg2";
    signByDefault = true;
  };
  extraConfig = { pull.rebase = false; commit.gpgsign = true;};
};

}
