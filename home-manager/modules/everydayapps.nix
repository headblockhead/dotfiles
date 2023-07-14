{ pkgs, ... }: {
  home.packages = with pkgs; [
    google-chrome
    discord
  vlc
  spotify
  thunderbird
  libreoffice
  audacity
  ];
}
