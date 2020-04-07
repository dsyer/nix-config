{ config, pkgs, ... }: {

environment.systemPackages = with pkgs; [
  gitAndTools.hub
  jdk11
  nodejs-12_x
];

environment.shellAliases = {
    git = "hub";
};

# Make VS Code work with a remote client
environment.loginShellInit = ''
  for f in $HOME/.vscode-server/bin/*; do 
    ln -nfs /run/current-system/sw/bin/node $f;
  done
'';

}