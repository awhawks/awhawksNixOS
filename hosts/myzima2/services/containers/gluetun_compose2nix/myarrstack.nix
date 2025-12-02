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
  virtualisation.oci-containers.containers."bazarr" = {
    image = "lscr.io/linuxserver/bazarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/bazarr:/config:rw"
      "/data/media:/media:rw"
    ];
    ports = [
      "6767:6767/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=bazarr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-bazarr" = {
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
  virtualisation.oci-containers.containers."decluttarr" = {
    image = "ghcr.io/manimatter/decluttarr:dev";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/decluttarr:/app/config:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=decluttarr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-decluttarr" = {
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
  virtualisation.oci-containers.containers."deunhealth" = {
    image = "qmcgaw/deunhealth";
    environment = {
      "HEALTH_SERVER_ADDRESS" = "127.0.0.1:9999";
      "LOG_LEVEL" = "info";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=none"
    ];
  };
  systemd.services."podman-deunhealth" = {
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
      "8081:8081/tcp"
      "6881:6881/tcp"
      "6881:6881/udp"
      "9696:9696/tcp"
      "8090:8080/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--health-cmd=ping -c 1 www.google.com || exit 1"
      "--health-interval=20s"
      "--health-retries=5"
      "--health-timeout=10s"
      "--network-alias=gluetun"
      "--network=bridge"
    ];
  };
  systemd.services."podman-gluetun" = {
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
  virtualisation.oci-containers.containers."homarr" = {
    image = "ghcr.io/homarr-labs/homarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "SECRET_ENCRYPTION_KEY" = "<snip>";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/homarr:/appdata:rw"
      "/var/run/docker.sock:/var/run/docker.sock:rw"
    ];
    ports = [
      "7575:7575/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=homarr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-homarr" = {
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
  virtualisation.oci-containers.containers."huntarr" = {
    image = "ghcr.io/plexguide/huntarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/huntarr:/config:rw"
    ];
    ports = [
      "9705:9705/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=huntarr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-huntarr" = {
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
  virtualisation.oci-containers.containers."jellyfin" = {
    image = "lscr.io/linuxserver/jellyfin:latest";
    environment = {
      "JELLYFIN_PublishedServerUrl" = "http://myzima2a";
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
      "LOG_LEVEL" = "info";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/jellyseerr:/app/config:rw"
    ];
    ports = [
      "5054:5055/tcp"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.nginx2-slpahle-http.entrypoints" = "web";
      "traefik.http.routers.nginx2-slpahle-http.rule" = "Host(`requests.slpahle.com`)";
      "traefik.http.routers.nginx2-slpahle-https.entrypoints" = "websecure";
      "traefik.http.routers.nginx2-slpahle-https.rule" = "Host(`requests.slpahle.com`)";
      "traefik.http.routers.nginx2-slpahle-https.tls" = "true";
      "traefik.http.routers.nginx2-slpahle-https.tls.certresolver" = "cloudflare";
      "traefik.http.routers.nginx2-whoosajiggawha-http.entrypoints" = "web";
      "traefik.http.routers.nginx2-whoosajiggawha-http.rule" = "Host(`requests.whoosajiggawha.us`)";
      "traefik.http.routers.nginx2-whoosajiggawha-https.entrypoints" = "websecure";
      "traefik.http.routers.nginx2-whoosajiggawha-https.rule" = "Host(`requests.whoosajiggawha.us`)";
      "traefik.http.routers.nginx2-whoosajiggawha-https.tls" = "true";
      "traefik.http.routers.nginx2-whoosajiggawha-https.tls.certresolver" = "cloudflare";
    };
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=wget --no-verbose --tries=1 --spider http://localhost:5055/api/v1/status || exit 1"
      "--health-interval=15s"
      "--health-retries=3"
      "--health-start-period=20s"
      "--health-timeout=3s"
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
  virtualisation.oci-containers.containers."lidarr" = {
    image = "lscr.io/linuxserver/lidarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/backup/lidarr:/backup:rw"
      "/data/config/lidarr:/config:rw"
      "/data/media:/media:rw"
      "/data/media/downloads:/media/downloads:rw"
    ];
    ports = [
      "8686:8686/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=lidarr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-lidarr" = {
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
  virtualisation.oci-containers.containers."prowlarr" = {
    image = "lscr.io/linuxserver/prowlarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/backup/prowlarr:/backup:rw"
      "/data/config/prowlarr:/config:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-prowlarr" = {
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
  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "lscr.io/linuxserver/qbittorrent:latest";
    environment = {
      "DOCKER_MODS" = "ghcr.io/techclusterhq/qbt-portchecker:main";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
      "WEBUI_PORT" = "8081";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/qbittorrent:/config:rw"
      "/data/media/downloads:/media/downloads:rw"
    ];
    labels = {
      "deunhealth.restart.on.unhealthy" = "true";
    };
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=ping -c 1 www.google.com || exit 1"
      "--health-interval=1m0s"
      "--health-retries=3"
      "--health-start-period=20s"
      "--health-timeout=10s"
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
  virtualisation.oci-containers.containers."radarr" = {
    image = "lscr.io/linuxserver/radarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/backup/radarr:/backup:rw"
      "/data/config/radarr:/config:rw"
      "/data/media:/media:rw"
      "/data/media/downloads:/media/downloads:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    ports = [
      "7878:7878/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=radarr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-radarr" = {
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
  virtualisation.oci-containers.containers."readarr" = {
    image = "lscr.io/linuxserver/readarr:develop";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/backup/readarr:/backup:rw"
      "/data/config/readarr:/config:rw"
      "/data/media:/data/media:rw"
      "/data/media/downloads:/data/downloads:rw"
    ];
    ports = [
      "8787:8787/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=readarr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-readarr" = {
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
  virtualisation.oci-containers.containers."sabnzbd" = {
    image = "lscr.io/linuxserver/sabnzbd:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/sabnzbd:/config:rw"
      "/data/media/downloads:/media/downloads:rw"
      "/data/media/downloads/incomplete:/media/downloads/incomplete:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-sabnzbd" = {
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
  virtualisation.oci-containers.containers."sonarr" = {
    image = "lscr.io/linuxserver/sonarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/config/sonarr:/config:rw"
      "/data/media:/media:rw"
      "/data/media/downloads:/media/downloads:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    ports = [
      "8989:8989/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=sonarr"
      "--network=bridge"
    ];
  };
  systemd.services."podman-sonarr" = {
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
