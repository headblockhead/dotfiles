{ pkgs, ... }:
{
  programs.adb.enable = true;
  programs.wireshark.enable = true;
  environment.systemPackages = with pkgs; [
    # unityhub
    asciinema
    awscli2
    bat
    bind
    btop
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
    pico-sdk
    picotool
    platformio
    pulseview
    python313
    qemu
    rustc
    templ
    tmux
    unstable.go_1_24
    usbutils
    wireguard-tools
    wireshark
    xc
    pciutils
  ];
}
