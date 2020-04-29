with (import <nixpkgs> { }); let
  hostname = builtins.replaceStrings ["\n"] [""] (builtins.readFile "/etc/hostname" );
  localPath = builtins.toPath ./. + "/${hostname}.nix";
  localPackages = if (builtins.pathExists localPath) then
    (import localPath).paths
  else
    [];
in {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -i user-packages`
        name = "user-packages";
        paths = localPackages ++ [
          dive
          docker-compose
          emacs
          envsubst
          gitAndTools.hub
          gitFull
          gnumake
          google-chrome
          google-cloud-sdk
          jq
          kind
          kubectl
          kustomize
          nixfmt
          qemu
          skaffold
          stow
          synergy
          terminator
          vscode
          yq
        ];
      };
    };
  allowUnfree = true;
}


