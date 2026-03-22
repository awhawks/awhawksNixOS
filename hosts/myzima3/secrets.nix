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
      mongodb = {
        file = ../../secrets/mongodb.age;
      };
    };
  };
}
