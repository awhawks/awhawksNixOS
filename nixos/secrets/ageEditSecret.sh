#!/usr/bin/env bash
#set -x
set -e
set -u
set -o errexit

scriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd ${scriptDir} || exit 13

if ! command -v nix >/dev/null 2>&1
then
    echo "nix could not be found"
    exit 1
fi

if [ $# -ne 1 ]
then
  echo "you must provide an age file"
  exit 13
fi

nix run github:ryantm/agenix -- -e $1
