# Install VS Code and make it work with a remote that is also running NixOS.
# You need to launch code this way to make it work on a NixOS remote, or
# else manually patch the remote by linking node (12) to ~/.vscode-server/bin/*/
{ config, pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-ssh
    ]);
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
      vscodeExtensions = extensions;
  };
in {

  environment.systemPackages = with pkgs; [
    nodejs-12_x
    vscode-with-extensions
  ];

}