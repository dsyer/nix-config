{ config, pkgs, ... }: {

  imports = [ ./users.nix ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

}