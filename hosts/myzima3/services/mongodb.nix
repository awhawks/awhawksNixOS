{
  config,
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {

  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    user = "awhawks";
    enableAuth = true;
    initialRootPasswordFile = ../../../secrets/mongodb.age;
    bind_ip = "10.1.1.5";
    dbpath  = "/home/awhawks/mnt/mongodb/database";
    pidFile = "/home/awhawks/mnt/mongodb/mongodb.pid";
    extraConfig = ''
      net.port: 27017
      net.ipv6: false
      #net.bindIpAll: true
    '';
  };

  environment.systemPackages = with pkgs; [
      mongodb-cli
      # TODO mongodb-compass
      mongodb-tools
      mongosh
  ];

  networking.firewall.allowedTCPPorts = [
    27017
  ];

}
