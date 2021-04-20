{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [ gitAndTools.hub jdk11 nodejs-12_x mono6 ];

  environment.shellAliases = { git = "hub"; };

  # Make VS Code work with a remote client
  environment.loginShellInit = ''
    if [ -d $HOME/.vscode-server/bin ]; then
      for f in $HOME/.vscode-server/bin/*; do 
        ln -nfs /run/current-system/sw/bin/node $f;
      done
    fi
    for f in $HOME/.vscode/extensions/ms-dotnettools.csharp-*/.omnisharp/*/bin; do
      ln -nfs /run/current-system/sw/bin/mono $f;
    done
  '';

}
