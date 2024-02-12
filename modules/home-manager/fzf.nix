{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetOptions = # CTRL-T
      [ "--preview 'bat --style=numbers --color=always {}'" ];
    historyWidgetOptions = # CTRL-R
      [ ''--preview 'echo {} | sed \"s/  */ /g\" | cut -d\\  -f1 | xargs -I % sh -c \"echo %; git show --color=always %\"' '' ];
    changeDirWidgetOptions = # ALT-C
      [ "" ];
  };
}
