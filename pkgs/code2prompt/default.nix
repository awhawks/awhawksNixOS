{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "code2prompt";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "mufeedvh";
    repo = "code2prompt";
    rev = "v${version}";
    hash = "sha256-9YbsrbExRFbsEz2GifklmUGp3YlsEUOi25+P5vPK8fs=";
  };

  cargoLock = {
    lockFile = src + "/Cargo.lock";
  };

  buildAndTestSubdir = "crates/code2prompt";

  nativeBuildInputs = [pkg-config perl];

  buildInputs = [openssl];

  meta = {
    description = "A CLI tool that converts your codebase into a single LLM prompt with a source tree, prompt templating, and token counting";
    homepage = "https://github.com/mufeedvh/code2prompt";
    license = lib.licenses.mit;
    mainProgram = "code2prompt";
  };
}
