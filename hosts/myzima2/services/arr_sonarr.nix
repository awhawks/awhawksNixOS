{
  config,
  lib,
  pkgs,
  ...
}: {
    services.sonarr = {
        # The directory where Sonarr stores its data files.
        dataDir = "/data/config/sonarr2";
        # Whether to enable sonarr, a UsetNet/BitTorrent movie downloader.
        enable = true;
        # Environment file to pass secret configuration values.
        # Each line must follow the SONARR__SECTION__KEY=value pattern.
        # Please consult the documentation at the wiki.
        environmentFiles = [];
        # Group under which Sonaar runs.
        group = "awhawks";
        # Open ports in the firewall for the Sonarr web interface
        openFirewall = true;
        # The sonarr package to use.
        package = pkgs.sonarr;
        # Attribute set of arbitrary config options.
        # Please consult the documentation at the wiki.
        # WARNING: this configuration is stored in the world-readable Nix store!
        # For secrets use services.sonarr.environmentFiles.
        settings = {
            # Send Anonymous Usage Data
            log.analyticsEnabled = false;
            # Port Number
            server.port = 8989;
            update = {
                # Automatically download and install updates.
                automatically = false;
                # which update mechanism to use
                mechanism = "external";
            };
        };
        # User account under which sonarr runs.
        user = "awhawks";
    };
}
