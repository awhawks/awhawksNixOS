{
  config,
  lib,
  pkgs,
  ...
}: {
    services.sabnzbd = {
        # Path to config file.
        configFile = "/var/lib/sabnzbd/sabnzbd.ini";
        # Whether to enable the sabnzbd server.
        enable = false;
        # Group to run the service as
        group = "sabnzbd";
        # Open ports in the firewall for the sabnzbd web interface
        openFirewall = false;
        # The sabnzbd package to use.
        package = pkgs.sabnzbd;
        # User to run the service as
        user = "sabnzbd";
    };
}
