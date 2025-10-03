{
  description = ''
    For questions just DM me on X: https://twitter.com/@m3tam3re
    There is also some NIXOS content on my YT channel: https://www.youtube.com/@m3tam3re

    One of the best ways to learn NIXOS is to read other peoples configurations. I have personally learned a lot from Gabriel Fontes configs:
    https://github.com/Misterio77/nix-starter-configs
    https://github.com/Misterio77/nix-config

    Please also check out the starter configs mentioned above.
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-45570c2.url = "github:nixos/nixpkgs/45570c299dc2b63c8c574c4cd77f0b92f7e2766e";
    nixpkgs-locked.url = "github:nixos/nixpkgs/2744d988fa116fc6d46cdfa3d1c936d0abd7d121";
    nixpkgs-9e58ed7.url = "github:nixos/nixpkgs/9e58ed7ba759d81c98f033b7f5eba21ca68f53b0";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nix-pia-vpn.url = "github:rcambrj/nix-pia-vpn";
    nix-pia-vpn.inputs.nixpkgs.follows = "nixpkgs";

    nixarr.url = "github:rasmus-kirk/nixarr";
    nixarr.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = {
    self,
    agenix,
    home-manager,
    nixpkgs,
    nixpkgs-stable, 
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = let
      # Import the regular packages for all systems
      regularPkgs = forAllSystems (
        system:
          import ./pkgs nixpkgs.legacyPackages.${system}
      );
    in
      regularPkgs
      // {
        x86_64-linux =
          regularPkgs.x86_64-linux
          // {
            # Build a QEMU image compatible with Proxmox using nixos-generators
          };
      };
    overlays = import ./overlays {inherit inputs outputs;};

    nixosConfigurations = {
      myzima1 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          hostname = "myzima1";
        };
        modules = [
          ./hosts/myzima1
          inputs.agenix.nixosModules.default
          inputs.disko.nixosModules.disko
          inputs.nixarr.nixosModules.default
          #TODO inputs.nix-pia-vpn.nixosModules.default {
          #TODO   services.pia-vpn = {
          #TODO     enable = true;
          #TODO     certificateFile = inputs.agenix.nixosModules.default.age.secrets.pia-ca-cert.path;
          #TODO     environmentFile = inputs.agenix.nixosModules.default.age.secrets.pia-user-pass.path; # use sops-nix or agenix
          #TODO   };
          #TODO }
        ];
      };
    };
    homeConfigurations = {
      "awhawks@myzima1" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {
          inherit inputs outputs;
          hostname = "myzima1";
        };
        modules = [ ./home/awhawks/myzima1.nix ];
      };
    };
    devShells.x86_64-linux.infraShell = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.mkShell {
        buildInputs = with pkgs; [
          nixos-anywhere
        ];
        shellHook = ''
          echo "Infrastructure Management Shell (awh not installed)"
          echo "Commands:"
          echo "  - cd infra/proxmox && tofu init"
          echo "  - tofu plan"
          echo "  - tofu apply"
        '';
      };

    deploy.nodes = {
      myzima1 = {
        hostname = "myzima1a";
        profiles = {
          system = {
            # This is the user that deploy-rs will use when connecting.
            # This will default to your own username if not specified anywhere
            sshUser = "awhawks";

            # This is the user that the profile will be deployed to (will use sudo if not the same as above).
            # If `sshUser` is specified, this will be the default (though it will _not_ default to your own username)
            user = "root";

            # Which sudo command to use. Must accept at least two arguments:
            # the user name to execute commands as and the rest is the command to execute
            # This will default to "sudo -u" if not specified anywhere.
            sudo = "sudo -u";

            # Whether to enable interactive sudo (password based sudo). Useful when using non-root sshUsers.
            # This defaults to `false`
            interactiveSudo = false;

            # This is an optional list of arguments that will be passed to SSH.
            sshOpts = [ "-p" "22" ];

            # Fast connection to the node. If this is true, copy the whole closure instead of letting the node substitute.
            # This defaults to `false`
            fastConnection = false;

            # If the previous profile should be re-activated if activation fails.
            # This defaults to `true`
            autoRollback = true;

            # See the earlier section about Magic Rollback for more information.
            # This defaults to `true`
            magicRollback = true;

            # The path which deploy-rs will use for temporary files, this is currently only used by `magicRollback` to create an inotify watcher in for confirmations
            # If not specified, this will default to `/tmp`
            # (if `magicRollback` is in use, this _must_ be writable by `user`)
            tempPath = "/tmp";

            # Build the derivation on the target system.
            # Will also fetch all external dependencies from the target system's substituters.
            # This default to `false`
            remoteBuild = false;

            # Timeout for profile activation.
            # This defaults to 240 seconds.
            activationTimeout = 240;

            # Timeout for profile activation confirmation.
            # This defaults to 30 seconds.
            confirmTimeout = 30;
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
                   self.nixosConfigurations.myzima1;
          };
        };
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
