{ config, pkgs, ... }: {

  imports = [ ./nix/base.nix ];

  services.openssh = {
    enable = true;
    ports = [22];
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

}