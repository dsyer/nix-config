# Make VS Code work with a remote client
{ config, pkgs, ... }: {


environment.systemPackages = with pkgs; [
  nodejs-12_x
];

environment.loginShellInit = ''
  if [ -f $HOME/.vscode-server/bin/*/node ]; then
    ln -nfs /run/current-system/sw/bin/node $HOME/.vscode-server/bin/*/;
  fi
'';

}