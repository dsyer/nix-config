self: super: {

  kapp = super.stdenv.mkDerivation {
    pname = "kapp";
    version = "0.25.0";
    src = super.fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/k14s/kapp/releases/download/v0.25.0/kapp-linux-amd64";
      sha256 = "1pjk2fyaai4gnv5r2fcg2y07xaxlssczpbs1c64d93lfzdnhwxlv";
    };
    phases = [ "installPhase" "patchPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/kapp
    '';
    patchPhase = ''
      chmod +x $out/bin/kapp
    '';
  };

}
