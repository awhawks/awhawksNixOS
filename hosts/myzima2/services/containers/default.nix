{lib, inputs, ...}: {
  imports = [
    #./baserow.nix
    #./ghost.nix
    #./kestra.nix
    #./littlelink.nix
    #./matomo.nix
    #./n8n.nix
    #./pangolin.nix
    #./restreamer.nix
    #./slash.nix
    #./slash-nemoti.nix
    ./gluetun_compose2nix/myarrstack.nix
  ];
  system.activationScripts.createPodmanNetworkWeb = lib.mkAfter ''
    if ! /run/current-system/sw/bin/podman network exists web; then
      /run/current-system/sw/bin/podman network create web --subnet=10.89.0.0/24 --internal
    fi
  '';
}
