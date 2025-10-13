{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.zellij;
in {
  options.features.cli.zellij.enable = mkEnableOption "enable tmux";

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "universal";
        themes.universal = {
          bg = "#${config.colorScheme.palette.base00}";
          fg = "#${config.colorScheme.palette.base05}";
          black = "#${config.colorScheme.palette.base01}";
          red = "#${config.colorScheme.palette.base08}";
          green = "#${config.colorScheme.palette.base0B}";
          yellow = "#${config.colorScheme.palette.base0A}";
          blue = "#${config.colorScheme.palette.base0D}";
          magenta = "#${config.colorScheme.palette.base0E}";
          cyan = "#${config.colorScheme.palette.base0C}";
          white = "#${config.colorScheme.palette.base07}";
          orange = "#${config.colorScheme.palette.base09}";
        };
      };
    };
  };
}
