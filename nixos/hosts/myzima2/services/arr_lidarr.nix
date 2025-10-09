{
  config,
  lib,
  pkgs,
  ...
}: {
    services.lidarr = {
        # The directory where Lidarr stores its data files.
        dataDir = "/var/lib/lidarr/.config/Lidarr";
        # Whether to enable Lidarr, a Usenet/BitTorrent music downloader.
        enable = false;
        # Environment file to pass secret configuration values. Each line must follow the LIDARR__SECTION__KEY=value pattern.
        # Please consult the documentation at the wiki.
        environmentFiles = [];
        # Group under which Lidarr runs.
        group = "lidarr";
        # Open ports in the firewall for Lidarr
        openFirewall = false;
        # The lidarr package to use.
        package = pkgs.lidarr;
        # Attribute set of arbitrary config options. Please consult the documentation at the wiki.
        # WARNING: this configuration is stored in the world-readable Nix store! For secrets use services.lidarr.environmentFiles.
        settings = {
            # Send Anonymous Usage Data
            log.analyticsEnabled = false;
            # Port Number
            server.port = 8686;
            update = {
                # Automatically download and install updates.
                automatically = false;
                # which update mechanism to use
                mechanism = "external";
            };
            # User account under which Lidarr runs.
            user = "lidarr";
        };
    };
}
