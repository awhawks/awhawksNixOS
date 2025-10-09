{
  age = {
    secrets = {
      awhawks-private-ed25519 = {
        file = ../../secrets/awhawks-private-ed25519.age;
        owner = "awhawks";
        group = "users";
        mode = "0600";
      };
      awhawks-private-rsa = {
        file = ../../secrets/awhawks-private-rsa.age;
        owner = "awhawks";
        group = "users";
        mode = "0600";
      };
      hashed-password-awhawks = {
        file = ../../secrets/hashed-password-awhawks.age;
      };
      hashed-password-root = {
        file = ../../secrets/hashed-password-root.age;
      };
      newshosting = {
        file = ../../secrets/newshosting.age;
      };
      pia-ca-cert = {
        file = ../../secrets/pia-ca-cert.age;
      };
      pia-user-pass = {
        file = ../../secrets/pia-user-pass.age;
      };
      pia-switzerland = {
        file = ../../secrets/pia-switzerland.age;
        owner = "root";
        group = "root";
        mode = "0440";
        path = "/data/.secret/vpn/wg.conf";
      };
      n8n-env = {
        file = ../../secrets/n8n-env.age;
      };
      tailscale-key = {
        file = ../../secrets/tailscale-key.age;
      };
      traefik = {
        file = ../../secrets/traefik.age;
        owner = "traefik";
        group = "traefik";
      };
      vaultwarden-env = {
        file = ../../secrets/vaultwarden-env.age;
      };
    };
  };
}
