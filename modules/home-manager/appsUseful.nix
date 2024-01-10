{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-chrome
    discord
    vlc
    spotify
    thunderbird
    libreoffice
    obsidian # uses electron-25.9.0, outdated :(
    audacity
  ];
}
