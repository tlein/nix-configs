{ ... }:
{
  programs = {

    git = {

      enable = true;

      signing.format = "openpgp";

      settings.user = {
        name = "Tucker Lein";
        email = "self@tuckerle.in";
      };

      ignores = [
        # macOS
        ".DS_Store"
        "._*"
        ".Spotlight-V100"
        ".Trashes"

        # Windows
        "Thumbs.db"
        "Desktop.ini"
      ];
    };
  };

}
