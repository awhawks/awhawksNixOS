{config, ...}: {
  virtualisation.oci-containers.containers."baserow" = {
    image = "docker.io/baserow/baserow:1.34.2";
    environmentFiles = [config.age.secrets.baserow-env.path];
    ports = ["127.0.0.1:3001:80"];
    volumes = ["baserow_data:/baserow/data"];
    extraOptions = ["--add-host=postgres:10.89.0.1" "--ip=10.89.0.10" "--network=web"];
  };
  # Traefik configuration specific to baserow
  services.traefik.dynamicConfigOptions.http = {
    services.baserow.loadBalancer.servers = [
      {
        url = "http://localhost:3001/";
      }
    ];

    routers.baserow = {
      rule = "Host(`br.m3ta.dev`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "baserow";
      entrypoints = "websecure";
    };
    routers.baserow-old = {
      rule = "Host(`br.m3tam3re.com`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "baserow";
      entrypoints = "websecure";
      middlewares = ["subdomain-redirect"];
    };
  };
}
