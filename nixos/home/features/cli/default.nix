{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./secrets.nix
  ];

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable =
      true;
  };

  home.packages = with pkgs; [
    agenix-cli
    coreutils
    devenv
    htop
    jq
    nix-index
    unzip
    wireguard-tools
    zip
  ];
}
