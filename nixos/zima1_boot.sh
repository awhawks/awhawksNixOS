#!/usr/bin/env bash
#!/run/current-system/sw/bin/env bash

#set -x
set -e
set -o errexit

scriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd ${scriptDir} || exit 13

if ! command -v nix >/dev/null 2>&1
then
    echo "nix could not be found"
    exit 1
fi

if ! command -v nixos-rebuild >/dev/null 2>&1
then
    echo "nixos-rebuild could not be found"
    exit 1
fi

nix flake check --all-systems --show-trace
nixos-rebuild boot --flake .#myzima1 --target-host myzima1a --use-remote-sudo
