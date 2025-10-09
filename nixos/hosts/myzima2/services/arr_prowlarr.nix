{
  config,
  lib,
  pkgs,
  ...
}: {
    services.prowlarr = {
        # Whether to enable Prowlarr, an indexer manager/proxy for Torrent trackers and Usenet indexers.
        enable = false;
        # Environment file to pass secret configuration values.
        # Each line must follow the PROWLARR__SECTION__KEY=value pattern.
        # Please consult the documentation at the wiki.
        environmentFiles = [];
        # Open ports in the firewall for the Prowlarr web interface.
        openFirewall = false;
        # The prowlarr package to use.
        package = pkgs.prowlarr;
        # Attribute set of arbitrary config options.
        # Please consult the documentation at the wiki.
        # WARNING: this configuration is stored in the world-readable Nix store!
        # For secrets use services.prowlarr.environmentFiles.
        settings = {
            # Send Anonymous Usage Data
            log.analyticsEnabled = false;
            # Port Number
            server.port = 9696;
            update = {
                # Automatically download and install updates.
                automatically = false;
                # which update mechanism to use
                mechanism = "external";
            };
        };
    };
}
