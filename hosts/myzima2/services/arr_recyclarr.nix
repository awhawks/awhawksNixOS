{
  config,
  lib,
  pkgs,
  ...
}: {
    services.recyclarr = {
        # The recyclarr command to run (e.g., sync).
        command = "sync";
        # Recyclarr YAML configuration as a Nix attribute set.
        # For detailed configuration options and examples, see the official configuration reference.
        # The configuration is processed using utils.genJqSecretsReplacementSnippet to handle secret substitution.
        # To avoid permission issues, secrets should be provided via systemd’s credential mechanism:
        #
        # systemd.services.recyclarr.serviceConfig.LoadCredential = [
        #   "radarr-api_key:${config.sops.secrets.radarr-api_key.path}"
        # ];
        configuration = {};
        # Whether to enable recyclarr service.
        enable = false;
        # Group under which recyclarr runs.
        group = "recyclarr";
        # The recyclarr package to use.
        package = pkgs.recyclarr;
        # When to run recyclarr in systemd calendar format.
        schedule = "daily";
        # User account under which recyclarr runs.
        user = "recyclarr";
    };
}
