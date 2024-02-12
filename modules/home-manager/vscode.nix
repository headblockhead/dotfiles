{ pkgs, ... }: {
  home.packages = with pkgs; [
    vscode
    omnisharp-roslyn
    dotnet-sdk
    mono
  ];
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "cpptools";
        publisher = "ms-vscode";
        version = "1.15.4";
        sha256 = "+EfEeta+qAnX/xmcGP0sa6U0+VhToiqdHEXQDENxyGA=";
      }
      {
        name = "vscode-eslint";
        publisher = "dbaeumer";
        version = "2.4.0";
        sha256 = "7MUQJkLPOF3oO0kpmfP3bWbS3aT7J0RF7f74LW55BQs=";
      }
      {
        name = "vscode-mdx";
        publisher = "unifiedjs";
        version = "1.3.0";
        sha256 = "TfqSU9V5vG7GwxEihUdEGC19VFHEUjlrTg+XXHdOYn4=";
      }
      {
        name = "cpptools-themes";
        publisher = "ms-vscode";
        version = "2.0.0";
        sha256 = "YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
      }
      {
        name = "shades-of-purple";
        publisher = "ahmadawais";
        version = "7.1.5";
        sha256 = "FdMCmSMB3HOrqBt111kCrqFLT0VnymEfmWiuSR/buvc=";
      }
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
        name = "copilot";
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
      "editor.cursorSmoothCaretAnimation" = "on";
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
      "workbench.colorTheme" = "Shades of Purple (Super Dark)";
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
      "omnisharp.useModernNet" = false;
      "omnisharp.useGlobalMono" = "always";
      "extensions.autoUpdate" = false;
    };
  };
}
