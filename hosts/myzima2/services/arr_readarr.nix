{
  config,
  lib,
  pkgs,
  ...
}: {
    services.readarr = {
        # The directory where readarr stores its data files.
        dataDir = "/var/lib/readarr/";
        # Whether to enable readarr, a UsetNet/BitTorrent movie downloader.
        enable = false;
        # Environment file to pass secret configuration values.
        # Each line must follow the readarr__SECTION__KEY=value pattern.
        # Please consult the documentation at the wiki.
        environmentFiles = [];
        # Group under which readarr runs.
        group = "readarr";
        # Open ports in the firewall for the readarr web interface.
        openFirewall = false;
        # The readarr package to use.
        package = pkgs.readarr;
        # Attribute set of arbitrary config options. Please consult the documentation at the wiki.
        # WARNING: this configuration is stored in the world-readable Nix store!
        # For secrets use services.readarr.environmentFiles.
        settings = {
            # Send Anonymous Usage Data
            log.analyticsEnabled = false;
            # Port Number
            server.port = 8787;
            update = {
                # Automatically download and install updates.
                automatically = false;
                # which update mechanism to use
                mechanism = "external";
            };
        };
        # User account under which readarr runs.
        user = "readarr";
    };
}
