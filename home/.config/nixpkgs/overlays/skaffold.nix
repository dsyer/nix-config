self: super: {
  skaffold = super.skaffold.overrideAttrs (oldAttrs: rec {
    version = "1.11.0";
    rev = "b1346ef1caded079c5abf11e5c0daae2322c9c6b";
    buildFlagsArray = let t = "${oldAttrs.goPackagePath}/pkg/skaffold";
    in ''
      -ldflags=
        -X ${t}/version.version=v${version}
        -X ${t}/version.gitCommit=${rev}
        -X ${t}/version.buildDate=unknown
    '';
    src = self.fetchFromGitHub {
      owner = "GoogleContainerTools";
      repo = "skaffold";
      rev = "v${version}";
      sha256 = "035xp34m8kzb75mivgf3kw026n2h6g2a7j2mi32nxl1a794w36zi";
    };
  });
}
