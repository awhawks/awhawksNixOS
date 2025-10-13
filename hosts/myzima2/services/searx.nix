{pkgs, ...}: {
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server.port = 3005;
      server.secret_key = "@SEARX_SECRET_KEY@";
      search.formats = ["html" "json"];
    };
  };
  # Traefik configuration specific to searx
  services.traefik.dynamicConfigOptions.http = {
    services.searx.loadBalancer.servers = [
      {
        url = "http://localhost:3005/";
      }
    ];

    routers.searx = {
      rule = "Host(`search.m3ta.dev`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "searx";
      entrypoints = "websecure";
    };
    routers.searx-old = {
      rule = "Host(`search.m3tam3re.com`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "searx";
      entrypoints = "websecure";
      middlewares = ["subdomain-redirect"];
    };
  };
}
