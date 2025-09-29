# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, outputs, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # This will add secrets.yml to the nix store
    # You can avoid this by adding a string to the full path instead, i.e.
    # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
    defaultSopsFile = ../../secrets/myzima1/secrets.yaml;
    validateSopsFiles = false;
    # This will automatically import SSH keys as age keys
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    # This is using an age key that is expected to already be in the filesystem
    #age.keyFile = "/var/lib/sops-nix/key.txt";
    # This will generate a new key if the key specified above does not exist
    #age.generateKey = false;
    # This is the actual specification of the secrets.
    secrets = {
        awhawks-hashed-password.neededForUsers = true;
        awhawks-hashed-password = {};
        root-hashed-password.neededForUsers = true;
        root-hashed-password = {};
        "private-keys/awhawks-ed25519-public" = {};
        "private-keys/awhawks-ed25519-private" = {};
        "private-keys/awhawks-rsa-public" = {};
        "private-keys/awhawks-rsa-private" = {};
    };
  };

  nix = {
    #package = pkgs.nixFlakes;
    settings = {
        #experimental-features = [ "nix-command" "flakes" ];
	    trusted-users = [ "root" "awhawks" ];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "myzima1"; # Define your hostname.
  networking.hostId = "31415926"; # CHANGE ME

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      X11Forwarding = true;
    };

  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.backup = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      ''command="${pkgs.rrsync}/bin/rrsync /rsync/backups/",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0E7DSiRlvqSjabsk79vISmj6Z1tEq4/MYIhFG1sngR''
    ];
  };
  users.users.awhawks = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.awhawks-hashed-password.path;
    description = "Adam W. Hawk";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
        inputs.home-manager.packages.${pkgs.system}.default
    ];
    openssh.authorizedKeys.keys =
    [
      # change this to your ssh key
      #( builtins.readFile config.sops.secrets."private-keys/awhawks-rsa-public".path )
      #( builtins.readFile config.sops.secrets."private-keys/awhawks-ed25519-public".path )
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0E7DSiRlvqSjabsk79vISmj6Z1tEq4/MYIhFG1sngR awhawks@p17"
    ];
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root-hashed-password.path;
    openssh.authorizedKeys.keys =
    [
      # change this to your ssh key
      #( builtins.readFile config.sops.secrets."private-keys/awhawks-rsa-public".path )
      #( builtins.readFile config.sops.secrets."private-keys/awhawks-ed25519-public".path )
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0E7DSiRlvqSjabsk79vISmj6Z1tEq4/MYIhFG1sngR awhawks@p17"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bcompare
    compose2nix
    disko
    dive
    file
    gh
    git
    git-lfs
    git-credential-manager
    htop
    nodejs_22
    podman
    podman-compose
    rrsync
    ssh-to-age
    unixtools.netstat
    unzip
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    zip
  ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
    users.awhawks =
      import ../../home/awhawks/${config.networking.hostName}.nix;
  };


  services.tailscale.enable = true;
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
  networking.search = [ "pufferfish-bellatrix.ts.net" ];

  services.headscale = {
    enable  = false;
    package = pkgs.headscale;
    address = "0.0.0.0";
    port    = 8080;
    user    = "headscale";
    group   = "headscale";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
