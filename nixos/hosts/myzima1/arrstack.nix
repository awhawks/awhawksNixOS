{ config, inputs, outputs, lib, pkgs, ... }:
{
  nixarr = {
    enable = false;
    audiobookshelf.enable    = false;
    autobrr.enable           = false;
    bazarr.enable            = false;
    ddns.njalla.enable       = false;
    jellyfin.enable          = false;
    jellyseerr.enable        = false;
    lidarr.enable            = false;
    plex.enable              = false;
    prowlarr.enable          = false;
    radarr.enable            = false;
    readarr.enable           = false;
    readarr-audiobook.enable = false;
    recyclarr.enable         = false;
    sabnzbd.enable           = false;
    sonarr.enable            = false;
    transmission.enable      = false;
    vpn.enable               = false;

    # option                                type            default                             description
    # nixarr.mediaDir                       abs path        "/data/media"                       The location of the media directory for the services.
    #                                                                                           Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
    #                                                                                               mediaDir = /home/user/nixarr
    #                                                                                           Is not supported, because /home/user is owned by user.
    # nixarr.mediaUsers                     list of string  [ ]                                 Extra users to add to the media group.
    # nixarr.openssh.expose.vpn.enable      boolean         false                               Run the openssh service through a vpn, exposing it to the internet.
    #                                                                                           Required options:
    #                                                                                             nixarr.vpn.enable
    #                                                                                           Warning: This lets anyone on the internet connect through SSH, make sure the SSH configuration is secure!
    #                                                                                                    Disallowing password authentication and only allowing SSH-keys is considered secure.
    #
    #                                                                                           Note: This option does not enable the SSHD service you still need to setup sshd in your nixos configuration, fx:
    #
    #                                                                                             services.openssh = {
    #                                                                                               enable = true;
    #                                                                                               settings.PasswordAuthentication = false;
    #                                                                                               # Get this port from your VPN provider
    #                                                                                               ports [ 12345 ];
    #                                                                                             };
    #
    #                                                                                             users.extraUsers.username.openssh.authorizedKeys.keyFiles = [
    #                                                                                               ./path/to/public/key/machine.pub
    #                                                                                             ];
    #                                                                                           Then replace username with your username and the keyFiles path to a ssh public key file from the machine that you want to have access.
    #                                                                                           Don’t use password authentication as it is insecure!
    # nixarr.stateDir                       abs path        "/data/.state/nixarr"               The location of the state directory for the services.
    #                                                                                           Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
    #
    #                                                                                             stateDir = /home/user/nixarr/.state
    #                                                                                           Is not supported, because /home/user is owned by user.

    audiobookshelf = {
      # option                                            type        default                             description
      # nixarr.audiobookshelf.enable                      boolean     false                               Whether or not to enable the Audiobookshelf service.
      #                                                                                                   Conflicting options: nixarr.plex.enable
      # nixarr.audiobookshelf.package                     package     pkgs.audiobookshelf                 The audiobookshelf package to use.
      # nixarr.audiobookshelf.expose.https.enable         boolean     false                               Expose the Audiobookshelf web service to the internet with https support, allowing anyone to access it.
      #                                                                                                   Required options:
      #                                                                                                       nixarr.audiobookshelf.expose.https.acmeMail
      #                                                                                                       nixarr.audiobookshelf.expose.https.domainName
      #                                                                                                   Conflicting options:
      #                                                                                                       nixarr.audiobookshelf.vpn.enable
      #                                                                                                   Warning: Do not enable this without setting up Audiobookshelf authentication through localhost first!
      # nixarr.audiobookshelf.expose.https.acmeMail       string/null null                                The ACME mail required for the letsencrypt bot.
      #                                                                                                   Example: "mail@example.com"
      # nixarr.audiobookshelf.expose.https.domainName     string/null null                                The domain name to host Audiobookshelf on.
      #                                                                                                   Example: "audiobookshelf.example.com"
      # nixarr.audiobookshelf.expose.https.upnp.enable    boolean     false                               Whether to enable UPNP to try to open ports 80 and 443 on your router…
      # nixarr.audiobookshelf.openFirewall                boolean     !nixarr.audiobookshelf.vpn.enable   Open firewall for Audiobookshelf
      # nixarr.audiobookshelf.port                        16b ushort  9292                                Default port for Audiobookshelf.
      #                                                                                                   The default is 8000 in nixpkgs, but that’s far too common a port to use.
      # nixarr.audiobookshelf.stateDir                    abs path    "${nixarr.stateDir}/audiobookshelf" The location of the state directory for the Audiobookshelf service.
      #                                                                                                   Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                                           stateDir = /home/user/nixarr/.state/audiobookshelf
      #                                                                                                   Is not supported, because /home/user is owned by user.
      # nixarr.audiobookshelf.vpn.enable                  boolean     false                               Route Audiobookshelf traffic through the VPN.
      #                                                                                                   Required options:
      #                                                                                                       nixarr.vpn.enable
      #                                                                                                   Conflicting options:
      #                                                                                                       nixarr.audiobookshelf.expose.https.enable
    };

    autobrr = {
      # option                          type            default                             description
      # nixarr.autobrr.enable           boolean         false                               Whether or not to enable the Autobrr service.
      #                                                                                     Required options: nixarr.enable
      # nixarr.autobrr.package          package         pkgs.autobrr                        The autobrr package to use.
      # nixarr.autobrr.openFirewall     boolean         !nixarr.autobrr.vpn.enable          Open firewall for the Autobrr port.
      # nixarr.autobrr.settings         TOML value      see following                       Autobrr configuration options.
      #                                                 {                                   See https://autobrr.com/configuration/autobrr for more information.
      #                                                   checkForUpdates = false;          sessionSecret is automatically generated upon first installation and will be overridden.
      #                                                   host = "0.0.0.0";                 This is done to ensure that the secret is not hard-coded in the configuration file.
      #                                                   port = 7474;                      The actual secret file is generated in the systemd service at /data/.state/nixarr/autobrr/session-secret.
      #                                                 }
      # nixarr.autobrr.stateDir         abs path        "${nixarr.stateDir}/autobrr"        The location of the state directory for the Autobrr service.
      #
      # nixarr.autobrr.vpn.enable       boolean         false                               Route Autobrr traffic through the VPN.
      #                                                                                     Required options:
      #                                                                                         nixarr.vpn.enable
    };

    bazarr = {
      # option                      type            default                         description
      # nixarr.bazarr.enable        boolean         false                           Whether or not to enable the Bazarr service.
      # nixarr.bazarr.package       package         pkgs.bazarr                     The bazarr package to use.
      # nixarr.bazarr.openFirewall  boolean         !nixarr.bazarr.vpn.enable       Open firewall for Bazarr
      # nixarr.bazarr.port          16b ushort      6767                            Port for Bazarr to use.
      # nixarr.bazarr.stateDir      abs path        "${nixarr.stateDir}/bazarr"     The location of the state directory for the Bazarr service.
      #                                                                             Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                     stateDir = /home/user/nixarr/.state/bazarr
      #                                                                             Is not supported, because /home/user is owned by user.
      # nixarr.bazarr.vpn.enable    boolean         false                           Route Bazarr traffic through the VPN.
      #                                                                             Required options:
      #                                                                                 nixarr.vpn.enable
    };

    ddns.njalla = {
      # option                              type            default                                 description
      # nixarr.ddns.njalla.enable           boolean         false                                   Whether or not to enable DDNS for a Njalla domain.
      #                                                                                             Required options:
      #                                                                                                 nixarr.ddns.njalla.keysFile
      # nixarr.ddns.njalla.keysFile         null/abs Path   "/data/.secret/njalla/keys-file.json"   A path to a JSON-file containing key value pairs of domains and keys.
      #                                                                                             To get the keys, create a dynamic njalla record.
      #                                                                                             Upon creation you should see something like the following command suggested:
      #                                                                                                     curl "https://njal.la/update/?h=jellyfin.example.com&k=zeubesojOLgC2eJC&auto"
      #                                                                                             Then the JSON-file you pass here should contain:
      #
      #                                                                                               {
      #                                                                                                 "jellyfin.example.com": "zeubesojOLgC2eJC"
      #                                                                                               }
      #                                                                                             You can, of course, add more key-value pairs than just one.
      # nixarr.ddns.njalla.vpn.enable       boolean         false                                   Whether or not to enable DDNS over VPN for a Njalla domain. Setting this will point to the public ip of your VPN. Useful if you’re running services over VPN and want a domain that points to the corresponding ip.
      #                                                                                             Required options:
      #                                                                                                 nixarr.ddns.njalla.keysFile
      #                                                                                                 nixarr.vpn.enable
      #                                                                                             Note: You can enable both this and the regular njalla DDNS service.
      # nixarr.ddns.njalla.vpn.keysFile     null/abs path   null                                    See nixarr.ddns.njalla.keysFile
    };

    jellyfin = {
      # option                                      type            default                             description
      # nixarr.jellyfin.enable                      boolean         false                               Whether or not to enable the Jellyfin service.
      #                                                                                                 Conflicting options:
      #                                                                                                     nixarr.plex.enable
      # nixarr.jellyfin.package                     package         pkgs.jellyfin                       The jellyfin package to use.
      #nixarr.jellyfin.expose.https.enable          boolean         false                               Expose the Jellyfin web service to the internet with https support, allowing anyone to access it.
      #                                                                                                 Required options:
      #                                                                                                     nixarr.jellyfin.expose.https.acmeMail
      #                                                                                                     nixarr.jellyfin.expose.https.domainName
      #                                                                                                 Conflicting options:
      #                                                                                                     nixarr.jellyfin.vpn.enable
      #                                                                                                 Warning: Do not enable this without setting up Jellyfin authentication through localhost first!
      # nixarr.jellyfin.expose.https.acmeMail       null/string     null                                The ACME mail required for the letsencrypt bot.
      # nixarr.jellyfin.expose.https.domainName     null/string     null                                The domain name to host Jellyfin on.
      # nixarr.jellyfin.expose.https.upnp.enable    boolean         false                               Whether to enable UPNP to try to open ports 80 and 443 on your router…
      #
      # nixarr.jellyfin.openFirewall                boolean         !nixarr.jellyfin.vpn.enable         Open firewall for Jellyfin
      #
      # nixarr.jellyfin.stateDir                    abs path        "${nixarr.stateDir}/jellyfin"       The location of the state directory for the Jellyfin service.
      #                                                                                                 Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                                     stateDir = /home/user/nixarr/.state/jellyfin
      #                                                                                                 Is not supported, because /home/user is owned by user.
      #
      # nixarr.jellyfin.vpn.enable                  boolean         false                               Route Jellyfin traffic through the VPN.
      #                                                                                                 Required options:
      #                                                                                                   nixarr.vpn.enable
      #                                                                                                 Conflicting options:
      #                                                                                                   nixarr.jellyfin.expose.https.enable
      expose.https = {
        enable = false;
        acmeMail = "awhawks@gmail.com";
        domainName = "zima1.hawkstech.org";
        upnp.enable = false;
      };
    };

    jellyseerr = {
      # option                                      type            default                             description
      # nixarr.jellyseerr.enable                    boolean         false                               Whether or not to enable the Jellyseerr service.
      # nixarr.jellyseerr.package                   package         pkgs.jellyseerr                     The jellyseerr package to use.
      # nixarr.jellyseerr.expose.https.enable       boolean         false                               Expose the Jellyseerr web service to the internet with https support, allowing anyone to access it.
      #                                                                                                 Required options:
      #                                                                                                   nixarr.jellyseerr.expose.https.acmeMail
      #                                                                                                   nixarr.jellyseerr.expose.https.domainName
      #                                                                                                 Conflicting options:
      #                                                                                                   nixarr.jellyseerr.vpn.enable
      #                                                                                                 Warning: Do not enable this without setting up Jellyseerr authentication through localhost first!
      # nixarr.jellyseerr.expose.https.acmeMail     null/string     null                                The ACME mail required for the letsencrypt bot.
      # nixarr.jellyseerr.expose.https.domainName   null/string     null                                The domain name to host Jellyseerr on.
      # nixarr.jellyseerr.expose.https.upnp.enable  boolean         false                               Whether to enable UPNP to try to open ports 80 and 443 on your router…
      # nixarr.jellyseerr.openFirewall              boolean         !nixarr.jellyseerr.vpn.enable       Open firewall for Jellyseerr
      # nixarr.jellyseerr.port                      16b ushort      5055                                Jellyseerr web-UI port.
      # nixarr.jellyseerr.stateDir                  abs path        "${nixarr.stateDir}/jellyseerr"     The location of the state directory for the Jellyseerr service.
      #                                                                                                 Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                                   stateDir = /home/user/nixarr/.state/jellyseerr
      #                                                                                                 Is not supported, because /home/user is owned by user.
      # nixarr.jellyseerr.vpn.enable                boolean         false                               Route Jellyseerr traffic through the VPN.
      #                                                                                                 Required options:
      #                                                                                                   nixarr.vpn.enable
      #                                                                                                 Conflicting options:
      #                                                                                                   nixarr.jellyseerr.expose.https.enable
    };

    lidarr = {
      # option                          type            default                             description
      # nixarr.lidarr.enable            boolean         false                               Whether or not to enable the Lidarr service.
      # nixarr.lidarr.package           package         pkgs.lidarr                         The lidarr package to use.
      # nixarr.lidarr.openFirewall      boolean         !nixarr.lidarr.vpn.enable           Open firewall for Lidarr
      # nixarr.lidarr.port              16b ushort      8686                                Port for Lidarr to use.
      # nixarr.lidarr.stateDir          abs path        "${nixarr.stateDir}/lidarr"         The location of the state directory for the Lidarr service.
      #                                                                                     Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                      stateDir = /home/user/nixarr/.state/lidarr
      #                                                                                     Is not supported, because /home/user is owned by user.
      # nixarr.lidarr.vpn.enable        boolean         false                               Route Lidarr traffic through the VPN.
      #                                                                                     Required options: nixarr.vpn.enable
    };

    plex = {
      # option                                  type            default                             description
      # nixarr.plex.enable                      boolean         false                               Whether or not to enable the Plex service.
      #                                                                                             Conflicting options:
      #                                                                                                 nixarr.jellyfin.enable
      # nixarr.plex.package                     package         pkgs.plex                           The plex package to use.
      # nixarr.plex.expose.https.enable         boolean         false                               Expose the Plex web service to the internet with https support, allowing anyone to access it.
      #                                                                                             Required options:
      #                                                                                                 nixarr.plex.expose.https.acmeMail
      #                                                                                                 nixarr.plex.expose.https.domainName
      #                                                                                             Conflicting options:
      #                                                                                                 nixarr.plex.vpn.enable
      #                                                                                             Warning: Do not enable this without setting up Plex authentication through localhost first!
      # nixarr.plex.expose.https.acmeMail       null/string     null                                The ACME mail required for the letsencrypt bot.
      # nixarr.plex.expose.https.domainName     null/string     null                                The domain name to host Plex on.
      # nixarr.plex.expose.https.upnp.enable    boolean         false                               Whether to enable UPNP to try to open ports 80 and 443 on your router…
      # nixarr.plex.openFirewall                boolean         !nixarr.plex.vpn.enable             Open firewall for Plex
      # nixarr.plex.stateDir                    abs path        "${nixarr.stateDir}/plex"           The location of the state directory for the Plex service.
      #                                                                                             Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                                 stateDir = /home/user/nixarr/.state/plex
      #                                                                                             Is not supported, because /home/user is owned by user.
      # nixarr.plex.vpn.enable                  boolean         false                               Route Plex traffic through the VPN.
      #                                                                                             Required options:
      #                                                                                                 nixarr.vpn.enable
      #                                                                                             Conflicting options:
      #                                                                                                 nixarr.plex.expose.https.enable
    };

    prowlarr = {
      # option                          type            default                             description
      # nixarr.prowlarr.enable          boolean         false                               Whether or not to enable the Prowlarr service.
      #                                                                                     This has a seperate service since running two instances is the standard way of being able to query both ebooks and audiobooks.
      # nixarr.prowlarr.package         package         pkgs.prowlarr                       The prowlarr package to use.
      # nixarr.prowlarr.openFirewall    boolean         !nixarr.prowlarr.vpn.enable         Open firewall for Prowlarr
      # nixarr.prowlarr.port            16b ushort      9696                                Port for Prowlarr to use.
      # nixarr.prowlarr.stateDir        abs path        "${nixarr.stateDir}/prowlarr"       The location of the state directory for the Prowlarr service.
      #                                                                                     Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                         stateDir = /home/user/nixarr/.state/prowlarr
      #                                                                                     Is not supported, because /home/user is owned by user.
      # nixarr.prowlarr.vpn.enable      boolean         false                               Route Prowlarr traffic through the VPN.
      #                                                                                     Required options:
      #                                                                                         nixarr.vpn.enable
    };

    radarr = {
      # option                          type            default                             description
      # nixarr.radarr.enable            boolean         false                               Whether or not to enable the Radarr service.
      # nixarr.radarr.package           package         pkgs.radarr                         The radarr package to use.
      # nixarr.radarr.openFirewall      boolean         !nixarr.radarr.vpn.enable           Open firewall for Radarr
      # nixarr.radarr.port              16b ushort      7878                                Port for Radarr to use.
      # nixarr.radarr.stateDir          abs path        "${nixarr.stateDir}/radarr"         The location of the state directory for the Radarr service.
      #                                                                                     Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                         stateDir = /home/user/nixarr/.state/radarr
      #                                                                                     Is not supported, because /home/user is owned by user.
      # nixarr.radarr.vpn.enable        boolean         false                               Route Radarr traffic through the VPN.
      #                                                                                     Required options:
      #                                                                                         nixarr.vpn.enable
    };

    readarr = {
      # option                          type            default                             description
      # nixarr.readarr.enable           boolean         false                               Whether or not to enable the Readarr service.
      # nixarr.readarr.package          package         pkgs.readarr                        The readarr package to use.
      # nixarr.readarr.openFirewall     boolean         !nixarr.readarr.vpn.enable          Open firewall for Readarr
      # nixarr.readarr.port             16b ushort      8787                                Port for Readarr to use.
      # nixarr.readarr.stateDir         abs path        "${nixarr.stateDir}/readarr"        The location of the state directory for the Readarr service.
      #                                                                                     Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                         stateDir = /home/user/nixarr/.state/readarr
      #                                                                                     Is not supported, because /home/user is owned by user.
      #
      # nixarr.readarr.vpn.enable       boolean         false                               Route Readarr traffic through the VPN.
      #                                                                                     Required options:
      #                                                                                         nixarr.vpn.enable
    };

    readarr-audiobook = {
      # option                                  type        default                                 description
      # nixarr.readarr-audiobook.enable         boolean     false                                   Whether or not to enable the Readarr Audiobook service.
      #                                                                                             This has a seperate service since running two instances is the standard way of being able to query both ebooks and audiobooks.
      # nixarr.readarr-audiobook.package        package     pkgs.readarr                            The readarr package to use.
      # nixarr.readarr-audiobook.openFirewall   boolean     !nixarr.readarr-audiobook.vpn.enable    Open firewall for Readarr Audiobook
      # nixarr.readarr-audiobook.port           16b ushort  9494                                    Port for Readarr Audiobook to use.
      # nixarr.readarr-audiobook.stateDir       abs path    "${nixarr.stateDir}/readarr-audiobook"  The location of the state directory for the Readarr Audiobook service.
      #                                                                                             Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                                 stateDir = /home/user/nixarr/.state/readarr-audiobook
      #                                                                                             Is not supported, because /home/user is owned by user.
      # nixarr.readarr-audiobook.vpn.enable     boolean     false                                   Route Readarr Audiobook traffic through the VPN.
      #                                                                                                       Required options:
      #                                                                                                           nixarr.vpn.enable
    };

    recyclarr = {
      # option                              type            default                                 description
      # nixarr.recyclarr.enable             boolean         false                                   Whether or not to enable the Recyclarr service. This service does not need to be run behind a VPN.
      # nixarr.recyclarr.package            package         pkgs.recyclarr                          The recyclarr package to use.
      # nixarr.recyclarr.configFile         null/abs path   null                                    Path to the recyclarr YAML configuration file. See Recyclarr’s documentation for more information.
      #                                                                                             The API keys for Radarr and Sonarr can be referenced in the config file using the RADARR_API_KEY and SONARR_API_KEY environment variables (with macro !env_var).
      #                                                                                             Note: You cannot set both configFile and configuration options.
      # nixarr.recyclarr.configuration      null/YamlStr    null                                    Recyclarr YAML configuration as a Nix attribute set.
      #                                                                                             For detailed configuration options and examples, see the official configuration reference.
      #                                                                                             The API keys for Radarr and Sonarr can be referenced using the RADARR_API_KEY and SONARR_API_KEY environment variables (with the string “!env_var RADARR_API_KEY”).
      #                                                                                             Note: You cannot set both configFile and configuration options.
      # nixarr.recyclarr.schedule           string          "daily"                                 When to run recyclarr in systemd calendar format.
      # nixarr.recyclarr.stateDir           abs path        "${nixarr.stateDir}/recyclarr"          The location of the state directory for the Recyclarr service.
    };

    sabnzbd = {
      # option                                    type                default                                 description
      # nixarr.sabnzbd.enable                     boolean             false                                   Whether to enable Enable the SABnzbd service…
      # nixarr.sabnzbd.package                    package             pkgs.sabnzbd                            The sabnzbd package to use.
      # nixarr.sabnzbd.guiPort                    16b short           6336                                    The port that SABnzbd’s GUI will listen on for incomming connections.
      # nixarr.sabnzbd.openFirewall               boolean             !nixarr.sabnzbd.vpn.enable              Open firewall for SABnzbd
      # nixarr.sabnzbd.stateDir                   abs path            "${nixarr.stateDir}/sabnzbd"            The location of the state directory for the SABnzbd service.
      #                                                                                                       Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                                           stateDir = /home/user/nixarr/.state/sabnzbd
      #                                                                                                       Is not supported, because /home/user is owned by user.
      # nixarr.sabnzbd.vpn.enable                 boolean             false                                   Route SABnzbd traffic through the VPN.
      #                                                                                                       Required options:
      #                                                                                                           nixarr.vpn.enable
      # nixarr.sabnzbd.whitelistHostnames         list of strings     [ config.networking.hostName ]          A list that specifies what URLs that are allowed to represent your SABnzbd instance.
      #                                                                                                       Note: If you see an error message like this when trying to connect to SABnzbd from another device:
      #                                                                                                           Refused connection with hostname "your.hostname.com"
      #                                                                                                       Then you should add your hostname (“hostname.com” above) to this list.
      #                                                                                                       SABnzbd only allows connections matching these URLs in order to prevent DNS hijacking. See https://sabnzbd.org/wiki/extra/hostname-check.html for more info.
      # nixarr.sabnzbd.whitelistRanges            list of ip ranges   []                                  A list of IP ranges that will be allowed to connect to SABnzbd’s web GUI.
      #                                                                                                   This only needs to be set if SABnzbd needs to be accessed from another machine besides its host.
    };

    sonarr = {
      # option                          type            default                                 description
      # nixarr.sonarr.enable            boolean         false                                   Whether or not to enable the Sonarr service.
      # nixarr.sonarr.package           package         pkgs.sonarr                             The sonarr package to use.
      # nixarr.sonarr.openFirewall      boolean         !nixarr.sonarr.vpn.enable               Open firewall for Sonarr
      # nixarr.sonarr.stateDir          abs path        "${nixarr.stateDir}/sonarr"             The location of the state directory for the Sonarr service.
      #                                                                                         Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                             stateDir = /home/user/nixarr/.state/sonarr
      #                                                                                         Is not supported, because /home/user is owned by user.
      # nixarr.sonarr.vpn.enable        boolean         false                                   Route Sonarr traffic through the VPN.
      #                                                                                         Required options:
      #                                                                                            nixarr.vpn.enable
    };

    transmission = {
      # option                                                        type                default                                 description
      # nixarr.transmission.enable                                    boolean             false                                   Whether or not to enable the Transmission service.
      # nixarr.transmission.package                                   package             pkgs.transmission_4                     The transmission_4 package to use.
      # nixarr.transmission.credentialsFile                           abs path            "/dev/null"                             Path to a JSON file to be merged with the settings.
      #                                                                                                                           Useful to merge a file which is better kept out of the Nix store to set secret config parameters like rpc-password.
      # nixarr.transmission.extraAllowedIps                           list of strings     []                                      Extra IP addresses allowed to access the Transmission RPC.
      #                                                                                                                           By default 192.168.* and 127.0.0.1 (localhost) are allowed,
      #                                                                                                                           but if your local network has a weird ip for some reason, you can add it here.
      # nixarr.transmission.extraSettings                             attr set            { }                                     Extra config settings for the Transmission service.
      #                                                                                                                           See the services.transmission.settings nixos options in the relevant section of the configuration.nix manual
      #                                                                                                                           or on search.nixos.org.
      # nixarr.transmission.flood.enable                              boolean             false                                   Whether to enable the flood web-UI for the transmission web-UI…
      # nixarr.transmission.messageLevel                              string              "warn"                                  Sets the message level of transmission.
      #                                                                                                                           Type: one of
      #                                                                                                                               “none”,
      #                                                                                                                               “critical”,
      #                                                                                                                               “error”,
      #                                                                                                                               “warn”,
      #                                                                                                                               “info”,
      #                                                                                                                               “debug”,
      #                                                                                                                               “trace”
      # nixarr.transmission.openFirewall                              boolean             !nixarr.transmission.vpn.enable         Open firewall for peer-port and rpc-port.
      # nixarr.transmission.peerPort                                  16b ushort          50000                                   Transmission peer traffic port.
      #                                                                                                                           Set this to the port forwarded by your VPN
      # nixarr.transmission.privateTrackers.cross-seed.enable         boolean             false                                   Whether or not to enable the cross-seed service.
      #                                                                                                                           Required options:
      #                                                                                                                               nixarr.prowlarr.enable
      # nixarr.transmission.privateTrackers.cross-seed.extraSettings  attr set            {}                                      Extra settings for the cross-seed service, see the cross-seed options documentation
      # nixarr.transmission.privateTrackers.cross-seed.indexIds       list os sint        []                                      List of indexer-ids, from prowlarr.
      #                                                                                                                           These are from the RSS links for the indexers,
      #                                                                                                                           located by the “radio” or “RSS” logo on the right of the indexer,
      #                                                                                                                           you’ll see the links have the form:
      #                                                                                                                               http://localhost:9696/1/api?apikey=aaaaaaaaaaaaa
      #                                                                                                                           Then the id needed here is the 1.
      # nixarr.transmission.privateTrackers.cross-seed.stateDir       abs path            "${nixarr.stateDir}/cross-seed"         The location of the state directory for the cross-seed service.
      #                                                                                                                           Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                                                               stateDir = /home/user/nixarr/.state/cross-seed
      #                                                                                                                           Is not supported, because /home/user is owned by user.
      # nixarr.transmission.privateTrackers.disableDhtPex             boolean             false                                   Disable pex and dht, which is required for some private trackers.
      #                                                                                                                           You don’t want to enable this unless a private tracker requires you to, and some don’t.
      #                                                                                                                           All torrents from private trackers are set as “private”,
      #                                                                                                                           and this automatically disables dht and pex for that torrent,
      #                                                                                                                           so it shouldn’t even be a necessary rule to have,
      #                                                                                                                           but I don’t make their rules ¯\(ツ)/¯.
      # nixarr.transmission.stateDir                                  abs path            "${nixarr.stateDir}/transmission"       The location of the state directory for the Transmission service.
      #                                                                                                                           Warning: Setting this to any path, where the subpath is not owned by root, will fail! For example:
      #                                                                                                                               stateDir = /home/user/nixarr/.state/transmission
      #                                                                                                                           Is not supported, because /home/user is owned by user.
      # nixarr.transmission.uiPort                                    16b ushort          9091                                    Transmission web-UI port.
      # nixarr.transmission.vpn.enable                                boolean             false                                   Route Transmission traffic through the VPN.
      #                                                                                                                           Required options:
      #                                                                                                                              nixarr.vpn.enable
      vpn.enable = false;
    };

    vpn = {
      # nixarr.vpn.enable                   boolean             false       Whether or not to enable VPN support for the services that nixarr supports.
      #                                                                     Required options:
      #                                                                        nixarr.vpn.wgConf
      # nixarr.vpn.accessibleFrom           list of string      []          What IP’s the VPN submodule should be accessible from.
      #                                                                     By default the following are included:
      #                                                                     “192.168.1.0/24”
      #                                                                     “192.168.0.0/24”
      #                                                                     “127.0.0.1”
      #                                                                     Otherwise, you would not be able to services over your local network.
      #                                                                     You might have to use this option to extend your list with your local IP range by passing it with this option.
      # nixarr.vpn.openTcpPorts             list of ushorts     []          What TCP ports to allow traffic from.
      #                                                                     You might need this if you’re port forwarding on your VPN provider and you’re setting up services not covered in by this module that uses the VPN.
      # nixarr.vpn.openUdpPorts             list of ushorts     []          What UDP ports to allow traffic from.
      #                                                                     You might need this if you’re port forwarding on your VPN provider and you’re setting up services not covered in by this module that uses the VPN.
      # nixarr.vpn.vpnTestService.enable    boolean             false       Whether to enable the vpn test service.
      #                                                                     Useful for testing DNS leaks or if the VPN port forwarding works correctly.
      # nixarr.vpn.vpnTestService.port      null or 16b ushort  null        The port that netcat listens to on the vpn test service. If set to null, then netcat will not be started.
      # nixarr.vpn.wgConf                   null or abs path    null        The path to the wireguard configuration file.
      wgConf = "/data/.secret/vpn/wg.conf";
    };
  };

  util-nixarr = {
    # option                                            type        default                                         description
    # util-nixarr.globals                               attr set    {}                                              Global values to be used by Nixarr, change at your own risk.
    # util-nixarr.services.cross-seed.enable            boolean     false                                           Whether to enable cross-seed.
    # util-nixarr.services.cross-seed.credentialsFile   abs path    "/run/secrets/cross-seed/credentialsFile.json"  Secret options to be merged into the cross-seed config
    # util-nixarr.services.cross-seed.dataDir           abs path    "/var/lib/cross-seed"                           The cross-seed dataDir
    # util-nixarr.services.cross-seed.group             string      "cross-seed"                                    Group under which cross-seed runs.
    # util-nixarr.services.cross-seed.settings          attr set    {}                                              Settings for cross-seed
    # util-nixarr.services.cross-seed.user              string      "cross-seed"                                    User account under which cross-seed runs.
    # util-nixarr.upnp.enable                           boolean     false                                           Whether to enable Enable port forwarding using UPNP…
    # util-nixarr.upnp.openTcpPorts                     list of 16b ushort  [ ]                                     What TCP ports to open using UPNP.
    # util-nixarr.upnp.openUdpPorts                     list of 16b ushort  [ ]                                     What UDP ports to open using UPNP.
  };
}
