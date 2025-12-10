{pkgs, ...}: {
    services.nfs.server =  {
      enable = true;
      createMountPoints = true;
      statdPort  = 4000;
      lockdPort  = 4001;
      mountdPort = 4002;
      extraNfsdConfig = '''';
      exports = ''
        /data	10.0.0.0/255.0.0.0(rw,no_subtree_check,anonuid=1000,anongid=100)
      '';
    };
    networking.firewall = {
      enable = true;
      # for NFSv3; view with `rpcinfo -p`
      allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
      allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
    };
}
