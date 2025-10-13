{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.nushell;
in {
  options.features.cli.nushell.enable = mkEnableOption "enable nushell";

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      envFile.text = ''
        $env.config.show_banner = false
        $env.NIX_PATH = "nixpkgs=channel:nixos-unstable"
        $env.NIX_LOG = "iunfo"
        $env.WEBKIT_DISABLE_COMPOSITING_MODE = "1"
        $env.TERMINAL = "kitty"
        $env.EDITOR = "nvim"
        $env.VISUAL = "zed"
        $env.FZF_DEFAULT_COMMAND = "fd --type f --exclude .git --follow --hidden"
        $env.FZF_DEFAULT_OPTS = "--preview='bat --color=always --style=numbers --line-range=:500 {}' --bind 'ctrl-/:toggle-preview' --header 'Press CTRL-Y to copy to clipboard' --bind 'ctrl-y:execute-silent(echo {} | wl-copy)' --color bg:#${config.colorScheme.palette.base00},bg+:#${config.colorScheme.palette.base02},fg:#${config.colorScheme.palette.base05},fg+:#${config.colorScheme.palette.base05},header:#${config.colorScheme.palette.base03},hl:#${config.colorScheme.palette.base0E},hl+:#${config.colorScheme.palette.base0E},info:#${config.colorScheme.palette.base09},marker:#${config.colorScheme.palette.base08},pointer:#${config.colorScheme.palette.base08},prompt:#${config.colorScheme.palette.base0B},spinner:#${config.colorScheme.palette.base09}"
        $env.XDG_DATA_HOME = $"($env.HOME)/.local/share"
        $env.FZF_DEFAULT_COMMAND = "fd --type f --exclude .git --follow --hidden"
        $env.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh"
        $env.FLAKE = $"($env.HOME)/p/nixos/nixos-config"
        source /run/agenix/${config.home.username}-secrets
      '';
      configFile.text = ''
        # FZF integration functions for nushell
        def fzf-file [] {
          fd --type f --exclude .git --follow --hidden | fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'ctrl-y:execute-silent(echo {} | wl-copy)'
        }

        def fzf-dir [] {
          fd --type d --exclude .git --follow --hidden | fzf --preview 'ls -la {}'
        }

        def fzf-history [] {
          history | get command | reverse | fzf --bind 'ctrl-y:execute-silent(echo {} | wl-copy)'
        }

        # Key bindings for FZF
        $env.config = {
          keybindings: [
            {
              name: fzf_file
              modifier: control
              keycode: char_t
              mode: [emacs, vi_normal, vi_insert]
              event: {
                send: executehostcommand
                cmd: "commandline edit --insert (fzf-file)"
              }
            }
            {
              name: fzf_history
              modifier: control
              keycode: char_r
              mode: [emacs, vi_normal, vi_insert]
              event: {
                send: executehostcommand
                cmd: "commandline edit --replace (fzf-history)"
              }
            }
          ]
        }

        if (tty) == "/dev/tty1" {
          exec uwsm start -S -F /run/current-system/sw/bin/Hyprland
        }
        if (tty) == "/dev/tty2" {
          exec gamescope -O HDMI-A-1 -W 1920 -H 1080 --adaptive-sync --hdr-enabled --rt --steam -- steam -pipewire-dmabuf -tenfoot
        }

        alias .. = cd ..
        alias ... = cd ...
        alias h = cd $env.HOME
        alias b = yazi
        alias lt = eza --tree --level=2 --long --icons --git
        alias grep = rg
        alias just = just --unstable

        alias n = nix
        alias nd = nix develop -c $nu.current-shell
        alias ns = nix shell
        alias nsn = nix shell nixpkgs#
        alias nb = nix build
        alias nbn = nix build nixpkgs#
        alias nf = nix flake

        alias nr = sudo nixos-rebuild --flake .
        alias nrs = sudo nixos-rebuild switch --flake .#(sys host | get hostname)
        alias snr = sudo nixos-rebuild --flake .
        alias snrs = sudo nixos-rebuild --flake . switch
        alias hm = home-manager --flake .
        alias hms = home-manager --flake . switch
        alias hmr = do { cd ~/projects/nix-configurations; nix flake lock --update-input dotfiles; home-manager --flake .#(whoami)@(hostname) switch }

        alias tsu = sudo tailscale up
        alias tsd = sudo tailscale down

        alias vi = nvim
        alias vim = nvim

        def history_fuzzy [] {
            let selected = (
                history
                | reverse
                | get command
                | uniq
                | to text
                | ^fzf
            )
            if ($selected | is-not-empty) {
                commandline edit ($selected)
            } else {
                null
            }
        }
        def --env dir_fuzzy [] {
            let selected = (
                fd --type directory
                | ^fzf
            )
            cd $selected
        }
        def find_fuzzy [] {
            # Find non-hidden text files with matches for any content and select one via fuzzy search
            let selected = (
                ^fd --type file --no-hidden -X rg -l --files-with-matches .
                | lines
                | to text
                | ^fzf
            )
            if ($selected | is-not-empty) {
                ^$env.EDITOR $selected
            }
        }

        $env.config = {
          keybindings: [
            {
              name: history_fuzzy
              modifier: control
              keycode: char_r
              mode: [emacs, vi_insert, vi_normal]
              event: [
                {
                  send: executehostcommand
                  cmd: "history_fuzzy"
                }
              ]
            }
            {
              name: dir_fuzzy
              modifier: alt
              keycode: char_c
              mode: [emacs, vi_insert, vi_normal]
              event: [
                {
                  send: executehostcommand
                  cmd: "dir_fuzzy"
                }
              ]
            }
            {
              name: history_fuzzy
              modifier: control
              keycode: char_t
              mode: [emacs, vi_insert, vi_normal]
              event: [
                {
                  send: executehostcommand
                  cmd: "find_fuzzy"
                }
              ]
            }
          ]
        }
      '';
    };
  };
}
