# Make VS Code work with a remote client
{ config, pkgs, ... }: {


environment.systemPackages = with pkgs; [
  nodejs-12_x
];

system.activationScripts.linkNode = ''
  ln -nfs /run/current-system/sw/bin/node /home/*/.vscode-server/bin/*/
'';

}