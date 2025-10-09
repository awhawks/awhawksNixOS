{
  virtualisation.oci-containers.containers."slash" = {
    image = "docker.io/yourselfhosted/slash:latest";
    ports = ["127.0.0.1:3010:5231"];
    volumes = [
      "slash_data:/var/opt/slash"
    ];
    extraOptions = ["--ip=10.89.0.15" "--network=web"];
  };
  # Traefik configuration specific to littlelink
  services.traefik.dynamicConfigOptions.http = {
    services.slash.loadBalancer.servers = [
      {
        url = "http://localhost:3010/";
      }
    ];

    routers.slash = {
      rule = "Host(`l.m3ta.dev`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "slash";
      entrypoints = "websecure";
    };
  };
}
