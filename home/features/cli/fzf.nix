{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.fzf;
in {
  options.features.cli.fzf.enable = mkEnableOption "enable fuzzy finder";

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      colors = {
        "fg" = "#${config.colorScheme.palette.base05}";
        "bg" = "#${config.colorScheme.palette.base00}";
        "hl" = "#${config.colorScheme.palette.base0E}";
        "fg+" = "#${config.colorScheme.palette.base05}";
        "bg+" = "#${config.colorScheme.palette.base02}";
        "hl+" = "#${config.colorScheme.palette.base0E}";
        "info" = "#${config.colorScheme.palette.base09}";
        "prompt" = "#${config.colorScheme.palette.base0B}";
        "pointer" = "#${config.colorScheme.palette.base08}";
        "marker" = "#${config.colorScheme.palette.base08}";
        "spinner" = "#${config.colorScheme.palette.base09}";
        "header" = "#${config.colorScheme.palette.base03}";
      };
      defaultOptions = [
        "--preview='bat --color=always -n {}'"
        "--bind 'ctrl-/:toggle-preview'"
        "--header 'Press CTRL-Y to copy command into clipboard'"
        "--bind 'ctrl-/:toggle-preview'"
        "--bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'"
      ];
      defaultCommand = "fd --type f --exclude .git --follow --hidden";
      changeDirWidgetCommand = "fd --type d --exclude .git --follow --hidden";
    };
  };
}
