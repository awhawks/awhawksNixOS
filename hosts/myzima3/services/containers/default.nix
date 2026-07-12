{lib, inputs, ...}: {
  imports = [
    ./database_compose2nix/mydb2.nix
    #./database_compose2nix/mymongo.nix
  ];

  # TODO system.activationScripts.createPodmanNetworkWeb = lib.mkAfter ''
  # TODO   if ! /run/current-system/sw/bin/podman network exists web; then
  # TODO     /run/current-system/sw/bin/podman network create web --subnet=192.168.1.0/24 --internal
  # TODO   fi
  # TODO '';

}
