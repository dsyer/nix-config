with (import <nixpkgs> { }); let
  localPackagePaths = (import ./packages.nix) pkgs;
  userPackagePaths = [
    dive
    docker-credential-gcr
    dos2unix
    envsubst
    file
    # (with google-cloud-sdk; withExtraComponents [components.gke-gcloud-auth-plugin])
    gitAndTools.hub
    gnumake
    jq
    kapp
    kind
    kubectl
    kustomize
    nixfmt
    skaffold
    stow
    unzip
    yq
    zip
  ];
in
rec {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -i user-packages`
        name = "user-packages";
        paths = userPackagePaths ++ localPackagePaths;
      };
    };
  allowUnfree = true;
}

