{ config, pkgs, ... }: {

  imports = [
    ../packages/base.nix
    ../packages/ssh.nix
  ];

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];

}