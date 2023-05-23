self: super: {

  tanzu-cli = let
    version = "0.90.0-alpha.2";
  in super.stdenv.mkDerivation {
    pname = "tanzu-cli";
    version = "${version}";
    src = super.fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/vmware-tanzu/tanzu-cli/releases/download/v${version}/tanzu-cli-linux-amd64.tar.gz";
      sha256 = "sha256-K588aFd58N/zRNR1ThVN8GHcbkSo6V3xfMg48O7tLYg=";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      tar -zxf $src
      cp v${version}/tanzu-cli* $out/bin/tanzu
    '';
  };

}
