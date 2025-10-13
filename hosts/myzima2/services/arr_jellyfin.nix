{
  config,
  lib,
  pkgs,
  ...
}: {
    services.jellyfin = {
        # Directory containing the jellyfin server cache, passed with --cachedir see #cache-directory
        cacheDir = "/var/cache/jellyfin";
        # Directory containing the server configuration files, passed with --configdir see configuration-directory
        configDir = "\${cfg.dataDir}/config";
        # Base data directory, passed with --datadir see #data-directory
        dataDir = "/var/lib/jellyfin";
        # Whether to enable Jellyfin Media Server.
        enable = false;
        # Group under which jellyfin runs.
        group = "jellyfin";
        # Directory where the Jellyfin logs will be stored, passed with --logdir see #log-directory
        logDir = "\${cfg.dataDir}/log";
        # Open the default ports in the firewall for the media server. The HTTP/HTTPS ports can be changed in the Web UI, so this option should only be used if they are unchanged, see Port Bindings.
        openFirewall = false;
        # The jellyfin package to use.
        package = pkgs.jellyfin;
        # User account under which Jellyfin runs.
        user = "jellyfin";
    };
}
