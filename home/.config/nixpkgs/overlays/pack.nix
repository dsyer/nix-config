self: super: {

  pack = super.stdenv.mkDerivation {
    pname = "pack";
    version = "0.13.1";
    src = super.fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/buildpacks/pack/releases/download/v0.13.1/pack-v0.13.1-linux.tgz";
      sha256 = "0z5vr8kp6l6zmzn23bpy3444906bygb323bc89vcfl16p80lwxwd";
    };
    phases = [ "installPhase" "patchPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cd $out/bin && tar -zxf $src
    '';
  };

}
