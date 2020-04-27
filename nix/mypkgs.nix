{ pkgs ? import <nixpkgs> {}, ... } :
pkgs.buildEnv {
    # To install in a user profile: `nix-build nix/mypkgs.nix` and `nix-env -i /nix/store/...`
    name = "mypkgs";
    paths = with pkgs; [
        dive
        docker-compose
        git
        gitAndTools.hub
        jq
        kind
        kubectl
        kustomize
        skaffold
        stow
        vim
        yq
    ];
}