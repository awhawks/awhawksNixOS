{
  lib,
  stdenv,
  writeShellScriptBin,
}: let
  launcher = writeShellScriptBin "launch-webapp" ''
    #!/usr/bin/env bash

    browser=$(xdg-settings get default-web-browser)

    case "$browser" in
      google-chrome*) browser_bin="google-chrome" ;;
      brave-browser*) browser_bin="brave-browser" ;;
      microsoft-edge*) browser_bin="microsoft-edge" ;;
      opera*) browser_bin="opera" ;;
      vivaldi*) browser_bin="vivaldi" ;;
      *) browser_bin="chromium" ;;
    esac

    exec_cmd="/etc/profiles/per-user/$USER/bin/$browser_bin"
    exec setsid uwsm app -- "$exec_cmd" --app="$1" ''${@:2}
  '';
in
  stdenv.mkDerivation {
    pname = "launch-webapp";
    version = "0.1.0";

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${launcher}/bin/launch-webapp $out/bin/launch-webapp
    '';

    meta = with lib; {
      description = "Launches a web app using your default browser in app mode.";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [];
    };
  }
