{ config, pkgs, ... }: {
  imports = [ ../packages/base.nix ];
  config.virtualisation.googleComputeImage.diskSize = 8192;
}