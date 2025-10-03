{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.awhawks = {
    hashedPasswordFile = config.age.secrets.hashed-password-awhawks.path;
    isNormalUser = true;
    description = "Adam W. Hawks";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
      "adbusers"
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
