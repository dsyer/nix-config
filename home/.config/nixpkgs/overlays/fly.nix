self: super: {
  fly = let
    version = "7.8.3";
    src = self.fetchFromGitHub {
      owner = "concourse";
      repo = "concourse";
      rev = "v${version}";
      sha256 = "sha256-7r9/r6gj8u3r4R5UQIxpnmJ33SGfEAuOcqRLK11khfc=";
    };
  in super.fly.override {
    buildGoModule = args:
      super.pkgs.buildGoModule.override { go = super.pkgs.go; } (args // {
        inherit src version;
        vendorHash = "sha256-tEh1D/eczqLzuVQUcHE4+7Q74jM/yomdPDt6+TVJeew=";
        ldflags =
          [ "-s" "-w" "-X github.com/concourse/concourse.Version=${version}" ];
      });
  };
}
