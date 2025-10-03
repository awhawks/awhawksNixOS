{
  imports = [
    ../common
    ../features/cli
    ./home-server.nix
  ];

  features = {
    cli = {
      secrets.enable = false;
    };
  };
}
