{
  config,
  lib,
  pkgs,
  ...
}: {
    # look here for discussion https://discourse.nixos.org/t/nixos-21-11-plex-plexpass/17011/3
    services.plex = let plexpass = pkgs.plex.override {
      plexRaw = pkgs.plexRaw.overrideAttrs(old: rec {
        #plexmediaserver_1.43.3.10896-cb3ebc72d_amd64.deb
        version = "1.43.3.10896-cb3ebc72d";
        src = pkgs.fetchurl {
          url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
          sha256 = "sha256-qgnyZt3PQI4Qz3ulYbbkVObhCbqUFjlraWW9THnzcUk=";
        };
      });
    };
    in {
        # A list of device paths to hardware acceleration devices that Plex should have access to.
        # This is useful when transcoding media files.
        # The special value "*" will allow all devices.
        accelerationDevices = [
          "/dev/dri/renderD128"
          "/dev/dri/card1"
        ];
        # The directory where Plex stores its data files.
        dataDir = "/data/config/plex2";
        # Whether to enable Plex Media Server.
        enable = true;
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
        group = "awhawks";
        # Open ports in the firewall for the media server.
        openFirewall = true;
        # The plex package to use.
        # Plex subscribers may wish to use their own package here, pointing to subscriber-only server versions.
        package = plexpass;
        # User account under which Plex runs.
        user = "awhawks";
    };
}
