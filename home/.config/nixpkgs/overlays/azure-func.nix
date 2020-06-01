self: super: {
  azure-func = super.stdenv.mkDerivation {
    pname = "azure-func";
    version = "64.3.0";
    src = super.fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/Azure/azure-functions-core-tools/releases/download/3.0.2534/Azure.Functions.Cli.linux-x64.3.0.2534.zip";
      sha256 = "1sj4kgnbqklxnxl33nmqvzhkzs9rfffm7ibznyak5kb5pr1n4n7w";
    };
    phases = [ "installPhase" "patchPhase" ];
    nativeBuildInputs = [ super.unzip ];
    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/azure
      cd $out/azure && unzip $src
      ln -s $out/azure/func $out/azure/gozip $out/bin
    '';
    patchPhase = ''
      chmod +x $out/bin/*
    '';
    meta = with super.lib; {
      homepage = "https://github.com/Azure/azure-functions-core-tools";
      description = "Function command line experience for Azure. Normally used with azure-cli.";
      license = licenses.mit;
    };
  };
}
