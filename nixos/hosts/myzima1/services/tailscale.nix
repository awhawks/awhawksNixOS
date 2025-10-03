{
  config,
  lib,
  pkgs,
  ...
}: {
  services.tailscale = {
    enable = false;
    authKeyFile = config.age.secrets.tailscale-key.path;
    useRoutingFeatures = "both";
    extraUpFlags = [
      "--login-server=${config.services.headscale.settings.server_url}"
      "--advertise-exit-node"
      "--accept-routes"
    ];
  };
  services.networkd-dispatcher = lib.mkIf config.services.tailscale.enable {
    enable = true;
    rules."50-tailscale" = {
      onState = ["routable"];
      script = ''
        NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
        ${pkgs.ethtool}/bin/ethtool -K "$NETDEV" rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };
}
