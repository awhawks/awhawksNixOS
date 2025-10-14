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
  virtualisation.oci-containers.containers."deluge" = {
    image = "lscr.io/linuxserver/deluge:latest";
    environment = {
      "DELUGE_LOGLEVEL" = "error";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/docker/state/deluge:/config:rw"
      "/data/docker/state/gluetun:/pia:ro"
      "/data/downloads/complete:/data/downloads:rw"
      "/data/downloads/incomplete:/data/incomplete-downloads:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-deluge" = {
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
  virtualisation.oci-containers.containers."flaresolverr" = {
    image = "ghcr.io/flaresolverr/flaresolverr:latest";
    environment = {
      "CAPTCHA_SOLVER" = "none";
      "LOG_HTML" = "false";
      "LOG_LEVEL" = "info";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-flaresolverr" = {
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
      "/data/docker/state/gluetun:/gluetun:rw"
    ];
    ports = [
      "8888:8888/tcp"
      "8388:8388/tcp"
      "8388:8388/udp"
      "8112:8112/tcp"
      "6881:6881/tcp"
      "6881:6881/udp"
      "58846:58846/tcp"
      "8090:8080/tcp"
      "9696:9696/tcp"
      "8989:8989/tcp"
      "7878:7878/tcp"
      "8686:8686/tcp"
      "8787:8787/tcp"
      "8191:8191/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--device=/dev/net/tun:/dev/net/tun:rwm"
      "--network-alias=gluetun"
      "--network=myarrstack_default"
    ];
  };
  systemd.services."podman-gluetun" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "podman-network-myarrstack_default.service"
    ];
    requires = [
      "podman-network-myarrstack_default.service"
    ];
    partOf = [
      "podman-compose-myarrstack-root.target"
    ];
    upheldBy = [
      "podman-network-myarrstack_default.service"
    ];
    wantedBy = [
      "podman-compose-myarrstack-root.target"
    ];
  };
  virtualisation.oci-containers.containers."jellyfin" = {
    image = "lscr.io/linuxserver/jellyfin:latest";
    environment = {
      "NVIDIA_VISIBLE_DEVICES" = "all";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "America/New_York";
    };
    environmentFiles = [
      "/run/agenix/gluetun-env"
    ];
    volumes = [
      "/data/docker/state/jellyfin/library:/config:rw"
      "/data/media:/data/media:rw"
    ];
    ports = [
      "8096:8096/tcp"
      "8920:8920/tcp"
      "7359:7359/udp"
      "1900:1900/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--device=/dev/dri/:/dev/dri/:rwm"
      "--network-alias=jellyfin"
      "--network=myarrstack_default"
    ];
  };
  systemd.services."podman-jellyfin" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-myarrstack_default.service"
    ];
    requires = [
      "podman-network-myarrstack_default.service"
    ];
    partOf = [
      "podman-compose-myarrstack-root.target"
    ];
    upheldBy = [
      "podman-network-myarrstack_default.service"
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
      "/data/docker/state/jellyseerr/config:/app/config:rw"
    ];
    ports = [
      "5055:5055/tcp"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-jellyseerr" = {
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
      "/data/docker/state/backup/lidarr:/backup:rw"
      "/data/docker/state/lidarr/config:/config:rw"
      "/data/downloads/complete:/data/downloads:rw"
      "/data/media/slpahle/music:/data/media/slpahle/music:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-lidarr" = {
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
      "/data/docker/state/backup/prowlarr:/backup:rw"
      "/data/docker/state/prowlarr/config:/config:rw"
      "/data/downloads/complete:/data/downloads:rw"
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
      "/data/docker/state/backup/radarr:/backup:rw"
      "/data/docker/state/radarr/config:/config:rw"
      "/data/downloads/complete:/data/downloads:rw"
      "/data/media/slpahle/movies:/data/media/slpahle/movies:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-radarr" = {
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
      "/data/docker/state/backup/readarr:/backup:rw"
      "/data/docker/state/readarr/config:/config:rw"
      "/data/downloads/complete:/data/downloads:rw"
      "/data/media/slpahle/books:/data/media/slpahle/books:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-readarr" = {
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
      "/data/docker/state/backup/sabnzb:/backup:rw"
      "/data/docker/state/sabnzb/config:/config:rw"
      "/data/downloads/complete:/data/downloads:rw"
      "/data/downloads/incomplete:/data/incomplete-downloads:rw"
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
      "/data/docker/state/backup/sonarr:/backup:rw"
      "/data/docker/state/sonarr/config:/config:rw"
      "/data/downloads/complete:/data/downloads:rw"
      "/data/media/slpahle/tv:/data/media/slpahle/tv:rw"
    ];
    dependsOn = [
      "gluetun"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:gluetun"
    ];
  };
  systemd.services."podman-sonarr" = {
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

  # Networks
  systemd.services."podman-network-myarrstack_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f myarrstack_default";
    };
    script = ''
      podman network inspect myarrstack_default || podman network create myarrstack_default
    '';
    partOf = [ "podman-compose-myarrstack-root.target" ];
    wantedBy = [ "podman-compose-myarrstack-root.target" ];
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
