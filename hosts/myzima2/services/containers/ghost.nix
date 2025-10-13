{config, ...}: {
  virtualisation.oci-containers.containers."ghost" = {
    image = "docker.io/ghost:latest";
    environmentFiles = [config.age.secrets.ghost-env.path];
    ports = ["127.0.0.1:3002:2368"];
    volumes = ["ghost_data:/var/lib/ghost/content"];
    extraOptions = ["--add-host=mysql:10.89.0.1" "--ip=10.89.0.11" "--network=web"];
  };
  # Traefik configuration specific to ghost
  services.traefik.dynamicConfigOptions.http = {
    services.ghost.loadBalancer.servers = [
      {
        url = "http://localhost:3002/";
      }
    ];
    routers = {
      ghost = {
        rule = "Host(`m3ta.dev`) || Host(`www.m3ta.dev`)";
        tls = {
          certResolver = "godaddy";
        };
        service = "ghost";
        entrypoints = "websecure";
        middlewares = ["strip-www"];
      };
      ghost-old = {
        rule = "Host(`www.m3tam3re.com`)";
        tls = {
          certResolver = "godaddy";
        };
        service = "ghost";
        entrypoints = "websecure";
        middlewares = ["domain-redirect"];
      };
    };
  };
}
