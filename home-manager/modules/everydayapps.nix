{ pkgs, ... }: {
  home.packages = with pkgs; [
    #    (google-chrome.override {
    #  commandLineArgs = [
    #    "--ozone-platform=wayland"
    #    "--disable-features=WaylandFractionalScaleV1"
    #  ];
    #})
    firefox
    discord
    vlc
    spotify
    thunderbird
    libreoffice
    audacity
  ];
}
