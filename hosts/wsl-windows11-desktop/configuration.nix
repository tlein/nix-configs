{ config, pkgs, ... }: {

  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  wsl = {
    enable = true;
    defaultUser = "nixos";
    startMenuLaunchers = true;
    nativeSystemd = true;
  };

  system.stateVersion = "24.05";
}
