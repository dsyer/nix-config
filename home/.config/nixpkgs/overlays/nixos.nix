self: super:
with super;
super.config.onHost "nixos" (let
  # Additional packages for a qemu image with nixos
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
in {
  userPackagePaths = super.config.userPackagePaths ++ uiPackages
    ++ [ git vim ];
})
