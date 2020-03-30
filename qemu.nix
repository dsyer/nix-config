{ config, pkgs, ... }: {

  imports = [
    ./nix/base.nix
    ./nix/ssh.nix
  ];

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];

}