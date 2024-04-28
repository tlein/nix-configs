{ ... }:
{
  programs = {
    git = {
      enable = true;

      userName = "Tucker Lein";
      userEmail = "self@tuckerle.in";

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
