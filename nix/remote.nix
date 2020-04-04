# Make VS Code work with a remote client
{ config, pkgs, ... }: {


environment.systemPackages = with pkgs; [
  nodejs-12_x
  vscode-extensions.ms-vscode-remote.remote-ssh
];

}