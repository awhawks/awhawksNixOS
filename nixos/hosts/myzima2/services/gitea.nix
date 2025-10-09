{
  services.gitea = {
    enable = true;
    settings = {
      server = {
        ROOT_URL = "https://code.m3ta.dev";
        HTTP_PORT = 3030;
      };
      mailer.SENDMAIL_PATH = "/run/wrappers/bin/sendmail";
      service.DISABLE_REGISTRATION = true;
    };
    lfs.enable = true;
    dump = {
      enable = true;
      type = "tar.gz";
      interval = "03:30:00";
      backupDir = "/var/backup/gitea";
    };
  };
  # Traefik configuration specific to gitea
  services.traefik.dynamicConfigOptions.http = {
    services.gitea.loadBalancer.servers = [
      {
        url = "http://localhost:3030/";
      }
    ];

    routers.gitea = {
      rule = "Host(`code.m3ta.dev`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "gitea";
      entrypoints = "websecure";
    };
    routers.gitea-old = {
      rule = "Host(`code.m3tam3re.com`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "gitea";
      entrypoints = "websecure";
      middlewares = ["subdomain-redirect"];
    };
  };
}
