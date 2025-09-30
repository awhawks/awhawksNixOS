with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) {});
mkShell {
  buildInputs = [
    age
    agenix-cli
    #bcompare
    nixos-rebuild
    rage
    ragenix
    sops
    ssh-to-age
  ];
}