with (import <nixpkgs> { });
{
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -i user-packages`
        name = "user-packages";
        paths = [
          autorandr
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
          synergy
          terminator
          vscode
          yq
        ];
      };
    };
  allowUnfree = true;
}


