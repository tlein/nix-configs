{ fetchFromGitHub
, vimUtils
}:
vimUtils.buildVimPlugin {
  pname = "commander.nvim";
  version = "v0.2.0";
  src = fetchFromGitHub {
    owner = "FeiyouG";
    repo = "commander.nvim";
    rev = "20fd55b43179258c434d11fa9af607f7d92b3371";
    sha256 = "sha256-yXZlm7/9f8VCdVGoAnqHLJBv9+76S0UoyzO8I9BIOws=";
  };
  meta.homepage = "https://github.com/FeiyouG/commander.nvim";
}
