{ pkgs, ... }: {
  home.packages = with pkgs; [
    pkgs.vscode
    pkgs.omnisharp-roslyn
    pkgs.dotnet-sdk
    pkgs.mono
  ];
programs.vscode = {
  enable = true;
  mutableExtensionsDir = true;
  extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace  [
      {
        name = "cpptools";
        publisher = "ms-vscode";
        version = "1.15.4";
        sha256 = "ldgbAaJ4sVFMEXuhXbMBwSvpsym4XOQ0//JGeOVHpyY=";
      }
      {
        name = "cpptools-themes";
        publisher = "ms-vscode";
        version = "2.0.0";
        sha256 = "YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
      }
      # Needs to be installed manually :(
#      {
#        name = "csharp";
#        publisher = "ms-dotnettools";
#        version = "1.23.12";
#        sha256 = "n6Auvo3KC2c/17ODF+Ey9rd8bGzypSvxsB724lIa5sg=";
#      }
      {
        name = "cmake";
        publisher = "twxs";
        version = "0.0.17";
        sha256 = "CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
      }
      {
        name = "cmake-tools";
        publisher = "ms-vscode";
        version = "1.14.31";
        sha256 = "crxs6ojsw8Q5E+s4bmxqfZEjmwyP121GFCbww7IP7tE=";
      }
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.292.0";
        sha256 = "U1ZuxfoUBWdnOy+t4Zp7B5jyvGt89xsufrqnX09gm4U=";
      }
      {
        name= "copilot";
        publisher = "GitHub";
        version = "1.86.82";
        sha256 = "isaqjrAmu/08gnNKQPeMV4Xc8u0Hx8gB2c78WE54kYQ=";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "13.6.0";
        sha256 = "bb8FTEKJLWHF976ORBgsE9U6EPyMWjFqsU0A+l0Cdec=";
      }
      {
        name = "go";
        publisher = "golang";
        version = "0.38.0";
        sha256 = "wOWouVz4mE4BzmgQOLQyVWsMadMqeUkFWHnruxStU0Q=";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "4.27.0";
        sha256 = "cu+d6pyXVil2+Ng/ze+DjiWRQiECz9ef+T6sWFav578=";
      }
      {
        name = "material-product-icons";
        publisher = "PKief";
        version = "1.5.0";
        sha256 = "gKU21OS2ZFyzCQVQ1fa3qlahLBAcJaHDEcz7xof3P4A=";
      }
  ];
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
    "Lua.workspace.preloadFileSize" = 1000;
    "github.copilot.enable" = {
      "*" = true;
      "yaml" = false;
      "plaintext" = true;
      "markdown" = true;
    };
    "omnisharp.useGlobalMono" ="always";
"extensions.autoUpdate" = false;
  };
};
}
