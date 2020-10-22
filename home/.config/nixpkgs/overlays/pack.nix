self: super: {

  pack = super.stdenv.mkDerivation {
    pname = "pack";
    version = "0.14.2";
    src = super.fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/buildpacks/pack/releases/download/v0.14.2/pack-v0.14.2-linux.tgz";
      sha256 = "06xbqs34r26qvmkqwmxfgxsbxvckg4ryw05hbdkjyp41dw86q5yb";
    };
    phases = [ "installPhase" "patchPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cd $out/bin && tar -zxf $src
    '';
  };

}
