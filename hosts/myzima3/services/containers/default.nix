{lib, inputs, ...}: {
  imports = [
    ./database_compose2nix/mydb2.nix
    #./database_compose2nix/mymongo.nix
  ];

  networking.firewall.allowedTCPPorts = [
    50000
    55000
    60006
    60007
    27017
  ];

}
