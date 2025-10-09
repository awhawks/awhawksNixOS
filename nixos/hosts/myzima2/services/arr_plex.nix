{
  config,
  lib,
  pkgs,
  ...
}: {
    services.plex = {
        # A list of device paths to hardware acceleration devices that Plex should have access to.
        # This is useful when transcoding media files.
        # The special value "*" will allow all devices.
        accelerationDevices = [
                                "/dev/dri/renderD128"
                              ];
        # The directory where Plex stores its data files.
        dataDir = "/var/lib/plex";
        # Whether to enable Plex Media Server.
        enable = false;
        # A list of paths to extra plugin bundles to install in Plex’s plugin directory.
        # Every time the systemd unit for Plex starts up,
        # all of the symlinks in Plex’s plugin directory will be cleared
        # and this module will symlink all of the paths specified here to that directory.
        extraPlugins = [];
        # A list of paths to extra scanners to install in Plex’s scanners directory.
        # Every time the systemd unit for Plex starts up,
        # all of the symlinks in Plex’s scanners directory will be cleared
        # and this module will symlink all of the paths specified here to that directory.
        extraScanners = [];
        # Group under which Plex runs.
        group = "plex";
        # Open ports in the firewall for the media server.
        openFirewall = false;
        # The plex package to use.
        # Plex subscribers may wish to use their own package here, pointing to subscriber-only server versions.
        package = pkgs.plex;
        # User account under which Plex runs.
        user = "plex";
    };
}
