{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nyxed-home-dev;
in
{
  config = lib.mkIf cfg.enable {
    # language servers and formatters to globally install
    home.packages = [
      # nix
      pkgs.nixd
      pkgs.nixfmt-rfc-style

      # go
      pkgs.gopls

      # haskell
      pkgs.haskell-language-server

      # python
      pkgs.ruff
      pkgs.python3Packages.python-lsp-server

      # rust
      pkgs.rust-analyzer
      pkgs.clippy
      pkgs.rustfmt

      # typescript
      pkgs.typescript-language-server
      pkgs.prettier

      # tailwind
      pkgs.tailwindcss-language-server

      # vscode-css-language-server
      # vscode-eslint-language-server
      # vscode-html-language-server
      # vscode-json-language-server
      # vscode-markdown-language-server
      pkgs.vscode-langservers-extracted
    ];

    # set helix to default editor
    programs.helix = {
      enable = true;
      defaultEditor = true;
    };

    # configure helix settings
    programs.helix.settings = {
      theme = "gruvbox";
      editor = {
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
        };
        file-picker = {
          hidden = false;
        };
        line-number = "relative";
        rulers = [ 120 ];
        whitespace = {
          render = "all";
        };
      };
      keys = {
        normal = {
          space = {
            F = "file_picker_in_current_directory";
            t = ":toggle-option lsp.display-inlay-hints";
          };
        };
      };
    };

    # setup auto-formatters
    programs.helix.languages.language = [
      # nix auto-format
      {
        name = "nix";
        auto-format = true;
        formatter.command = "nixfmt";
      }

      # rust auto-format
      {
        name = "rust";
        auto-format = true;
        formatter.command = "rustfmt";
      }

      # python auto-format
      {
        name = "python";
        auto-format = true;
        language-servers = [
          {
            name = "pylsp";
            except-features = [ "format" ];
          }
          "ruff"
        ];
      }

      # html lsp
      {
        name = "html";
        language-servers = [ "vscode-html-language-server" ];
        formatter = {
          command = "prettier";
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }

      # css lsp
      {
        name = "css";
        language-servers = [ "vscode-css-language-server" ];
        formatter = {
          command = "prettier";
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }

      # json lsp
      {
        name = "json";
        language-servers = [ "vscode-json-language-server" ];
        formatter = {
          command = "prettier";
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }

      # javascript lsp
      {
        name = "javascript";
        language-servers = [
          "typescript-language-server"
          "tailwindcss-ls"
          "vscode-eslint-language-server"
        ];
        formatter = {
          command = "prettier";
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }

      # typescript lsp
      {
        name = "typescript";
        language-servers = [
          "typescript-language-server"
          "tailwindcss-ls"
          "vscode-eslint-language-server"
        ];
        formatter = {
          command = "prettier";
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }

      # jsx lsp
      {
        name = "jsx";
        language-servers = [
          "typescript-language-server"
          "tailwindcss-ls"
          "vscode-eslint-language-server"
        ];
        formatter = {
          command = "prettier";
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }

      # tsx lsp
      {
        name = "tsx";
        language-servers = [
          "typescript-language-server"
          "tailwindcss-ls"
          "vscode-eslint-language-server"
        ];
        formatter = {
          command = "prettier";
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }
    ];

    # language-server overrides
    programs.helix.languages.language-server = {
      # disable python lsp plugins
      pylsp.config.pylsp.plugins = {
        autopep8.enabled = false;
        mccabe.enabled = false;
        pycodestyle.enabled = false;
        pyflakes.enabled = false;
        pylint.enabled = false;
        ruff.enabled = false;
        yapf.enabled = false;
      };

      # setup rust lsp
      rust-analyzer.config = {
        cargo.features = "all";
        check.command = "clippy";
      };
    };
  };
}
