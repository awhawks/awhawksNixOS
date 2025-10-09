{config, ...}: {
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      log = {level = "WARN";};
      certificatesResolvers = {
        cloudflare = {
          acme = {
            email = "awhawks@gmail.com";
            storage = "/var/lib/traefik/acme.json";
            # prod (default)
            # caServer = "https://acme-v02.api.letsencrypt.org/directory";
            # staging
            caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
            keyType = "EC256";
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
              propagation = {
                delayBeforeChecks = 60;
                #disableChecks = true;
              };
            };
          };
        };
      };
      api = {
        dashboard = true;
        insecure = true;
        debug = false;
      };
      serversTransport = {
        insecureSkipVerify = true;
      };
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
        };
        rtmp = {
          address = ":1935";
        };
        rtmps = {
          address = ":1945";
        };
      };
    };
    dynamicConfigOptions = {
      http = {
        services = {
          dummy = {
            loadBalancer.servers = [
              {url = "http://192.168.0.1";} # Diese URL wird nie verwendet
            ];
          };
        };
        middlewares = {
          auth = {
            basicAuth = {
              users = ["awhawks:$apr1$1sjFrVvw$QdIMU.kqyRbfP5y9FG/F3."];
            };
          };
        };

        routers = {
          api = {
            rule = "Host(`traefik.hawkstech.org`)";
            service = "api@internal";
            middlewares = ["auth"];
            entrypoints = ["websecure"];
            tls = {
              certResolver = "cloudflare";
            };
          };
        };
      };
    };
  };

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = config.age.secrets.traefik.path;
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
