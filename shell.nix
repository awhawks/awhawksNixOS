with (import (fetchTarball https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz) {});
mkShell {
  buildInputs = [
    age
    agenix-cli
    #bcompare
    deploy-rs
    nixos-rebuild
    rage
    ragenix
    sops
    ssh-to-age
  ];
}