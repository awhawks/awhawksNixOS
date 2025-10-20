{
  config,
  lib,
  pkgs,
  ...
}: {
    services.tautulli = {
        # The location of Tautulli’s config file.
        configFile = "/data/config/tautulli2/config.ini";
        # The directory where Tautulli stores its data files.
        dataDir = "/data/config/tautulli2";
        # Whether to enable tautulli Media Server.
        enable = true;
        # Group under which tautulli runs.
        group = "awhawks";
        # Open the default ports in the firewall for the media server. The HTTP/HTTPS ports can be changed in the Web UI, so this option should only be used if they are unchanged, see Port Bindings.
        openFirewall = true;
        # The tautulli package to use.
        package = pkgs.tautulli;
        # TCP port where Tautulli listens.
        port = 8181;
        # User account under which Tautulli runs.
        user = "awhawks";
    };
}
