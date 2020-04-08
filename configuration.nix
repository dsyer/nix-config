{ config, pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  imports = [
    /etc/nixos/hardware-configuration.nix
    ./nix/base.nix
    ./nix/ssh.nix
    ./nix/remote.nix
  ];

  boot = {
    loader = {
      grub.enable = true;
      grub.version = 2;
      grub.device = "/dev/sda";
    };
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];

  environment.systemPackages = with pkgs [
    envsubst
    git
    gnumake
    stow
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
