{
  services.wastebin = {
    enable = true;
    settings = {
      WASTEBIN_TITLE = "m3tam3re's wastebin";
      WASTEBIN_BASE_URL = "https://bin.m3ta.dev";
      WASTEBIN_ADDRESS_PORT = "0.0.0.0:3003";
      WASTEBIN_MAX_BODY_SIZE = 1048576;
    };
  };
  # Traefik configuration specific to wastebin
  services.traefik.dynamicConfigOptions.http = {
    services.wastebin.loadBalancer.servers = [
      {
        url = "http://localhost:3003/";
      }
    ];

    routers.wastebin = {
      rule = "Host(`bin.m3ta.dev`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "wastebin";
      entrypoints = "websecure";
    };
    routers.wastebin-old = {
      rule = "Host(`bin.m3tam3re.com`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "wastebin";
      entrypoints = "websecure";
      middlewares = ["subdomain-redirect"];
    };
  };
}
