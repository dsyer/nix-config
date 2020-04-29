{ config, pkgs, ... }: {

  imports = [ ./users.nix ];

  environment.loginShellInit = ''
    if [ -d $HOME/nix-config/dotfiles ]; then
      ln -nfs $HOME/nix-config/dotfiles/.??* $HOME
    fi
  '';

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

}