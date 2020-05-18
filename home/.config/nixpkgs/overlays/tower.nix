self: super:
super.config.onHost "tower" {
  userPackagePaths = super.config.userPackagePaths
    ++ (with super; [ emacs gitFull google-chrome synergy terminator vscode ]);
}
