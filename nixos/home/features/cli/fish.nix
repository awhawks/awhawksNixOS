{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.fish;
in {
  options.features.cli.fish.enable = mkEnableOption "enable fish shell";

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        # Fish colors using universal nix-colors palette
        # Text colors
        set -g fish_color_normal ${config.colorScheme.palette.base05}      # text
        set -g fish_color_param ${config.colorScheme.palette.base05}       # text
        set -g fish_color_comment ${config.colorScheme.palette.base03}     # muted
        set -g fish_color_autosuggestion ${config.colorScheme.palette.base03} # muted

        # Command colors
        set -g fish_color_command ${config.colorScheme.palette.base0D}     # accent6 (blue)
        set -g fish_color_quote ${config.colorScheme.palette.base0A}       # accent3 (yellow)
        set -g fish_color_redirection ${config.colorScheme.palette.base0E} # accent7 (purple)
        set -g fish_color_end ${config.colorScheme.palette.base08}         # accent1 (red)
        set -g fish_color_error ${config.colorScheme.palette.base08}       # accent1 (red)
        set -g fish_color_operator ${config.colorScheme.palette.base0C}    # accent5 (cyan)
        set -g fish_color_escape ${config.colorScheme.palette.base09}      # accent2 (orange)

        # Path colors
        set -g fish_color_cwd ${config.colorScheme.palette.base0B}         # accent4 (green)
        set -g fish_color_cwd_root ${config.colorScheme.palette.base08}    # accent1 (red)
        set -g fish_color_valid_path --underline

        # Interactive colors
        set -g fish_color_match ${config.colorScheme.palette.base0B}       # accent4 (green)
        set -g fish_color_selection --background=${config.colorScheme.palette.base02} # overlay
        set -g fish_color_search_match --background=${config.colorScheme.palette.base02} # overlay
        set -g fish_color_history_current --bold
        set -g fish_color_user ${config.colorScheme.palette.base0B}        # accent4 (green)
        set -g fish_color_host ${config.colorScheme.palette.base0D}        # accent6 (blue)
        set -g fish_color_cancel -r

        # Pager colors
        set -g fish_pager_color_completion normal
        set -g fish_pager_color_description ${config.colorScheme.palette.base03} # muted
        set -g fish_pager_color_prefix ${config.colorScheme.palette.base0E}      # accent7 (purple)
        set -g fish_pager_color_progress ${config.colorScheme.palette.base0B}    # accent4 (green)
      '';
      loginShellInit = ''
        set -x NIX_PATH nixpkgs=channel:nixos-unstable
        set -x NIX_LOG info
        set -x WEBKIT_DISABLE_COMPOSITING_MODE 1
        set -x TERMINAL kitty
        set -x EDITOR nvim
        set -x VISUAL zed
        set -x XDG_DATA_HOME $HOME/.local/share
        set -x FZF_CTRL_R_OPTS "
        --preview='bat --color=always -n {}'
        --preview-window up:3:hidden:wrap
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
        --color header:bold
        --header 'Press CTRL-Y to copy command into clipboard'"
        set -x FZF_DEFAULT_COMMAND fd --type f --exclude .git --follow --hidden
        set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -x FLAKE $HOME/p/nixos/nixos-config
        source /run/agenix/${config.home.username}-secrets

        if test (tty) = "/dev/tty1"
          exec uwsm start -S -F /run/current-system/sw/bin/Hyprland
        end
        if test (tty) = "/dev/tty2"
          exec gamescope -O HDMI-A-1 -W 1920 -H 1080 --adaptive-sync --hdr-enabled --rt --steam -- steam -pipewire-dmabuf -tenfoot
        end
      '';
      shellAbbrs = {
        ".." = "cd ..";
        "..." = "cd ../..";
        b = "yazi";
        ls = "eza";
        l = "eza -l --icons --git -a";
        lt = "eza --tree --level=2 --long --icons --git";
        grep = "rg";
        ps = "procs";
        just = "just --unstable";
        fs = "du -ah . | sort -hr | head -n 10";

        n = "nix";
        nd = "nix develop -c $SHELL";
        ns = "nix shell";
        nsn = "nix shell nixpkgs#";
        nb = "nix build";
        nbn = "nix build nixpkgs#";
        nf = "nix flake";

        nr = "sudo nixos-rebuild --flake .";
        nrs = "sudo nixos-rebuild switch --flake .#(uname -n)";
        snr = "sudo nixos-rebuild --flake .";
        snrs = "sudo nixos-rebuild --flake . switch";
        hm = "home-manager --flake .";
        hms = "home-manager --flake . switch";
        hmr = "cd ~/projects/nix-configurations; nix flake lock --update-input dotfiles; home-manager --flake .#(whoami)@(hostname) switch";

        tsu = "sudo tailscale up";
        tsd = "sudo tailscale down";

        vi = "nvim";
        vim = "nvim";
      };
    };
  };
}
