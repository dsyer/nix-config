self: super:
let
  hostname =
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile "/etc/hostname");
in if hostname == "carbon" then {
  userPackagesPaths = super.config.userPackagesPaths ++ (with super; [
    autorandr
    curl
    emacs
    gitFull
    google-chrome
    jdk11
    qemu
    terminator
    vscode
    zoom-us
  ]);
} else
  { }
