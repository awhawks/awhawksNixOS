{
  config,
  lib,
  pkgs,
  ...
}: {
    services.seerr = {
        # Config data directory
        configDir = "/data/config/jellyseerr2";
        # Whether to enable Jellyseerr, a requests manager for Jellyfin.
        enable = false;
        # Open port in the firewall for the Jellyseerr web interface.
        openFirewall = true;
        # The jellyseerr package to use.
        package = pkgs.jellyseerr;
        # The port which the Jellyseerr web UI should listen to.
        port = 5055;
    };
}
