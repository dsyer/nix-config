{ config, pkgs, ... }: {
  imports = [ ./nix/base.nix ];
  config.virtualisation.googleComputeImage.diskSize = 8192;
}