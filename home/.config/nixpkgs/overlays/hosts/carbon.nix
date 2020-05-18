self: super: {
  userPackagePaths = super.config.userPackagePaths ++ (with super; [
    autorandr
    curl
    emacs
    gitFull
    google-chrome
    jdk11
    qemu
    terminator
    vscode
    zoom-us
  ]);
}
