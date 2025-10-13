{
  config,
  lib,
  pkgs,
  ...
}: {
    services.audiobookshelf = {
        # Whether to enable Audiobookshelf, self-hosted audiobook and podcast server.
        enable = false;
        # Path to Audiobookshelf config and metadata inside of /var/lib.
        # dataDir = "audiobookshelf";
        dataDir = "/data/.state/nixarr/audiobookshelf";
        # Group under which Audiobookshelf runs.
        group = "audiobookshelf";
        # The host Audiobookshelf binds to.
        host = "127.0.0.1";
        # Open ports in the firewall for the Audiobookshelf web interface.
        openFirewall = false;
        # The audiobookshelf package to use.
        package = pkgs.audiobookshelf;
        # The TCP port Audiobookshelf will listen on.
        port = 8000;
        # User account under which Audiobookshelf runs.
        user = "audiobookshelf";
    };
}
