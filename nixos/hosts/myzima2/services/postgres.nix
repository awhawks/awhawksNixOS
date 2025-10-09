{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    package = pkgs.postgresql_17;
    extensions = with pkgs.postgresql17Packages; [
      pgvector
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      # Local connections (Unix socket)
      local   all         postgres    peer
      local   paperless   paperless   scram-sha-256

      # Localhost connections (IPv4 and IPv6)
      host    all          postgres     127.0.0.1/32    scram-sha-256
      host    all          postgres     ::1/128         scram-sha-256
      host    outline      outline      127.0.0.1/32    scram-sha-256
      host    outline      outline      ::1/128         scram-sha-256
      host    paperless    paperless    127.0.0.1/32    scram-sha-256
      host    paperless    paperless    ::1/128         scram-sha-256

      # Podman network connections for Baserow
      host    baserow      baserow      10.89.0.0/24    scram-sha-256
      host    kestra       kestra       10.89.0.0/24    scram-sha-256

      # Deny all other connections
      local   all       all       reject
      host    all       all       0.0.0.0/0      reject
      host    all       all       ::/0           reject
    '';
  };
  services.postgresqlBackup = {
    enable = true;
    startAt = "03:10:00";
    databases = ["baserow" "paperless" "kestra"];
  };
  networking.firewall = {
    extraCommands = ''
      iptables -A INPUT -p tcp -s 127.0.0.1 --dport 5432 -j ACCEPT
      iptables -A INPUT -p tcp -s 10.89.0.0/24 --dport 5432 -j ACCEPT
    '';
  };
}
