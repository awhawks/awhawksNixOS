{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.groups.awhawks = {
    name = "awhawks";
    gid = 1000; # Specify the desired GID
    members = [ "awhawks" ]; # Add users to this group
  };

  users.users.awhawks = {
    hashedPasswordFile = config.age.secrets.hashed-password-awhawks.path;
    isNormalUser = true;
    uid = 1000; # Specify the desired UID
    description = "Adam W. Hawks";
    extraGroups = [
      "adbusers"
      "audio"
      "flatpak"
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "podman"
      "qemu-libvirtd"
      "video"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      ( builtins.readFile ../../../home/awhawks/awhawks-rsa-public )
      ( builtins.readFile ../../../home/awhawks/awhawks-ed25519-public )
    ];
    packages = [
        inputs.home-manager.packages.${pkgs.system}.default
    ];
  };
  home-manager.users.awhawks =
    import ../../../home/awhawks/${config.networking.hostName}.nix;
}
