with (import <nixpkgs> { }); let
  localPackagePaths = (import ./packages.nix) pkgs;
  userPackagePaths = [
    dive
    docker-compose
    docker-credential-gcr
    dos2unix
    envsubst
    file
    gitAndTools.hub
    gnumake
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
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

