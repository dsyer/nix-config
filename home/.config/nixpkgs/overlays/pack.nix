self: super: {

  pack = super.stdenv.mkDerivation {
    pname = "pack";
    version = "0.23.0";
    src = super.fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/buildpacks/pack/releases/download/v0.23.0/pack-v0.23.0-linux.tgz";
      sha256 = "1vkm0fbk66k8bi5pf4hkmq7929y5av3lh0xj3wpapj2fry18j9yi";
    };
    phases = [ "installPhase" "patchPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cd $out/bin && tar -zxf $src
    '';
  };

}
