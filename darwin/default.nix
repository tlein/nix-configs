{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my-darwin;
in
{

  imports = [
    ./system-defaults
  ];

  options.my-darwin = {
    enableSudoTouch = lib.mkEnableOption "sudo touch id";

    theme = lib.mkOption {
      type = types.str;
      default = "nord";
      description = ''
        Theme to apply
      '';
    };
  };

  config = {
    nix = {
      enable = false;
    };

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh = {
      enable = true;
      # This fixes a bug between nix darwin and home-manager over completion conflicts
      # Completion is enabled in home-manager config
      enableCompletion = false;
      promptInit = "";
    };

    security.pam.services.sudo_local.touchIdAuth = cfg.enableSudoTouch;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;
  };

}
