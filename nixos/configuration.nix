# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    devices = [ "/dev/sda" ];
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  hardware.bluetooth.package = pkgs.bluez;
  hardware.bluetooth.settings.General.Experimental = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.awhawks = {
    isNormalUser = true;
    description = "Adam W. Hawks";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "awhawks";

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bcompare
    bluez
    disko
    firefox
    feh
    gedit
    gh
    github-desktop
    google-chrome
    htop
    jetbrains.idea-community
    jetbrains.idea-ultimate
    qemu
    thunderbird
    unzip
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    virt-manager
    virtualbox
    wget
    wireshark
    zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfFOyKVv39QZb5DZOGL25xrOqqdHlFOi/q0f+MMlCOhptWHqpjKcc4pWDG1Sbh+X8jXQtxlPQs0/CYAwsN8EICzOzdd+8QqYThiCXykPnXOHuwsw6pCAVKbXTpKuXZdYslVOG+MbKDVpWEq6YYQ9zhe8YS5aCB6PK2SqOVD3kvOxHFKZucVBylHZweDMFkO7hhCrNPFoX2liUwwjJ7j16czu6wr68zuGCEZo5/eeVXjvu9J0ruvejPRVCgAVyAHC0OFrtHxftOcy+ZNbEtSlL012IggBsj6YDv8e2QOoHwiicMTdt8Z8HX+BFH68oVXwP3v8qhc3bZqJ+wGVvisA/9 build@fyre"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1G3FPPl3r7NJniV9qy1KBcDLsdoxlllGMrWR/W470nQobi5bbM5eY6fzueLbBi46/0PoNPToaBUlpdmFuEMm0NJFn285oCtRclShTQuktK2VguNkHwBT4MTkGHgRHjfxI/NjvE0jUpEK3/NYRnHBf4iAqtp4KkjyB1Yf/apVsB0mq3im+GObzE31mIJzXya/wgJWvLu0jkC9dvLuEbOi2oj8zl7Yw1NWN1r4+gV+qURi5U2Kccz0OquH2p5DnA+v8jvS6uWbVMrnsHh5usD2fFyOWLBBL/PmW5e2cq2vcDpPxPBQ+G9w9/oKjFzhTKjqN7VD371M/m7aVxwbxTj1F awhawks@p17"
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}