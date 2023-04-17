{ config, pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [ gitAndTools.hub jdk17 nodejs-16_x mono6 wget ];

  environment.shellAliases = { git = "hub"; };

  imports = [
    (fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master")
  ];

  services.vscode-server.enable = true;

}
