{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.nitch;
in {
  options.features.cli.nitch.enable = mkEnableOption "enable nitch";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [nitch];
  };
}
