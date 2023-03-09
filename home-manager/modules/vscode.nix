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
    "Lua.workspace.preloadFileSize" = 1000;
    "github.copilot.enable" = {
      "*" = true;
      "yaml" = false;
      "plaintext" = true;
      "markdown" = true;
    };
  };
};
}
