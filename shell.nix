with import <nixpkgs> { };
pkgs.mkShell {
  name = "test";
  buildInputs = [ nixos-generators ]
    ++ (callPackage ./nix/code.nix { }).environment.systemPackages;
}
