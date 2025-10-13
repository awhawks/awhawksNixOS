{
  config,
  lib,
  pkgs,
  ...
}: {
    services.jellyseerr = {
        # Config data directory
        configDir = "/var/lib/jellyseerr/config";
        # Whether to enable Jellyseerr, a requests manager for Jellyfin.
        enable = false;
        # Open port in the firewall for the Jellyseerr web interface.
        openFirewall = false;
        # The jellyseerr package to use.
        package = pkgs.jellyseerr;
        # The port which the Jellyseerr web UI should listen to.
        port = 5055;
    };
}
