{ config, pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  networking.hostName = "carbon";
  networking.extraHosts = "192.168.2.19 tower";
  networking.networkmanager.enable = true;

  imports = [
    /etc/nixos/hardware-configuration.nix
    ../packages/base.nix
    ../packages/ssh.nix
    ../packages/remote.nix
    ../packages/ui.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.synergy.client.enable = true;
  services.synergy.client.screenName = "carbon";
  services.synergy.client.serverAddress = "tower";

  services.printing.enable = true;
  
  environment.systemPackages = with pkgs; [ envsubst git gnumake stow vim ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
