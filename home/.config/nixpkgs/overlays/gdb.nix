self: super: {
  gdb-8 = super.gdb.overrideAttrs (oldAttrs: rec {
    version = "8.3.1";
    basename = "gdb-${version}";
    name = super.lib.optionalString
      (super.stdenv.targetPlatform != super.stdenv.hostPlatform)
      (super.stdenv.targetPlatform.config + "-") + basename;
    preConfigure = "";
    configureScript = null;
    readline = super.readline;
    patches = [ ./patches/debug-info-from-env.patch ]
      ++ super.lib.optionals super.stdenv.isDarwin [ ./patches/darwin-target-match.patch ];
    src = self.fetchurl {
      url = "mirror://gnu/gdb/${basename}.tar.xz";
      # sha256 = "0mf5fn8v937qwnal4ykn3ji1y2sxk0fa1yfqi679hxmpg6pdf31n"; # 9.2
      sha256 = "1i2pjwaafrlz7wqm40b4znr77ai32rjsxkpl2az38yyarpbv8m8y"; # 8.3.1
    };
  });
}
