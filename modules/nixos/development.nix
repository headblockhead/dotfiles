{ pkgs, ... }:
{
  programs.adb.enable = true;
  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs; [
    # unityhub
    PlaydateSimulator
    asciinema
    awscli2
    bat
    bind
    cargo
    ccls
    cmake
    cmatrix
    dconf-editor
    dig
    ec2-ami-tools
    flyctl
    freecad-wayland
    gcc
    gcc-arm-embedded
    gnumake
    go
    gopass
    gopls
    htop
    hugo
    inetutils
    killall
    lm_sensors
    lua5_4
    minicom
    neofetch
    neovim
    ngrok
    nixfmt-rfc-style
    nmap
    nodePackages.aws-cdk
    nodejs
    p7zip
    pdc
    pdutil
    pico-sdk
    picotool
    platformio
    playdatemirror
    pulseview
    python39
    qemu
    rustc
    templ
    tmux
    usbutils
    wireguard-tools
    wireshark
    xc
  ];
}
