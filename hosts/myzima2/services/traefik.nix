{
  config,
  ...
}: {
  age.secrets.cloudflare_api_key = {
    file = ../../../secrets/cloudflare_api_key.age;
    owner = "traefik";
    group = "traefik";
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  systemd.services.traefik = {
    serviceConfig = {
      EnvironmentFile = [ config.age.secrets.cloudflare_api_key.path ];
    };
  };

  services.traefik = {
    enable = true;
    staticConfigOptions = {
      accessLog = true;
      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };
      global = {
        checkNewVersion = false;
        sendAnonymousUsage = false;
      };
      serversTransport = {
        insecureSkipVerify = true;
      };
      entryPoints = {
        web = {
          address = ":80";
          http = {
            redirections = {
              entryPoint = {
                to = "websecure";
                scheme = "https";
              };
            };
          };
        };
        websecure = {
          address = ":443";
          http = {
            tls = {
              options = "default";
            };
          };
        };
      };
      api = {
        dashboard = true;
        insecure = false;
        debug = false;
      };
      certificatesResolvers = {
        cloudflare = {
          acme = {
            email = "awhawks@gmail.com";
            # prod (default)
            # caServer = "https://acme-v02.api.letsencrypt.org/directory";
            # staging
            caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
            keyType = "EC256";
            storage = "/var/lib/traefik/acme.json";
            dnsChallenge = {
              provider = "cloudflare";
              delayBeforeCheck = 0;
              resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
              propagation = {
                delayBeforeChecks = 60;
                #disableChecks = true;
              };
            };
          };
        };
      };
    };
    dynamicConfigOptions = {
      http = {
        routers = {
          dashboard = {
            rule = "Host(`tr.hawkstech.org`)";
            service = "api@internal";
            middlewares = [
              "auth"
              "headers"
            ];
            entryPoints = [ "websecure" ];
            tls = {
              certResolver = "cloudflare";
            };
          };
          plexRouter = {
            rule = "Host(`plex.hawkstech.org`)";
            entryPoints = [ "websecure" ];
            service = "plexService";
          };
          jellyfinRouter = {
            rule = "Host(`jellyfin.hawkstech.org`)";
            entryPoints = [ "websecure" ];
            service = "jellyfinService";
          };
          headscaleRouter = {
            rule = "Host(`hs.hawkstech.org`)";
            entryPoints = [ "websecure" ];
            service = "headscaleService";
          };
          vaultwardenRouter = {
            rule = "Host(`vw.hawkstech.org`)";
            entryPoints = [ "websecure" ];
            service = "vaultWardenService";
          };
        };
        services = {
          dummy = {
            loadBalancer.servers = [
              {url = "http://192.168.0.1";} # This URL is never used
            ];
          };
          plexService = {
            loadBalancer = {
              servers = [ { url = "http://localhost:32400"; } ];
            };
          };
          jellyfinService = {
          };
          headscaleService = {
          };
          vaultwardenService = {
          };
        };
        middlewares = {
          auth = {
            basicAuth = {
              users = ["awhawks:$apr1$1sjFrVvw$QdIMU.kqyRbfP5y9FG/F3."];
            };
          };
          headers = {
            headers = {
              browserXssFilter = true;
              contentTypeNosniff = true;
              customFrameOptionsValue = "SAMEORIGIN";
              forceSTSHeader = true;
              frameDeny = true;
              stsIncludeSubdomains = true;
              stsPreload = true;
              stsSeconds = "315360000";
            };
          };
        };
      };
      tls = {
        options = {
          default = {
            minVersion = "VersionTLS13";
            sniStrict = true;
            curvePreferences = [
              "CurveP521"
              "CurveP384"
            ];
          };
        };
      };
    };
  };
}
