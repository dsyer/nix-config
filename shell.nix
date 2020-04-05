with import <nixpkgs> {};
pkgs.mkShell {
    name = "test";
    buildInputs = [
    ] ++ (callPackage ./nix/code.nix {}).environment.systemPackages;
}