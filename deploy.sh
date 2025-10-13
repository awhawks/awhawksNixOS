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

if [ $# -ne 2 ]
then
    echo "you must provide deployType [ anywhere | deploy ] and host [ myzima1 | myzima2 ]"
    exit 1
fi

deployType=$1
shift 1
host=$1
shift 1

case ${deployType} in
  anywhere)
    args=""
    args="${args} --generate-hardware-config nixos-generate-config ./hardware-configuration.nix"
    args="${args} --flake '.#${host}'"
    args="${args} --target-host root@${host}a"

    cmd="nix"
    cmd="${cmd} run"
    cmd="${cmd} github:nix-community/nixos-anywhere"
    cmd="${cmd} --"
    cmd="${cmd} ${args}"
    ;;
  deploy)
    args=".#${host}"

    cmd="nix"
    cmd="${cmd} run"
    cmd="${cmd} github:serokell/deploy-rs"
    cmd="${cmd} --"
    cmd="${cmd} ${args}"
    ;;
  boot)
    args="boot"
    args="${args} --flake"
    args="${args} .#${host}"
    args="${args} --target-host ${host}a"
    args="${args} --use-remote-sudo"

    cmd="nix run nixpkgs#nixos-rebuild -- ${args}"
    ;;
  switch)
    args="switch"
    args="${args} --flake"
    args="${args} .#${host}"
    args="${args} --target-host ${host}a"
    args="${args} --use-remote-sudo"

    cmd="nix run nixpkgs#nixos-rebuild -- ${args}"
    ;;
  check)
    args=""
    args="${args} --all-systems"
    args="${args} --show-trace"

    cmd="nix flake check ${args}"
    ;;
  rebuild)
    args="switch"
    args="${args} --flake"
    args="${args} .#${host}"

    cmd="sudo nixos-rebuild ${args}"
    ;;
  *)
    echo "unknown deployType [${deployType}]"
    exit 13
    ;;
esac

echo "cmd [${cmd}]"
${cmd}
