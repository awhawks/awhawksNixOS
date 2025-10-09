{config, ...}: {
  virtualisation.oci-containers.containers."n8n" = {
    image = "docker.n8n.io/n8nio/n8n";
    environmentFiles = [config.age.secrets.n8n-env.path];
    ports = ["127.0.0.1:5678:5678"];
    volumes = ["n8n_data:/home/node/.n8n"];
    extraOptions = ["--add-host=postgres:10.89.0.1" "--ip=10.89.0.14" "--network=web"];
  };

  # Traefik configuration specific to n8n
  services.traefik.dynamicConfigOptions.http = {
    services.n8n.loadBalancer.servers = [
      {
        url = "http://localhost:5678/";
      }
    ];

    routers.n8n = {
      rule = "Host(`wf.hawkstech.org`)";
      tls = {
        certResolver = "cloudflare";
      };
      service = "n8n";
      entrypoints = "websecure";
    };
  };
}
