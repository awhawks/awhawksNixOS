{pkgs, ...}: {
    services.nfs.server =  {
      enable = true;
      createMountPoints = true;
      exports = ''
        /data	10.0.0.0/8(rw,async,no_wdelay,insecure,no_root_squash,insecure_locks,sec=sys:krb5i,anonuid=1025,anongid=100)
      '';
    };
}
