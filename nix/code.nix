# Install VS Code
{ config, pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
      # Make it work with a remote that is also running NixOS.
      # You need to launch code this way to make it work on a NixOS remote, or
      # else manually patch the remote by linking node (12) to ~/.vscode-server/bin/*/
      ms-vscode-remote.remote-ssh
    ])
    # ~/.nix-defexpr/channels/nixpkgs/pkgs/misc/vscode-extensions/update_installed_exts.sh | tee nix/extensions.nix
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./extensions.nix).extensions;
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
      vscodeExtensions = extensions;
  };
in {

  environment.systemPackages = with pkgs; [
    jdk11
    nodejs-12_x
    vscode-with-extensions
  ];

}