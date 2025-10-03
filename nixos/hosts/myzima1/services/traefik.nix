{config, ...}: {
  services.traefik = {
    enable = false;
    staticConfigOptions = {
      log = {level = "WARN";};
      certificatesResolvers = {
        cloudflare = {
          acme = {
            email = "letsencrypt.org.btlc2@passmail.net";
            storage = "/var/lib/traefik/acme.json";
            caserver = "https://acme-v02.api.letsencrypt.org/directory";
            dnsChallenge = {
              provider = "cloudflare";
              resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
              propagation = {
                delayBeforeChecks = 60;
                disableChecks = true;
              };
            };
          };
        };
      };
      api = {};
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        rtmp = {
          address = ":1935";
        };
        rtmps = {
          address = ":1945";
        };
        websecure = {
          address = ":443";
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
          domain-redirect = {
            redirectRegex = {
              regex = "^https://www\\.hawkstech\\.org(.*)";
              replacement = "https://hawkstech.dev$1";
              permanent = true;
            };
          };
          strip-www = {
            redirectRegex = {
              regex = "^https://www\\.(.+)";
              replacement = "https://$1";
              permanent = true;
            };
          };
          subdomain-redirect = {
            redirectRegex = {
              regex = "^https://([a-zA-Z0-9-]+)\\.hawkstech\\.org(.*)";
              replacement = "https://$1.hawkstech.dev$2";
              permanent = true;
            };
          };
          auth = {
            basicAuth = {
              users = ["m3tam3re:$apr1$1xqdta2b$DIVNvvp5iTUGNccJjguKh."];
            };
          };
        };

        routers = {
          api = {
            rule = "Host(`r.hawkstech.org`)";
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
    EnvironmentFile = ["${config.age.secrets.traefik.path}"];
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
