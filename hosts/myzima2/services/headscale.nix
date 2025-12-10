{
  config,
  pkgs,
  ...
}: {
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
#    port = 443;
    settings = {
      server_url = "https://hs.hawkstech.org:8080";
      dns = {
        base_domain = "tailscale.internal.hawkstech.org";
        nameservers = {
          global = [ "olivia.ns.cloudflare.com" "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
        };
      };
      log = {
        # Valid log levels: panic, fatal, error, warn, info, debug, trace
        level = "debug";
        # Output formatting for logs: text or json
        format = "text";
      };

      policy = {
        mode = "database";
      };

      logtail = {
        enabled = false;
      };
    };
  };

  # Firewall configuration
  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = [ 8080 ];
    # If running a DERP server:
    # allowedUDPPorts = [ 3478 ];
  };
}
