{ pkgs, ... }:

with pkgs;

stdenv.mkDerivation {
  pname = "skaffold";
  # skaffold is in nixpkgs but with an older version
  version = "1.9.1";
  src = fetchurl {
    # nix-prefetch-url this URL to find the hash value
    url =
      "https://storage.googleapis.com/skaffold/releases/v1.9.1/skaffold-linux-amd64";
    sha256 = "1rbk96kh4v955frmccbg9g1hqlgzzrn0zkmx9vpyxyywhfmdny30";
  };
  phases = [ "installPhase" "patchPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/skaffold
  '';
  patchPhase = ''
    chmod +x $out/bin/skaffold
  '';
}
