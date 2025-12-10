# Example NixOS configuration using the headscale module
#
# This file demonstrates how to use the headscale NixOS module from this flake.
# To use in your own configuration, add this to your flake.nix inputs:
#
#   inputs.headscale.url = "github:juanfont/headscale";
#
# Then import the module:
#
#   imports = [ inputs.headscale.nixosModules.default ];
#

{
  config,
  pkgs,
  ...
}: {
  # Import the headscale module
  # In a real configuration, this would come from the flake input
  # imports = [ inputs.headscale.nixosModules.default ];

  services.headscale = {
    enable = true;

    # Optional: Use a specific package (defaults to pkgs.headscale)
    # package = pkgs.headscale;

    # Listen on all interfaces (default is 127.0.0.1)
    address = "0.0.0.0";
    port = 443;
    settings = {
      # The URL clients will connect to
      server_url = "https://hs.hawkstech.org:443";

      # The Noise section includes specific configuration for the
      # TS2021 Noise protocol
      # The Noise private key is used to encrypt the traffic between headscale and
      # Tailscale clients when using the new Noise-based protocol. A missing key
      # will be automatically generated.
      noise.private_key_path = "/var/lib/headscale/noise_private.key";

      # IP prefixes for the tailnet
      # These use the freeform settings - you can set any headscale config option
      prefixes = {
        v4 = "100.64.0.0/10";
        v6 = "fd7a:115c:a1e0::/48";
        allocation = "sequential";
      };

      # DNS configuration with MagicDNS
      ## DNS
      #
      # headscale supports Tailscale's DNS configuration and MagicDNS.
      # Please have a look to their KB to better understand the concepts:
      #
      # - https://tailscale.com/kb/1054/dns/
      # - https://tailscale.com/kb/1081/magicdns/
      # - https://tailscale.com/blog/2021-09-private-dns-with-magicdns/
      #
      # Please note that for the DNS configuration to have any effect,
      # clients must have the `--accept-dns=true` option enabled. This is the
      # default for the Tailscale client. This option is enabled by default
      # in the Tailscale client.
      #
      # Setting _any_ of the configuration and `--accept-dns=true` on the
      # clients will integrate with the DNS manager on the client or
      # overwrite /etc/resolv.conf.
      # https://tailscale.com/kb/1235/resolv-conf
      #
      # If you want stop Headscale from managing the DNS configuration
      # all the fields under `dns` should be set to empty values.
      dns = {
        # Whether to use [MagicDNS](https://tailscale.com/kb/1081/magicdns/).
        magic_dns = true;
        # Defines the base domain to create the hostnames for MagicDNS.
        # This domain _must_ be different from the server_url domain.
        # `base_domain` must be a FQDN, without the trailing dot.
        # The FQDN of the hosts will be
        # `hostname.base_domain` (e.g., _myhost.example.com_).
        base_domain = "tailscale.internal.hawkstech.org";

        # Whether to override client's local DNS settings (default: true)
        # When true, nameservers.global must be set
        # Whether to use the local DNS settings of a node or override the local DNS
        # settings (default) and force the use of Headscale's DNS configuration.
        override_local_dns = true;

        # List of DNS servers to expose to clients.
        nameservers = {
          global = [ "olivia.ns.cloudflare.com" "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
        };
      };

      # DERP (relay) configuration
      derp = {
        # Use default Tailscale DERP servers
        # List of externally available DERP maps encoded in JSON
        urls = [ "https://controlplane.tailscale.com/derpmap/default" ];
        # If enabled, a worker will be set up to periodically
        # refresh the given sources and update the derpmap
        # will be set up.
        auto_update_enabled = true;
        # How often should we check for DERP updates?
        update_frequency = "24h";

        # Optional: Run your own DERP server
        server = {
          # If enabled, runs the embedded DERP server and merges it into the rest of the DERP config
          # The Headscale server_url defined above MUST be using https, DERP requires TLS to be in place
          #enabled = true;
          # Region ID to use for the embedded DERP server.
          # The local DERP prevails if the region ID collides with other region ID coming from
          # the regular DERP config.
          #region_id = 999;
          # Region code and name are displayed in the Tailscale UI to identify a DERP region
          #region_code = "headscale";
          #region_name = "Headscale Embedded DERP";
          # Only allow clients associated with this server access
          #verify_clients = true;
          # Listens over UDP at the configured address for STUN connections - to help with NAT traversal.
          # When the embedded DERP server is enabled stun_listen_addr MUST be defined.
          # For more details on how this works, check this great article: https://tailscale.com/blog/how-tailscale-works/
          #stun_listen_addr = "0.0.0.0:3478";
          # Private key used to encrypt the traffic between headscale DERP and
          # Tailscale clients. A missing key will be automatically generated.
          #private_key_path = "/var/lib/headscale/derp_server_private.key";
          # This flag can be used, so the DERP map entry for the embedded DERP server is not written automatically,
          # it enables the creation of your very own DERP map entry using a locally available file with the parameter DERP.paths
          # If you enable the DERP server and set this to false, it is required to add the DERP server to the DERP map using DERP.paths
          #automatically_add_embedded_derp_region = true;
          # For better connection stability (especially when using an Exit-Node and DNS is not working),
          # it is possible to optionally add the public IPv4 and IPv6 address to the Derp-Map using:
          #ipv4 = "198.51.100.1";
          #ipv6 = "2001:db8::1";
        };
      };

      # Database configuration (SQLite is recommended)
      database = {
        # Database type. Available options: sqlite, postgres
        # Please note that using Postgres is highly discouraged as it is only supported for legacy reasons.
        # All new development, testing and optimisations are done with SQLite in mind.
        type = "sqlite";

        # Enable debug mode. This setting requires the log.level to be set to "debug" or "trace".
        debug = false;

        # SQLite config
        sqlite = {
          path = "/var/lib/headscale/db.sqlite";
          # Enable WAL mode for SQLite. This is recommended for production environments.
          # https://www.sqlite.org/wal.html
          write_ahead_log = true;
          # Maximum number of WAL file frames before the WAL file is automatically checkpointed.
          # https://www.sqlite.org/c3ref/wal_autocheckpoint.html
          # Set to 0 to disable automatic checkpointing.
          wal_autocheckpoint = 1000;
        };

        # PostgreSQL example (not recommended for new deployments)
        # type = "postgres";
        # postgres = {
        #   host = "localhost";
        #   port = 5432;
        #   name = "headscale";
        #   user = "headscale";
        #   password_file = "/run/secrets/headscale-db-password";
        # };
      };

      # Logging configuration
      log = {
        # Valid log levels: panic, fatal, error, warn, info, debug, trace
        level = "info";
        # Output formatting for logs: text or json
        format = "text";
      };

      # Optional: OIDC authentication
      # oidc = {
      #   issuer = "https://accounts.google.com";
      #   client_id = "your-client-id";
      #   client_secret_path = "/run/secrets/oidc-client-secret";
      #   scope = [ "openid" "profile" "email" ];
      #   allowed_domains = [ "example.com" ];
      # };

      # Optional: Let's Encrypt TLS certificates
      ### TLS configuration
      ## Let's encrypt / ACME
      # headscale supports automatically requesting and setting up
      # TLS for a domain with Let's Encrypt.
      #
      # URL to ACME directory
      #acme_url = "https://acme-v02.api.letsencrypt.org/directory";
      # Email to register with ACME provider
      #acme_email = "awhawks@gmail.com";
      # Domain name to request a TLS certificate for:
      #tls_letsencrypt_hostname = "hs.hawkstech.org";
      # Path to store certificates and metadata needed by
      # letsencrypt
      # For production:
      #tls_letsencrypt_cache_dir: /var/lib/headscale/cache
      # Type of ACME challenge to use, currently supported types:
      # HTTP-01 or TLS-ALPN-01
      # See: docs/ref/tls.md for more information
      #tls_letsencrypt_challenge_type = "HTTP-01";
      # When HTTP-01 challenge is chosen, letsencrypt must set up a
      # verification endpoint, and it will be listening on:
      # :http = port 80
      #tls_letsencrypt_listen= ":http";
      # Optional: Provide your own TLS certificates
      ## Use already defined certificates:
      #tls_cert_path = "/path/to/cert.pem";
      #tls_key_path = "/path/to/key.pem";

      # ACL policy configuration
      ## Policy
      # headscale supports Tailscale's ACL policies.
      # Please have a look to their KB to better
      # understand the concepts: https://tailscale.com/kb/1018/acls/
      policy = {
        # The mode can be "file" or "database" that defines
        # where the ACL policies are stored and read from.
        mode = "database";
        #mode = "file";
        # If the mode is set to "file", the path to a
        # HuJSON file containing ACL policies.
        #path = "/var/lib/headscale/policy.hujson";
      };

      # Logtail configuration
      # Logtail is Tailscales logging and auditing infrastructure, it allows the
      # control panel to instruct tailscale nodes to log their activity to a remote
      # server. To disable logging on the client side, please refer to:
      # https://tailscale.com/kb/1011/log-mesh-traffic#opting-out-of-client-logging
      logtail = {
        # Enable logtail for tailscale nodes of this Headscale instance.
        # As there is currently no support for overriding the log server in Headscale, this is
        # disabled by default. Enabling this will make your clients send logs to Tailscale Inc.
        enabled = false;
      };

      # Enabling this option makes devices prefer a random port for WireGuard traffic over the
      # default static port 41641. This option is intended as a workaround for some buggy
      # firewall devices. See https://tailscale.com/kb/1181/firewalls/ for more information.
      randomize_client_port = false;

      # You can add ANY headscale configuration option here thanks to freeform settings
      # For example, experimental features or settings not explicitly defined above:
      # experimental_feature = true;
      # custom_setting = "value";
    };
  };

  # Firewall configuration
  networking.firewall = {
    allowPing = true;
    allowedTCPPorts = [ 443 ];
    # If running a DERP server:
    # allowedUDPPorts = [ 3478 ];
  };
}
