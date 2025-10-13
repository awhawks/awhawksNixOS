{
  config,
  lib,
  pkgs,
  ...
}: {
    services.transmission = {
        # Path to a JSON file to be merged with the settings.
        # Useful to merge a file which is better kept out of the Nix store to set secret config parameters like rpc-password.
        credentialsFile = "/dev/null";
        # If not null, is used as the permissions set by system.activationScripts.transmission-daemon
        # on the directories services.transmission.settings.download-dir,
        # services.transmission.settings.incomplete-dir. and services.transmission.settings.watch-dir.
        # Note that you may also want to change services.transmission.settings.umask.
        #
        # Keep in mind, that if the default user is used, the home directory is locked behind a 750 permission,
        # which affects all subdirectories as well. There are 3 ways to get around this:
        #
        # (Recommended) add the users that should have access to the group set by services.transmission.group
        # Change services.transmission.settings.download-dir to be under a directory that has the right permissions
        # Change systemd.services.transmission.serviceConfig.StateDirectoryMode to the same value as this option
        downloadDirPermissions = null;
        # Whether to enable the headless Transmission BitTorrent daemon.
        # Transmission daemon can be controlled via the RPC interface using transmission-remote,
        # the WebUI (http://127.0.0.1:9091/ by default), or other clients like stig or tremc.
        # Torrents are downloaded to services.transmission.home/Downloads by default
        # and are accessible to users in the “transmission” group.
        enable = false;
        # Extra flags passed to the transmission command in the service definition.
        extraFlags = [];
        # Group account under which Transmission runs.
        group = "transmission";
        # The directory where Transmission will create .config/transmission-daemon.
        # as well as Downloads/ unless services.transmission.settings.download-dir is changed,
        # and .incomplete/ unless services.transmission.settings.incomplete-dir is changed.
        home = "/var/lib/transmission";
        # Alias of services.transmission.openPeerPorts.
        openFirewall = false;
        # Whether to enable opening of the peer port(s) in the firewall.
        openPeerPorts = false;
        # Whether to enable opening of the RPC port in the firewall.
        openRPCPort = false;
        # The transmission package to use.
        package = pkgs.transmission_4 ;
        # Whether to enable tweaking of kernel parameters to open many more connections at the same time.
        # Note that you may also want to increase peer-limit-global.
        # And be aware that these settings are quite aggressive and might not suite your regular desktop use.
        # For instance, SSH sessions may time out more easily.
        performanceNetParameters = false;
        # Settings whose options overwrite fields in .config/transmission-daemon/settings.json (each time the service starts).
        # See Transmission’s Wiki for documentation of settings not explicitly covered by this module.
        settings = {
            # Directory where to download torrents.
            download-dir = "${config.services.transmission.home}/Downloads";
            # When enabled with services.transmission.home services.transmission.settings.incomplete-dir-enabled,
            # new torrents will download the files to this directory.
            # When complete, the files will be moved to download-dir services.transmission.settings.download-dir.
            incomplete-dir = "${config.services.transmission.home}/.incomplete";
            #
            incomplete-dir-enabled = true;
            # Set verbosity of transmission messages. 0-6
            message-level = 2;
            # The peer port to listen for incoming connections.
            peer-port = 51413;
            # The maximum peer port to listen to for incoming connections when services.transmission.settings.peer-port-random-on-start is enabled.
            peer-port-random-high = 65535;
            # The minimal peer port to listen to for incoming connections when services.transmission.settings.peer-port-random-on-start is enabled.
            peer-port-random-low = 65535;
            # Randomize the peer port.
            peer-port-random-on-start = false;
            # Where to listen for RPC connections. Use 0.0.0.0 to listen on all interfaces.
            rpc-bind-address = "127.0.0.1";
            # The RPC port to listen to.
            rpc-port = 9091;
            # Whether to run services.transmission.settings.script-torrent-done-filename at torrent completion.
            script-torrent-done-enabled = false;
            # Executable to be run at torrent completion.
            script-torrent-done-filename = null;
            # Whether to delete torrents added from the services.transmission.settings.watch-dir.
            trash-original-torrent-files = false;
            # Sets transmission’s file mode creation mask. See the umask(2) manpage for more information. Users who want their saved torrents to be world-writable may want to set this value to 0/"000".
            # Keep in mind, that if you are using Transmission 3, this has to be passed as a base 10 integer,
            # whereas Transmission 4 takes an octal number in a string instead.
            umask = if config.package == pkgs.transmission_3 then 18 else "022";
            # Whether to enable Micro Transport Protocol (µTP).
            utp-enabled = true;
            # Watch a directory for torrent files and add them to transmission.
            watch-dir = "${config.services.transmission.home}/watchdir";
            # Whether to enable the services.transmission.settings.watch-dir.
            watch-dir-enabled = false;
        };
        # User account under which Transmission runs.
        user = "transmission";
        # If not null, sets the value of the TRANSMISSION_WEB_HOME environment variable used by the service.
        # Useful for overriding the web interface files, without overriding the transmission package and thus requiring rebuilding it locally.
        # Use this if you want to use an alternative web interface, such as pkgs.flood-for-transmission.
        webHome = null;
    };
}
