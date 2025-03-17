with import <nixpkgs> { };
pkgs.mkShell {
  name = "test";
  buildInputs = [ nixos-generators google-cloud-sdk stow cmake ];
}
