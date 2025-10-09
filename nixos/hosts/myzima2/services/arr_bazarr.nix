{
  config,
  lib,
  pkgs,
  ...
}: {
    services.bazarr = {
        # Whether to enable bazarr, a subtitle manager for Sonarr and Radarr.
        enable = false;
        # Group under which bazarr runs.
        group = "bazarr";
        # Port on which the bazarr web interface should listen
        listenPort = 6767;
        # Open ports in the firewall for the bazarr web interface.
        openFirewall = false;
        # The bazarr package to use.
        package = pkgs.bazarr;
        # User account under which bazarr runs.
        user = "bazarr";
    };
}
