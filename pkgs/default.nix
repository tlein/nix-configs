final: prev:
{
  # Adding packages here, makes them accessible from "pkgs"
  vimPlugins = prev.vimPlugins // {
    commander-nvim = prev.callPackage ./commander-nvim { };
  };
}
