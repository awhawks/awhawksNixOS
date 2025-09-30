#!/usr/bin/env bash

srcDir="secrets/myzima1/decrypted"
dstDir="secrets/myzima1"

function sopsEncryptFile() {
  mkdir -p ${dstDir}
  nix-shell -p age -p sops --run "sops -e '${srcDir}/${1}' > '${dstDir}/${1}'"
}

sopsEncryptFile PIA-Switzerland-1759188478.conf
sopsEncryptFile secrets.yaml
