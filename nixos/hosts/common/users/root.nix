{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.root = {
    hashedPasswordFile = config.age.secrets.hashed-password-root.path;
    openssh.authorizedKeys.keys = [
      ( builtins.readFile ../../../home/awhawks/awhawks-rsa-public )
      ( builtins.readFile ../../../home/awhawks/awhawks-ed25519-public )
    ];
  };
}
