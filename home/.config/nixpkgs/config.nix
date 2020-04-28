with (import <nixpkgs> { });
{
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -i user-packages`
        name = "user-packages";
        paths = [
          dive
          docker-compose
          emacs
          envsubst
          gitAndTools.hub
          gitFull
          gnumake
          google-chrome
          jq
          kind
          kubectl
          kustomize
          skaffold
          synergy
          terminator
          vim
          vscode
          yq
        ];
      };
    };
  allowUnfree = true;
}


