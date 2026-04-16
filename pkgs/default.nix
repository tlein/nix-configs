final: prev:
{
  # Adding packages here, makes them accessible from "pkgs"
  vimPlugins = prev.vimPlugins // {
    auto-dark-mode-nvim = prev.callPackage ./auto-dark-mode-nvim { };
    krust-nvim = prev.callPackage ./krust-nvim { };
  };
}
