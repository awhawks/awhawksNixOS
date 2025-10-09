{
  config,
  pkgs,
  lib,
  ...
}: let
  # Define the Pangolin configuration as a Nix attribute set
  pangolinConfig = {
    app = {
      dashboard_url = "https://vpn.m3tam3re.com";
      log_level = "info";
      save_logs = false;
    };

    domains = {
      vpn = {
        base_domain = "m3tam3re.com";
        cert_resolver = "godaddy";
        prefer_wildcard_cert = false;
      };
    };

    server = {
      external_port = 3000;
      internal_port = 3001;
      next_port = 3002;
      internal_hostname = "pangolin";
      session_cookie_name = "p_session_token";
      resource_access_token_param = "p_token";
      resource_session_request_param = "p_session_request";
    };

    traefik = {
      cert_resolver = "godaddy";
      http_entrypoint = "web";
      https_entrypoint = "websecure";
    };

    gerbil = {
      start_port = 51820;
      base_endpoint = "vpn.m3tam3re.com";
      use_subdomain = false;
      block_size = 24;
      site_block_size = 30;
      subnet_group = "100.89.137.0/20";
    };

    rate_limits = {
      global = {
        window_minutes = 1;
        max_requests = 100;
      };
    };

    email = {
      smtp_host = config.age.secrets.smtp-host.path;
      smtp_port = 587;
      smtp_user = config.age.secrets.smtp-user.path;
      smtp_pass = config.age.secrets.smtp-pass.path;
      no_reply = config.age.secrets.smtp-user.path;
    };

    users = {
      server_admin = {
        email = "admin@m3tam3re.com";
        password = config.age.secrets.pangolin-admin-password.path;
      };
    };

    flags = {
      require_email_verification = true;
      disable_signup_without_invite = true;
      disable_user_create_org = true;
      allow_raw_resources = true;
      allow_base_domain_resources = true;
    };
  };

  # Convert Nix attribute set to YAML using a simpler approach
  pangolinConfigYaml = pkgs.writeTextFile {
    name = "config.yml";
    text = lib.generators.toYAML {} pangolinConfig;
  };
in {
  # Define the containers
  virtualisation.oci-containers.containers = {
    "pangolin" = {
      image = "fosrl/pangolin:1.1.0";
      autoStart = true;
      volumes = [
        "${pangolinConfigYaml}:/app/config/config.yml:ro" # Mount the config file directly
        "pangolin_config:/app/config/data" # Volume for persistent data
      ];
      ports = [
        "127.0.0.1:3020:3001" # API server
        "127.0.0.1:3021:3002" # Next.js server
        "127.0.0.1:3022:3000" # API/WebSocket server
      ];
      extraOptions = ["--ip=10.89.0.20" "--network=web"];
    };

    "gerbil" = {
      image = "fosrl/gerbil:1.0.0";
      autoStart = true;
      volumes = [
        "pangolin_config:/var/config" # Share the volume for persistent data
      ];
      cmd = [
        "--reachableAt=http://gerbil:3003"
        "--generateAndSaveKeyTo=/var/config/key"
        "--remoteConfig=http://pangolin:3001/api/v1/gerbil/get-config"
        "--reportBandwidthTo=http://pangolin:3001/api/v1/gerbil/receive-bandwidth"
      ];
      ports = [
        "51820:51820/udp" # WireGuard port
      ];
      extraOptions = [
        "--ip=10.89.0.21"
        "--network=web"
        "--cap-add=NET_ADMIN"
        "--cap-add=SYS_MODULE"
      ];
    };
  };

  # Secrets for Pangolin
  # age.secrets = {
  #   "smtp-host" = {
  #     file = ../secrets/smtp-host.age;
  #     owner = "root";
  #     group = "root";
  #     mode = "0400";
  #   };
  #   "smtp-user" = {
  #     file = ../secrets/smtp-user.age;
  #     owner = "root";
  #     group = "root";
  #     mode = "0400";
  #   };
  #   "smtp-pass" = {
  #     file = ../secrets/smtp-pass.age;
  #     owner = "root";
  #     group = "root";
  #     mode = "0400";
  #   };
  #   "pangolin-admin-password" = {
  #     file = ../secrets/pangolin-admin-password.age;
  #     owner = "root";
  #     group = "root";
  #     mode = "0400";
  #   };
  # };

  # Traefik configuration for Pangolin
  services.traefik.dynamicConfigOptions = {
    http = {
      # Next.js service (front-end)
      services.pangolin-next-service.loadBalancer.servers = [
        {url = "http://localhost:3021";}
      ];

      # API service
      services.pangolin-api-service.loadBalancer.servers = [
        {url = "http://localhost:3022";}
      ];

      # Routers
      routers = {
        # Next.js router (handles everything except API paths)
        "pangolin-next" = {
          rule = "Host(`vpn.m3tam3re.com`) && !PathPrefix(`/api/v1`)";
          service = "pangolin-next-service";
          entrypoints = ["websecure"];
          tls = {
            certResolver = "godaddy";
          };
        };

        # API router
        "pangolin-api" = {
          rule = "Host(`vpn.m3tam3re.com`) && PathPrefix(`/api/v1`)";
          service = "pangolin-api-service";
          entrypoints = ["websecure"];
          tls = {
            certResolver = "godaddy";
          };
        };
      };
    };
  };

  # Add HTTP provider to Traefik for dynamic configuration from Pangolin
  services.traefik.staticConfigOptions.providers.http = {
    endpoint = "http://localhost:3020/api/v1/traefik-config";
    pollInterval = "5s";
  };

  # Add experimental section for Badger plugin
  services.traefik.staticConfigOptions.experimental = {
    plugins = {
      #TODO create an overlay for the plugin
      badger = {
        moduleName = "github.com/fosrl/badger";
        version = "v1.0.0";
      };
    };
  };

  # Firewall configuration for WireGuard
  networking.firewall.allowedUDPPorts = [51820]; # WireGuard port
}
