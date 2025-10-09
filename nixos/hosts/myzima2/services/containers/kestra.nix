{ config, ... }: {
  virtualisation.oci-containers.containers."kestra" = {
    image = "docker.io/kestra/kestra:latest";
    environmentFiles = [ config.age.secrets.kestra-env.path ];
    cmd = [ "server" "standalone" "--config" "/etc/config/application.yaml"];
    ports = [ "127.0.0.1:3018:8080" ];
    user = "root";
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock"
      "${config.age.secrets.kestra-config.path}:/etc/config/application.yaml"
      "kestra_data:/app/storage"
      "/tmp/kestra-wd:/tmp/kestra-wd"
    ];
    extraOptions =
      [ "--add-host=postgres:10.89.0.1" "--ip=10.89.0.18" "--network=web" ];
  };

  systemd.tmpfiles.rules = [
    "d /tmp/kestra-wd 0750 1000 1000 - -"
  ];

  # Traefik configuration specific to littlelink
  services.traefik.dynamicConfigOptions.http = {
    services.kestra.loadBalancer.servers =
      [{ url = "http://localhost:3018/"; }];

    routers.kestra = {
      rule = "Host(`k.m3ta.dev`)";
      tls = { certResolver = "godaddy"; };
      service = "kestra";
      entrypoints = "websecure";
    };
  };
}
