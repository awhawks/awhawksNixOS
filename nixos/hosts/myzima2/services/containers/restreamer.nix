{config, ...}: {
  virtualisation.oci-containers.containers."restreamer" = {
    image = "docker.io/datarhei/restreamer:latest";
    environmentFiles = [config.age.secrets.restreamer-env.path];
    # Modified ports to include RTMPS
    ports = [
      "127.0.0.1:3006:8080" # Web UI
      "127.0.0.1:1936:1935" # RTMP
    ];
    volumes = [
      "restreamer_data:/core/data"
      "restreamer_config:/core/config"
    ];
    extraOptions = ["--add-host=postgres:10.89.0.1" "--ip=10.89.0.13" "--network=web"];
  };

  # Traefik configuration
  services.traefik = {
    dynamicConfigOptions = {
      http = {
        services.restreamer.loadBalancer.servers = [
          {
            url = "http://localhost:3006/";
          }
        ];

        routers.restreamer = {
          rule = "Host(`stream.m3ta.dev`)";
          tls = {
            certResolver = "godaddy";
          };
          service = "restreamer";
          entrypoints = ["websecure"];
        };
      };

      tcp = {
        services = {
          rtmp-service.loadBalancer.servers = [
            {
              address = "localhost:1936";
            }
          ];
          rtmps-service.loadBalancer.servers = [
            {
              address = "localhost:1936";
            }
          ];
        };

        routers = {
          rtmp = {
            rule = "HostSNI(`*`)"; # Changed to accept all SNI
            service = "rtmp-service";
            entryPoints = ["rtmp"];
          };
          rtmps = {
            rule = "HostSNI(`stream.m3tam3re.com`)";
            service = "rtmps-service";
            entryPoints = ["rtmps"];
            tls = {
              certResolver = "godaddy";
              passthrough = false;
            };
          };
        };
      };
    };
  };

  # Firewall configuration
  networking.firewall = {
    allowedTCPPorts = [1935 1945];
  };
}
