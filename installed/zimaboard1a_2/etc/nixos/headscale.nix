{
    services = {
        headscale = {
            enable = true;
            port = 3009;
            #package = pkgs.headscale;
            #address = "0.0.0.0";
            #port    = 8080;
            #user    = "headscale";
            #group   = "headscale";
            settings = {
                server_url = "https://va.hawkstech.com";
                dns = {
                    base_domain = "hawkstech.ts.loc";
                };
                logtail.enabled = false;
            };
        };

        # Traefik config for headscale
        traefik.dynamicConfigOptions.http = {
            services.headscale.loadBalancer.servers = [
                {
                    url = "http://localhost:3009/";
                }
            ];

            routers.headscale = {
                rule = "Host(`va.hawkstech.com`)";
                tls = {
                    certResolver = "cloudflair";
                };
                service = "headscale";
                entrypoints = "websecure";
            };
        };
    };
}

