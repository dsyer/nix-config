self: super: {
  skaffold = super.skaffold.overrideAttrs (oldAttrs: rec {
    version = "1.10.1";
    rev = "931a70a6334436735bfc4ff7633232dd5fc73cc1";
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
      sha256 = "1qi4b0304jjpv5npa5yfrrfg7yv5p838qqql3sgx4f47ysyyq0as";
    };
  });
}
