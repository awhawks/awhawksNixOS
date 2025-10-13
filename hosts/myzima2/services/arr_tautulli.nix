{
  config,
  lib,
  pkgs,
  ...
}: {
    services.tautulli = {
        # The location of Tautulli’s config file.
        configFile = "/var/lib/plexpy/config.ini";
        # The directory where Tautulli stores its data files.
        dataDir = "/var/lib/plexpy";
        # Whether to enable tautulli Media Server.
        enable = false;
        # Group under which tautulli runs.
        group = "nogroup";
        # Open the default ports in the firewall for the media server. The HTTP/HTTPS ports can be changed in the Web UI, so this option should only be used if they are unchanged, see Port Bindings.
        openFirewall = false;
        # The tautulli package to use.
        package = pkgs.tautulli;
        # TCP port where Tautulli listens.
        port = 8181;
        # User account under which Tautulli runs.
        user = "plexpy";
    };
}
