{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.extraServices.podman;
in {
  options.extraServices.podman.enable = mkEnableOption "enable podman";

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket = {
	        enable = true;
	      };
        autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [
            "--filter=until=24h"
            "--filter=label!=important"
          ];
        };
        defaultNetwork.settings = {
	        dns_enabled = true;
	      };
      };
    };
    environment.systemPackages = with pkgs; [
      dive
      podman-compose
      podman-tui
      #passt
      #slirp4netns
    ];
    # Firewall configuration for reaparr which is a container
    networking.firewall = {
      allowPing = true;
      allowedTCPPorts = [ 7000 ];
    };
  };
}
