self: super: {
  vscode-insiders = super.vscode.overrideAttrs (oldAttrs: rec {
    # This doesn't actually work - the "code" binary is not executable
    isInsiders = true;
    src = self.fetchurl {
      url = "https://az764295.vo.msecnd.net/insider/1e446dfadf588ec28b3fdba7ac083bfa1d45df3c/code-insider-x64-1622525405.tar.gz";
      sha256 = "18ac59ysh0f95g0d4n4hq8a7x7p8rza070casmirq0cfszmq3a51";
    };
    version = "1.56.2";
  });
}
