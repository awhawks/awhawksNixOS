{ config, inputs, outputs, lib, pkgs, ... }:
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
                path = "/home/.ssh/id_rsa";
            };
            hashed-password-awhawks = {
                file = ../../secrets/hashed-password-awhawks.age;
            };
            hashed-password-root = {
                file = ../../secrets/hashed-password-root.age;
            };
            pia-switzerland = {
                file = ../../secrets/pia-switzerland.age;
                owner = "root";
                group = "root";
                mode = "0440";
                path = "/data/.secret/vpn/wg.conf";
            };
        };
    };
}
