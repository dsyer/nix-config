self: super: {
  vscode = super.vscode.overrideAttrs (oldAttrs: rec {
    plat = "linux-x64";
    isInsiders = true;
    src = self.fetchurl {
      name = "VSCode_${version}_${plat}.tar.gz";
      url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
      sha256 = "0661qkcljxdpi5f6cyfqr8vyf87p94amzdspcg8hjrz18j1adb0h";
    };
    version = "1.75.1";
  });
}
