{config, ...}: {
  services.minio = {
    enable = true;
    region = "eu-central-1";
    consoleAddress = ":3007";
    listenAddress = ":3008";
    browser = true;
    rootCredentialsFile = config.age.secrets.minio-root-cred.path;
    dataDir = ["/var/storage/s3"];
  };
  # Traefik configuration specific to minio
  services.traefik.dynamicConfigOptions.http = {
    services.minio-console.loadBalancer.servers = [
      {
        url = "http://localhost:3007/";
      }
    ];
    services.minio.loadBalancer.servers = [
      {
        url = "http://localhost:3008/";
      }
    ];

    routers.minio = {
      rule = "Host(`s3.m3tam3re.com`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "minio";
      entrypoints = "websecure";
    };
    routers.minio-console = {
      rule = "Host(`minio.m3tam3re.com`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "minio-console";
      entrypoints = "websecure";
    };
  };
}
