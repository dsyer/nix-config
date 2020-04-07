{ config, pkgs, ... }: {

environment.systemPackages = with pkgs; [
  jdk11
  nodejs-12_x
];

# Make VS Code work with a remote client
environment.loginShellInit = ''
  for f in $HOME/.vscode-server/bin/*; do 
    ln -nfs /run/current-system/sw/bin/node $f;
  done
'';

}