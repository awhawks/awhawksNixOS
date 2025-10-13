{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.coding;
in {
  options.features.desktop.coding.enable =
    mkEnableOption "install coding related stuff";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bruno
      insomnia
    ];

    programs.zed-editor = {
      enable = true;
      userSettings = {
        features = {
          inline_prediction_provider = "zed";
          edit_prediction_provider = "zed";
          copilot = false;
        };
        telemetry = {
          metrics = false;
        };
        lsp = {
          rust_analyzer = {
            binary = {path_lookup = true;};
          };
        };
        languages = {
          Nix = {
            language_servers = ["nixd"];
            formatter = {
              external = {
                command = "alejandra";
                arguments = ["-q" "-"];
              };
            };
          };
          Python = {
            language_servers = ["pyrefly"];
            formatter = {
              external = {
                command = "black";
                arguments = ["-"];
              };
            };
          };
        };
        lsp = {
          "pyrefly" = {
            command = {
              path = "pyrefly";
              args = ["--lsp"];
              env = {};
            };
            settings = {};
          };
        };
        context_servers = {
          "some-context-server" = {
            command = {
              path = "some-command";
              args = ["arg-1" "arg-2"];
              env = {};
            };
            settings = {};
          };
        };
        assistant = {
          version = "2";
          default_model = {
            provider = "anthropic";
            model = "Claude 3.7 Sonnet";
          };
        };
        language_models = {
          anthropic = {
            version = "1";
            api_url = "https://api.anthropic.com";
          };
          openai = {
            version = "1";
            api_url = "https://api.openai.com/v1";
          };
          ollama = {
            api_url = "http://localhost:11434";
          };
        };
        ssh_connections = [
          {
            host = "152.53.85.162";
            nickname = "m3-atlas";
            args = ["-i" "~/.ssh/m3tam3re"];
          }
          {
            host = "95.217.189.186";
            port = 2222;
            nickname = "self-host-playbook";
            args = ["-i" "~/.ssh/self-host-playbook"];
            "projects" = [
              {
                paths = ["/etc/nixos/current-systemconfig"];
              }
            ];
          }
          {
            host = "192.168.1.152";
            port = 22;
            nickname = "m3-daedalus";
            args = ["-i" "~/.ssh/m3tam3re"];
            "projects" = [
              {
                paths = ["/home/m3tam3re/home-config"];
              }
            ];
          }
        ];
        auto_update = false;
        format_on_save = "on";
        vim_mode = true;
        load_direnv = "shell_hook";
        theme = "Dracula";
        buffer_font_family = "FiraCode Nerd Font";
        ui_font_size = 16;
        buffer_font_size = 16;
        show_edit_predictions = true;
      };
    };
  };
}
