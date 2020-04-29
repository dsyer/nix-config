# Additional packages for a qemu image with nixos
with (import <nixpkgs> { });
let
  uiPackages = if (builtins.pathExists /etc/X11) then [
    emacs
    gitFull
    google-chrome
    qemu
    synergy
    terminator
    vscode
  ] else
    [ ];
in { paths = uiPackages ++ [ git vim ]; }
