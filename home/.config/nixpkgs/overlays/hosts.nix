self: super:
let
  hostname =
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile "/etc/hostname");
  localPath = ./. + "/hosts/${hostname}.nix";
in
if (builtins.pathExists localPath) then (import localPath) self super else {}