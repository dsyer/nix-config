self: super: {
  skaffold = super.skaffold.overrideAttrs (oldAttrs: rec {
    version = "1.9.1";
    rev = "7bac6a150c9618465f5ad38cc0a5dbc4677c39ba";
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
      sha256 = "0l0x89xv5brinafrvbz6hgs5kvmpl4ajcrsjdjh3myf7i0mvh3gm";
    };
  });
}
