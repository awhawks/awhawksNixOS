#!/usr/bin/env bash

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

nix run github:serokell/deploy-rs -- .#myzima1
