{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my-home;
in
{

  imports = [
    ./zsh
    ./git
    ./nvim
    ./direnv
  ];

  options.my-home = {
    includeFonts = lib.mkEnableOption "fonts";
  };

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home = {
      sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
        PAGER = "less";
      };

      packages = with pkgs; [
        # command line utilities
        ack
        curl
        wget
        ngrep
        ffmpeg

        # Zettelkasten cli tool
        zk

        # Lua external formatter
        stylua
      ] ++ optionals cfg.includeFonts [
        # Fonts
        nerdfonts
      ];
    };

    fonts.fontconfig.enable = cfg.includeFonts;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "23.11";
  };

}
