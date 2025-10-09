{
  services.outline = {
    enable = true;
    port = 3019;
    publicUrl = "https://ol.m3ta.dev";
    databaseUrl = "postgresql://outline:outline@127.0.0.1:5432/outline";
    storage = {
      storageType = "local";
    };
  };
  systemd.services.outline.serviceConfig = {
    Environment = [
      "PGSSLMODE=disable"
    ];
  };
  # Traefik configuration specific to littlelink
  services.traefik.dynamicConfigOptions.http = {
    services.outline.loadBalancer.servers = [
      {
        url = "http://localhost:3019/";
      }
    ];

    routers.outline = {
      rule = "Host(`ol.m3ta.dev`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "outline";
      entrypoints = "websecure";
    };
  };
}
