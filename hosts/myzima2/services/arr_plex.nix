{
  config,
  lib,
  pkgs,
  ...
}: {
    services.plex = let plexpass = pkgs.plex.override {
      plexRaw = pkgs.plexRaw.overrideAttrs(old: rec {
        version = "1.42.2.10156-f737b826c";
        src = pkgs.fetchurl {
          url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
          sha256 = "sha256-1ieh7qc1UBTorqQTKUQgKzM96EtaKZZ8HYq9ILf+X3M=";
        };
      });
    };
    in {
        # Whether to enable Plex Media Server.
        enable = false;
        # Open ports in the firewall for the media server.
        openFirewall = false;
        # The plex package to use.
        # Plex subscribers may wish to use their own package here, pointing to subscriber-only server versions.
        package = plexpass;
        # User account under which Plex runs.
        user = "awhawks";
        # Group under which Plex runs.
        group = "users";
        # A list of device paths to hardware acceleration devices that Plex should have access to.
        # This is useful when transcoding media files.
        # The special value "*" will allow all devices.
        accelerationDevices = [
          "/dev/dri/renderD128"
          "/dev/dri/card1"
        ];
        # The directory where Plex stores its data files.
        dataDir = "/var/lib/plex";
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
    };
}
