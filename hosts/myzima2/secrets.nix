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
      gluetun-env = {
        file = ../../secrets/gluetun-env.age;
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
