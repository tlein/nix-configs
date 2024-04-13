{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
    dotDir = ".config/zsh";

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

    initExtra = ''
      eval "$(direnv hook zsh)"
      [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}

      ## Squatbot
      export SQUATBOT_HOME=$HOME/Code/ILikeDucks/squatbot
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
}
