{pkgs, ...}: {
    services.nfs.server =  {
      enable = true;
      exports = ''
        /data	192.168.60.0/24(rw,async,no_wdelay,insecure,no_root_squash,insecure_locks,sec=sys:krb5i,anonuid=1025,anongid=100)	10.0.0.0/8(rw,async,no_wdelay,insecure,no_root_squash,insecure_locks,sec=sys:krb5i,anonuid=1025,anongid=100)
      '';
    };
}
