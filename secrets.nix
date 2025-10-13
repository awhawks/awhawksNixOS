let
  # USERS
  awhawksKeyPub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0E7DSiRlvqSjabsk79vISmj6Z1tEq4/MYIhFG1sngR";

  # SYSTEMS
  myzima1HostKeyPub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpUgWymWYD86WkUHRlkOLZK5at4LnaQs6GOPRJnsOnl";
  myzima2HostKeyPub="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrtdIjpEoiXOgjwPgGzhnK7m0oZwmoqb8cIioD+qjBv";

  users = [
    awhawksKeyPub
  ];

  systems = [
    myzima1HostKeyPub
    myzima2HostKeyPub
  ];
in {
  "secrets/tailscale-key.age".publicKeys           = systems ++ users;
  "secrets/traefik.age".publicKeys                 = systems ++ users;
  "secrets/vaultwarden-env.age".publicKeys         = systems ++ users;
  "secrets/awhawks-private-rsa.age".publicKeys     = systems ++ users;
  "secrets/awhawks-private-ed25519.age".publicKeys = systems ++ users;
  "secrets/hashed-password-root.age".publicKeys    = systems ++ users;
  "secrets/hashed-password-awhawks.age".publicKeys = systems ++ users;
  "secrets/n8n-env.age".publicKeys                 = systems ++ users;
  "secrets/newshosting.age".publicKeys             = systems ++ users;
  "secrets/pia-switzerland.age".publicKeys         = systems ++ users;
  "secrets/pia-ca-cert.age".publicKeys             = systems ++ users;
  "secrets/pia-user-pass.age".publicKeys           = systems ++ users;
  "secrets/valutwarden-env.age".publicKeys         = systems ++ users;
}
