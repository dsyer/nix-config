with (import <nixpkgs> { }); {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -iA nixpkgs.userPackages`
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
