self: super: {

  tanzu-cli = super.stdenv.mkDerivation {
    pname = "tanzu-cli";
    version = "0.90.0-alpha.2";
    src = super.fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/vmware-tanzu/tanzu-cli/releases/download/v0.90.0-alpha.2/tanzu-cli-linux-amd64.tar.gz";
      sha256 = "sha256-K588aFd58N/zRNR1ThVN8GHcbkSo6V3xfMg48O7tLYg=";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      tar -zxf $src
      cp v0.90.0-alpha.2/tanzu-cli* $out/bin/tanzu
    '';
  };

}
