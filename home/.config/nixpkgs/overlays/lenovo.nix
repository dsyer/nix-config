self: super:
super.config.onHost "lenovo" {
  userPackagePaths = super.config.userPackagePaths ++ (with super; [
    emacs
    gitFull
    google-chrome
    jdk11
    synergy
    terminator
    vscode
  ]);
}
