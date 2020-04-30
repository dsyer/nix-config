with (import <nixpkgs> { });
let
  hostname =
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile "/etc/hostname");
  localPath = ./. + "/${hostname}.nix";
  localPackages =
    if (builtins.pathExists localPath) then (import localPath).paths else [ ];
  kapp = import ./packages/kapp.nix { inherit pkgs; };
in {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -i user-packages`
        name = "user-packages";
        paths = localPackages ++ [
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
          yq
        ];
      };
    };
  allowUnfree = true;
}

