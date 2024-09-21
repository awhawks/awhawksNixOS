{
    # Executed by `nix build .#<name>`
    # Executed by `nix run .#<name>`
    # used by `nix develop .#<name>`
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, disko, ... }: {
        nixosConfiguration.p50 = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                disko.nixosModules.disko # use disko module
                ./configuration.nix # regular nixos config
                ./disk-config.nix
            ];
        };
    };
}
