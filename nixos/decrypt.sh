#!/usr/bin/env bash

srcDir="secrets/myzima1"
dstDir="secrets/myzima1/decrypted"

function sopsDecryptFile() {
  mkdir -p ${dstDir}
  nix-shell -p age -p sops --run "sops -d '${srcDir}/${1}' > '${dstDir}/${1}'"
}

sopsDecryptFile PIA-Switzerland-1759188478.conf
sopsDecryptFile secrets.yaml
