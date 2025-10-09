{config, ...}: {
  virtualisation.oci-containers.containers."littlelink_m3tam3re" = {
    image = "ghcr.io/techno-tim/littlelink-server";
    environmentFiles = [config.age.secrets.littlelink-m3tam3re.path];
    ports = ["127.0.0.1:3004:3000"];
    extraOptions = ["--ip=10.89.0.4" "--network=web"];
  };
  # Traefik configuration specific to littlelink
  services.traefik.dynamicConfigOptions.http = {
    services.littlelink-m3tam3re.loadBalancer.servers = [
      {
        url = "http://localhost:3004/";
      }
    ];

    routers.littlelink-m3tam3re = {
      rule = "Host(`links.m3tam3re.com`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "littlelink-m3tam3re";
      entrypoints = "websecure";
    };
  };
}
