{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.crypto;
in {
  options.features.desktop.crypto.enable = mkEnableOption "Enable Crypto";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [bisq2 monero-gui trezor-suite];
  };
}
