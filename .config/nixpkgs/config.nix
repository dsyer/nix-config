with (import <nixpkgs> { }); {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -i user-packages`
        name = "user-packages";
        paths = [
          dive
          docker-compose
          gitAndTools.hub
          jq
          kind
          kubectl
          kustomize
          skaffold
          vim
          yq
        ];
      };
    };
  allowUnfree = true;
}
