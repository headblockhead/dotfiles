{ pkgs, ... }: {
  home.packages = with pkgs; [
  oh-my-zsh
    zsh
  ];
programs.zsh = {
  enable = true;
  enableAutosuggestions = true;
  oh-my-zsh = {
    enable = true;
  };
  initExtra = ''
    source ~/custom.zsh-theme
    export PATH="$GOBIN:$PATH"
    export ZSH_HIGHLIGHT_STYLES[comment]=fg=245,bold
    export PLAYDATE_SDK_PATH="~/playdatesdk-1.12.3"
    export NIXPKGS_ALLOW_UNFREE="1"
    export PICO_SDK_PATH="~/pico-sdk"
    export QT_STYLE_OVERRIDE="adwaita-dark"
    if [ ! -d ~/pico-sdk ]
    then
      git clone https://github.com/raspberrypi/pico-sdk.git ~/pico-sdk
      git -C ~/pico-sdk submodule update --init ~/pico-sdk
      cp -r ${pkgs.pico-sdk}/lib/pico-sdk ~/pico-sdk
    fi
  '';
  plugins = [
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "0.7.1";
        sha256 = "gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
      };
    }
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.5.0";
        sha256 = "IT3wpfw8zhiNQsrw59lbSWYh0NQ1CUdUtFzRzHlURH0=";
      };
    }
  ];
  shellAliases = {
    q = "exit";
    p = "gopass show -c -n";
    ls = "ls --color=tty -A";
  };
};
}
