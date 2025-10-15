# Auto-generated using compose2nix v0.3.3-pre.
{ pkgs, lib, config, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };

  # Enable container name DNS for all Podman networks.
  networking.firewall.interfaces = let
    matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
  in {
    "${matchAll}".allowedUDPPorts = [ 53 ];
  };

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."gluetun" = {
    image = "qmcgaw/gluetun";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "SERVER_REGIONS" = "\"Norway\",\"DE Berlin\",\"DE Frankfurt\",\"DE Germany Streaming Optimized\"";
      "TZ" = "America/New_York";
      "UPDATER_PERIOD" = "24h";
      "VPN_PORT_FORWARDING" = "on";
      "VPN_PORT_FORWARDING_STATUS_FILE" = "/gluetun/forwarded_port";
      "VPN_SERVICE_PROVIDER" = "private internet access";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/gluetun:/gluetun:rw"
    ];
    ports = [
      "8888:8888/tcp"
      "8388:8388/tcp"
      "8388:8388/udp"
      "8070:8070/tcp"
      "6881:6881/tcp"
      "6881:6881/udp"
      "6767:6767/tcp"
      "8686:8686/tcp"
      "9696:9696/tcp"
      "8787:8787/tcp"
      "7878:7878/tcp"
      "8090:8080/tcp"
      "8989:8989/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--network-alias=gluetun"
      "--network=bridge"
    ];
  };
  systemd.services."podman-gluetun" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    partOf = [
      "podman-compose-myarrstack-root.target"
    ];
    wantedBy = [
      "podman-compose-myarrstack-root.target"
    ];
  };
  virtualisation.oci-containers.containers."jellyfin" = {
    image = "lscr.io/linuxserver/jellyfin:latest";
    environment = {
      "JELLYFIN_PublishedServerUrl" = "http://192.168.60.8";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/jellyfin:/config:rw"
      "/data/media:/media:rw"
    ];
    ports = [
      "8096:8096/tcp"
      "8920:8920/tcp"
      "7359:7359/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=jellyfin"
      "--network=bridge"
    ];
  };
  systemd.services."podman-jellyfin" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-myarrstack-root.target"
    ];
    wantedBy = [
      "podman-compose-myarrstack-root.target"
    ];
  };
  virtualisation.oci-containers.containers."jellyseerr" = {
    image = "fallenbagel/jellyseerr:latest";
    environment = {
      "LOG_LEVEL" = "debug";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/jellyseerr:/app/config:rw"
    ];
    ports = [
      "5055:5055/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=jellyseerr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-jellyseerr" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-myarrstack-root.target"
    ];
    wantedBy = [
      "podman-compose-myarrstack-root.target"
    ];
  };
  virtualisation.oci-containers.containers."plex" = {
    image = "plexinc/pms-docker:plexpass";
    environment = {
      "ADVERTISE_IP" = "\"http://hawkstech.org:32400\"";
      "CHANGE_CONFIG_DIR_OWNERSHIP" = "\"true\"";
      "PLEX_CLAIM" = "claim-F2xTrxevgwWu1a4wHwTm";
      "PLEX_GID" = "1000";
      "PLEX_UID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/plex:/config:rw"
      "/data/media:/media:rw"
      "/data/transcode:/transcode:rw"
    ];
    ports = [
      "32400:32400/tcp"
      "8324:8324/tcp"
      "32469:32469/tcp"
      "1900:1900/udp"
      "32410:32410/udp"
      "32412:32412/udp"
      "32413:32413/udp"
      "32414:32414/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--device=/dev/dri:/dev/dri:rwm"
      "--hostname=awhawksPlexServer"
      "--network-alias=pms-docker"
      "--network=bridge"
    ];
  };
  systemd.services."podman-plex" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-myarrstack-root.target"
    ];
    wantedBy = [
      "podman-compose-myarrstack-root.target"
    ];
  };
  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "lscr.io/linuxserver/qbittorrent:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TORRENTING_PORT" = "6881";
      "TZ" = "America/New_York";
      "WEBUI_PORT" = "8070";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/qbittorrent:/config:rw"
      "/data/media/downloads:/media/downloads:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-qbittorrent" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-myarrstack-root.target"
    ];
    upheldBy = [
      "podman-gluetun.service"
    ];
    wantedBy = [
      "podman-compose-myarrstack-root.target"
    ];
  };
  virtualisation.oci-containers.containers."tautulli" = {
    image = "tautulli/tautulli:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/plex/Library/Application Support/Plex Media Server/Logs:/plexLogs:rw"
      "/data/config/tautulli:/config:rw"
    ];
    ports = [
      "8181:8181/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=tautulli-docker"
      "--network=bridge"
    ];
  };
  systemd.services."podman-tautulli" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    partOf = [
      "podman-compose-myarrstack-root.target"
    ];
    wantedBy = [
      "podman-compose-myarrstack-root.target"
    ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-myarrstack-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
