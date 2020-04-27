with import <nixpkgs> { };
pkgs.mkShell {
  name = "test";
  buildInputs = [ nixos-generators google-cloud-sdk ]
    ++ (callPackage ./nix/code.nix { }).environment.systemPackages;
}
