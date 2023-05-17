self: super: {
  # Works only with nix-shell, not nix-env
  gcloud = with super.google-cloud-sdk; withExtraComponents [components.gke-gcloud-auth-plugin];
}