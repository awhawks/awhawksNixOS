{
  config,
  lib,
  pkgs,
  ...
}: {
    services.radarr = {
        # The directory where Radarr stores its data files.
        dataDir = "/data/config/radarr2";
        # Whether to enable Radarr, a UsetNet/BitTorrent movie downloader.
        enable = true;
        # Environment file to pass secret configuration values.
        # Each line must follow the RADARR__SECTION__KEY=value pattern.
        # Please consult the documentation at the wiki.
        environmentFiles = [];
        # Group under which Radarr runs.
        group = "awhawks";
        # Open ports in the firewall for the Radarr web interface.
        openFirewall = true;
        # The radarr package to use.
        package = pkgs.radarr;
        # Attribute set of arbitrary config options. Please consult the documentation at the wiki.
        # WARNING: this configuration is stored in the world-readable Nix store!
        # For secrets use services.radarr.environmentFiles.
        settings = {
            # Send Anonymous Usage Data
            log.analyticsEnabled = false;
            # Port Number
            server.port = 7878;
            update = {
                # Automatically download and install updates.
                automatically = false;
                # which update mechanism to use
                mechanism = "external";
            };
        };
        # User account under which Radarr runs.
        user = "awhawks";
    };
}
