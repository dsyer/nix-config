# Make VS Code work with a remote client
{ config, pkgs, ... }: {


environment.systemPackages = with pkgs; [
  nodejs-12_x
];

environment.loginShellInit = ''
  for f in $HOME/.vscode-server/bin/*; do 
    ln -nfs /run/current-system/sw/bin/node $f;
  done
'';

}