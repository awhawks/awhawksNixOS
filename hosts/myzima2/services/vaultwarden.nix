{config, ...}: {
  age.secrets.vaultwarden-env = {
    file = ../../../secrets/vaultwarden-env.age;
  };

  services.vaultwarden = {
    enable = false;
    backupDir = "/var/backup/vaultwarden";
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 3013;
    };
    environmentFile = config.age.secrets.vaultwarden-env.path;
  };

  # Traefik configuration for headscale
  services.traefik.dynamicConfigOptions.http = {
    services.vaultwarden.loadBalancer.servers = [
      {
        url = "http://localhost:3013/";
      }
    ];

    routers.vaultwarden = {
      rule = "Host(`vw.hawkstech.org`)";
      tls = {
        certResolver = "cloudflare";
      };
      service = "vaultwarden";
      entrypoints = "websecure";
    };
  };
}
