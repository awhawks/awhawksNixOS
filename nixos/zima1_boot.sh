#!/usr/bin/env bash
#!/run/current-system/sw/bin/env bash

#set -x
set -e
set -o errexit

scriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd ${scriptDir} || exit 13

nix flake check --all-systems
nix-shell -p nixos-rebuild --command "nixos-rebuild boot --flake .#myzima1 --target-host myzima1a --use-remote-sudo"
