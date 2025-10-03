{pkgs, ...}: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
  programs.bash.enable = true;
  programs.nh = {
    enable = false;
    clean.enable = false;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/awhawks/p/nixos/nixos-config";
  };
}
