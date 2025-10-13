{
  virtualisation.oci-containers.containers."slash-nemoti" = {
    image = "docker.io/yourselfhosted/slash:latest";
    ports = ["127.0.0.1:3016:5231"];
    volumes = [
      "slash-nemoti_data:/var/opt/slash"
    ];
    extraOptions = ["--ip=10.89.0.17" "--network=web"];
  };
  # Traefik configuration specific to littlelink
  services.traefik.dynamicConfigOptions.http = {
    services.slash-nemoti.loadBalancer.servers = [
      {
        url = "http://localhost:3016/";
      }
    ];

    routers.slash-nemoti = {
      rule = "Host(`l.nemoti.art`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "slash-nemoti";
      entrypoints = "websecure";
    };
  };
}
