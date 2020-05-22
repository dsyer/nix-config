self: super: {

  code-server = super.stdenv.mkDerivation {
    pname = "code-server";
    version = "3.3.1";
    src = super.fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-linux-amd64.tar.gz";
      sha256 = "0s99g8fzf41mmyqc1i0li14n9y1hzz8m72pffqky44gm41dqbfap";
    };
    phases = [ "installPhase" "patchPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cd $out && tar -zxf $src --strip-components=1
    '';
  };

}
