{
  virtualisation.oci-containers.containers."matomo" = {
    image = "docker.io/matomo:latest";
    ports = ["127.0.0.1:3011:80"];
    volumes = ["matomo_data:/var/www/html"];
    environment = {
      MATOMO_DATABASE_HOST = "mysql";
      MATOMO_DATABASE_USERNAME = "matomo";
      MATOMO_DATABASE_PASSWORD = "matomo";
      MATOMO_DATABASE_DBNAME = "matomo";
      MYSQL_DATABASE = "matomo";
      PHP_MEMORY_LIMIT = "2048M";
    };
    extraOptions = ["--add-host=mysql:10.89.0.1" "--ip=10.89.0.16" "--network=web"];
  };
  # Traefik configuration specific to ghost
  services.traefik.dynamicConfigOptions.http = {
    services.matomo.loadBalancer.servers = [
      {
        url = "http://localhost:3011/";
      }
    ];

    routers = {
      matomo-nemoti = {
        rule = "Host(`stats.nemoti.com`)";
        tls = {
          certResolver = "godaddy";
        };
        service = "matomo";
        entrypoints = "websecure";
      };
      matomo-m3tam3re = {
        rule = "Host(`stats.m3tam3re.com`)";
        tls = {
          certResolver = "godaddy";
        };
        service = "matomo";
        entrypoints = "websecure";
      };
    };
  };
}
