{ fetchFromGitHub
, vimUtils
}:
vimUtils.buildVimPlugin {
  pname = "krust.nvim";
  version = "v0.0.1";
  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "krust.nvim";
    rev = "899b65851d25d6eb250833709ab5b27c760171dd";
    sha256 = "sha256-aQIniMpOajX1FGV75LAs3CKe7VxoDB+Er1/C9T4t9fI=";
  };
}
