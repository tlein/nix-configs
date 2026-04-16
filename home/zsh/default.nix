{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
    dotDir = "/Users/tucker/.config/zsh";

    historySubstringSearch.enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };

    initContent = ''
      eval "$(direnv hook zsh)"
      [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}

      ## Squatbot
      export SQUATBOT_HOME=$HOME/Code/ILikeDucks/squatbot

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "history-substring-search";
        src = pkgs.zsh-history-substring-search;
      }
    ];
  };
}
