with (import <nixpkgs> { });
let
  hostname =
    builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile "/etc/hostname");
  localPath = ./. + "/${hostname}.nix";
  localPackages =
    if (builtins.pathExists localPath) then (import localPath).paths else [ ];
in {
  packageOverrides = pkgs:
    with pkgs; {
      userPackages = buildEnv {
        # Apply with `nix-env -i user-packages`
        name = "user-packages";
        paths = localPackages ++ [
          dive
          docker-compose
          envsubst
          gitAndTools.hub
          gnumake
          google-cloud-sdk
          jq
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

