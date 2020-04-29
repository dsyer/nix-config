{ config, lib, pkgs, modulesPath, ... }: {

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