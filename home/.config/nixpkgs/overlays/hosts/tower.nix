self: super: {
  userPackagePaths = super.config.userPackagePaths
    ++ (with super; [ emacs gitFull google-chrome synergy terminator vscode ]);
}
