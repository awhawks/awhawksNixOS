{prev}:
prev.n8n.overrideAttrs (oldAttrs: rec {
  version = "1.112.6";

  src = prev.fetchFromGitHub {
    owner = "n8n-io";
    repo = "n8n";
    rev = "n8n@${version}";
    hash = "";
  };

  pnpmDeps = prev.pnpm_10.fetchDeps {
    pname = oldAttrs.pname;
    inherit version src;
    fetcherVersion = 1;
    hash = "";
  };

  nativeBuildInputs =
    builtins.map
    (input:
      if input == prev.pnpm_9.configHook
      then prev.pnpm_10.configHook
      else input)
    oldAttrs.nativeBuildInputs;
})
