with (import <nixpkgs> { }); {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -iA nixpkgs.userPackages`
        name = "user-packages";
        paths = [
          dive
          docker-compose
          envsubst
          git
          gitAndTools.hub
          gnumake
          jq
          kind
          kubectl
          kustomize
          skaffold
          stow
          yq
        ];
      };
    };
  allowUnfree = true;
}
