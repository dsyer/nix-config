with (import <nixpkgs> { });
{
  onHost = host: config:
    let
      name = builtins.replaceStrings [ "\n" ] [ "" ]
        (builtins.readFile "/etc/hostname");
    in if name == host then config else { };
  userPackagePaths = [
    dive
    docker-compose
    dos2unix
    envsubst
    file
    gitAndTools.hub
    gnumake
    google-cloud-sdk
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
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -i user-packages`
        name = "user-packages";
        paths = userPackagePaths;
      };
      nur = import (builtins.fetchTarball
        "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      # Conveniences, e.g. `nix-shell -p jdk14`:
      jdk14 = nur.repos.moaxcp.adoptopenjdk-hotspot-bin-14;
      spring-boot = nur.repos.moaxcp.spring-boot-cli-2_2_7;
    };
  allowUnfree = true;
}

