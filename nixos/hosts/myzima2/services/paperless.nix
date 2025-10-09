{config, ...}: {
  services.paperless = {
    enable = true;
    port = 3012;
    database.createLocally = true;
    passwordFile = config.age.secrets.paperless-key.path;
    configureTika = true;
    settings = {
      PAPERLESS_URL = "https://pl.m3ta.dev";
      DATABASE_URL = "postgresql://paperless:paperless@127.0.0.1:5432/paperless";
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
        ".env"
      ];
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };

  # Traefik configuration for headscale
  services.traefik.dynamicConfigOptions.http = {
    services.paperless.loadBalancer.servers = [
      {
        url = "http://localhost:3012/";
      }
    ];
    routers.paperless = {
      rule = "Host(`pl.m3ta.dev`)";
      tls = {
        certResolver = "godaddy";
      };
      service = "paperless";
      entrypoints = "websecure";
    };
  };
}
