pkgs:
let
  # Additional packages for any system with X11
  uiPackages = if (builtins.pathExists /etc/X11) then
    with pkgs; [ emacs gitFull google-chrome synergy terminator vscode ]
  else
    [ ];
  hostname =
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile "/etc/hostname");
  localPath = ./. + "/hosts/${hostname}.nix";
  hostPackages = if (builtins.pathExists localPath) then
    (import localPath) pkgs
  else
    [ ];
  platformPackages = (import ./hosts/platform.nix) pkgs;
in uiPackages ++ hostPackages ++ platformPackages
