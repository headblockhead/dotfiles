{ pkgs, ... }: {
  home.packages = with pkgs; [
    pkgs.vscode
  ];
programs.vscode = {
  enable = true;
  userSettings = {
    "git.enableCommitSigning" = true;
    "editor.cursorSmoothCaretAnimation" = true;
    "git.enableSmartCommit" = true;
    "git.confirmSync" = false;
    "git.autofetch" = true;
    "files.eol" = ""; # Do not end files with a newline.
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.productIconTheme" = "material-product-icons";
    "editor.formatOnSave" = true;
    "terminal.integrated.fontFamily" = "Source Code Pro";
    "terminal.integrated.fontSize" = 12;
    "terminal.integrated.minimumContrastRatio" = 1;
    "editor.formatOnPaste" = true;
    "terminal.integrated.allowChords" = false;
    "terminal.integrated.altClickMovesCursor" = false;
    "terminal.integrated.drawBoldTextInBrightColors" = false;
    "workbench.colorTheme" = "Shades of Purple";
    "editor.inlineSuggest.enabled" = true;
    "security.workspace.trust.enabled" = true;
    "security.workspace.trust.untrustedFiles" = "open";
    "Lua.runtime.version" = "Lua 5.4";
    "Lua.diagnostics.globals" = [ "playdate" "import" ];
    "Lua.diagnostics.disable" = [ "undefined-global" "lowercase-global" ];
    "Lua.runtime.nonstandardSymbol" = [ "+=" "-=" "*=" "/=" ];
    "Lua.workspace.library" = [ "/home/headb/playdate_sdk-1.12.3/CoreLibs" ];
    "Lua.workspace.preloadFileSize" = 1000;
    "github.copilot.enable" = {
      "*" = true;
      "yaml" = false;
      "plaintext" = true;
      "markdown" = true;
    };
  };
  mutableExtensionsDir = true;
  # https://marketplace.visualstudio.com/vscode
  extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.266.1";
      sha256="D0nwLKGojvvRuviGRI9zo4SZmpZgee7ZpHLWjUK3LWA=";
    }
    {
      name = "cmake-tools";
      publisher = "ms-vscode";
      version = "1.12.27";
      sha256 = "Q5QpVusHt0qgWwbn7Xrgk8hGh/plTx/Z4XwxISnm72s=";
    }
    {
      name="cmake";
      publisher="twxs";
      version  ="0.0.17";
      sha256="CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
    }
    {
      name = "cpptools";
      publisher = "ms-vscode";
      version = "1.13.8";
      sha256 = "Cfi96o7/6smiPnXSlUfg8fI6H+2k1MVaZnjIWqRe9Uk=";
    }
    {
      name = "copilot";
      publisher = "GitHub";
      version = "1.57.7193";
      sha256 = "DdR5RqkJWlJvAhY7Rs51GDo+blBAMYmzGaoplHn3vso=";
    }
    {
      name = "copilot-labs";
      publisher = "GitHub";
      version = "0.4.488";
      sha256 = "Vy7T8PfU/4vAgHtFb++mJCfQYVijIL183XgfOJRB0ck=";
    }
    {
      name = "shades-of-purple";
      publisher = "ahmadawais";
      version = "7.1.5";
      sha256 = "FdMCmSMB3HOrqBt111kCrqFLT0VnymEfmWiuSR/buvc=";
    }
    {
      name = "material-icon-theme";
      publisher = "PKief";
      version = "4.21.0";
      sha256 = "EwJ4zGDdEak9fBAnn5pfuAU/+ONYWzl7Q6OMyc6mcZU=";
    }
    {
      name = "material-product-icons";
      publisher = "PKief";
      version = "1.4.1";
      sha256 = "CXhnfrIMmqTXXoxtJ5VgDdZxcs7ERuGUrNHXjMQMweE=";
    }
    {
      name = "Go";
      publisher = "golang";
      version = "0.35.2";
      sha256 = "YQPKB6dtIwmghw1VnYu+9krVICV2gm7Vq1FRq7lJbto=";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "2022.11.405";
      sha256 = "01cN6PqE4g/jOWXUuWScS5qZzMmFN/70SPAVLHHsejQ=";
    }
  ];
};
}
