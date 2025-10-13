{
  lib,
  stdenv,
  writeShellScriptBin,
  fd,
  hyprland,
  coreutils,
  gawk,
}: let
  script = writeShellScriptBin "hyprpaper-random" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Directory (override with WALLPAPER_DIR)
    DIR="''${WALLPAPER_DIR:-''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/wallpapers}"

    HYPRCTL="${hyprland}/bin/hyprctl"
    FD="${fd}/bin/fd"
    SHUF="${coreutils}/bin/shuf"
    TR="${coreutils}/bin/tr"
    AWK="${gawk}/bin/awk"

    # Pick one random image (null-safe)
    WALLPAPER="$(
      "$FD" . "$DIR" -t f -e jpg -e jpeg -e png -e webp -e avif -0 --follow --hidden \
        | "$SHUF" -z -n1 \
        | "$TR" -d '\0'
    )"

    if [[ -z "''${WALLPAPER:-}" ]]; then
      echo "No wallpapers found in: $DIR" >&2
      exit 1
    fi

    # Preload so hyprpaper can use it
    "$HYPRCTL" hyprpaper preload "$WALLPAPER" >/dev/null 2>&1 || true

    # Apply to all monitors
    "$HYPRCTL" monitors \
      | "$AWK" '/^Monitor /{print $2}' \
      | while IFS= read -r mon; do
          [ -n "$mon" ] && "$HYPRCTL" hyprpaper wallpaper "$mon,$WALLPAPER"
        done

    exit 0
  '';
in
  stdenv.mkDerivation {
    pname = "hyprpaper-random";
    version = "0.1.1";

    dontUnpack = true;

    buildInputs = [
      fd
      hyprland
      coreutils
      gawk
    ];

    installPhase = ''
      mkdir -p "$out/bin"
      ln -s ${script}/bin/hyprpaper-random "$out/bin/hyprpaper-random"
    '';

    meta = with lib; {
      description = "Minimal random wallpaper setter for Hyprpaper";
      license = licenses.mit;
      platforms = platforms.linux;
      mainProgram = "hyprpaper-random";
    };
  }
