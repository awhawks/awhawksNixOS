#!/bin/bash

scriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function cloneit() {
	repoDir=$1
	mkdir -p ${scriptDir}/github
	cd ${scriptDir}/github
	if [ -d ${repoDir}/.git ]
	then
	 cd ${scriptDir}/github/${repoDir} || exit 13
	 git fetch --all --prune
	 git pull
	else
	 mkdir -p ${scriptDir}/github/${repoDir} 
	 cd       ${scriptDir}/github/${repoDir} || exit 13
	 git clone http://github.com/${repoDir} . 
	fi
}

cloneit NixOS/nix
cloneit NixOS/nixfmt
cloneit NixOS/nixpkgs
cloneit NixOS/nix-idea
cloneit NixOS/nix-pills
cloneit NixOS/nixos-hardware
cloneit NixOS/nixos-search
cloneit NixOS/rfcs
cloneit nix-community/nixpkgs-wayland
cloneit nix-community/nix-vscode-extensions
cloneit nix-community/home-manager
cloneit nix-community/disko
cloneit nix-community/nixos-images
cloneit nix-community/awesome-nix
cloneit nix-community/nix-direnv
cloneit nix-community/nixvim
cloneit nix-community/nixos-generators
cloneit nix-community/plasma-manager
cloneit nix-community/NixNG
cloneit nix-community/NixOS-WSL
cloneit numtide/nixos-facter
cloneit librephoenix/nixos-config
cloneit vimjoyer/nixconf
