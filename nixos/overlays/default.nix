{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: prev:
    (import ../pkgs {pkgs = final;})
    # // (inputs.hyprpanel.overlay final prev)
    // {rose-pine-hyprcursor = inputs.rose-pine-hyprcursor.packages.${prev.system}.default;}
    // {
      crush = inputs.nix-ai-tools.packages.${prev.system}.crush;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # nodejs_24 = inputs.nixpkgs-stable.legacyPackages.${prev.system}.nodejs_24;
    # paperless-ngx = inputs.nixpkgs-45570c2.legacyPackages.${prev.system}.paperless-ngx;
    # anytype-heart = inputs.nixpkgs-9e58ed7.legacyPackages.${prev.system}.anytype-heart;
    # trezord = inputs.nixpkgs-2744d98.legacyPackages.${prev.system}.trezord;
    # mesa = inputs.nixpkgs-master.legacyPackages.${prev.system}.mesa;
    # hyprpanel = inputs.hyprpanel.packages.${prev.system}.default.overrideAttrs (prev: {
    #   version = "latest"; # or whatever version you want
    #   src = final.fetchFromGitHub {
    #     owner = "Jas-SinghFSU";
    #     repo = "HyprPanel";
    #     rev = "master"; # or a specific commit hash
    #     hash = "sha256-l623fIVhVCU/ylbBmohAtQNbK0YrWlEny0sC/vBJ+dU=";
    #   };
    # });
  };

  temp-packages = final: _prev: {
    temp = import inputs.nixpkgs-9e9486b {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  pinned-packages = final: _prev: {
    pinned = import inputs.nixpkgs-9472de4 {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  locked-packages = final: _prev: {
    locked = import inputs.nixpkgs-locked {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
