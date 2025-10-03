{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.secrets;
in {
  options.features.cli.secrets.enable = mkEnableOption "enable secrets";

  config = mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      package =
        pkgs.pass-wayland.withExtensions
        (exts: [exts.pass-otp exts.pass-import]);
    };
    home.packages = with pkgs; [pinentry];
  };
}
