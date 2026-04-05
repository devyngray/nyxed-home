{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nyxed-home-dev;

  prettierFmt = {
    command = "prettier";
    args = [
      "--stdin-filepath"
      "%{buffer_name}"
    ];
  };

  webLangs =
    map
      (name: {
        inherit name;
        auto-format = true;
        language-servers = [
          "typescript-language-server"
          "tailwindcss-ls"
          "vscode-eslint-language-server"
        ];
        formatter = prettierFmt;
      })
      [
        "javascript"
        "typescript"
        "jsx"
        "tsx"
      ];
in
{
  config = lib.mkIf cfg.enable {
    # language servers and formatters to globally install
    home.packages = [
      # nix
      pkgs.nixd
      pkgs.nixfmt

      # go
      pkgs.gopls

      # haskell
      pkgs.haskell-language-server

      # ocaml
      pkgs.ocamlPackages.ocaml-lsp
      pkgs.ocamlformat_0_26_2

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
      pkgs.vscode-langservers-extracted

      # markdown
      pkgs.marksman
      pkgs.python3Packages.mdformat
    ];

    programs.helix = {
      enable = true;
      defaultEditor = true;

      settings = {
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

      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "nixfmt";
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "rustfmt";
        }
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
        {
          name = "html";
          auto-format = true;
          language-servers = [ "vscode-html-language-server" ];
          formatter = prettierFmt;
        }
        {
          name = "css";
          auto-format = true;
          language-servers = [ "vscode-css-language-server" ];
          formatter = prettierFmt;
        }
        {
          name = "json";
          auto-format = true;
          language-servers = [ "vscode-json-language-server" ];
          formatter = prettierFmt;
        }
        {
          name = "ocaml";
          auto-format = true;
          formatter = {
            command = "ocamlformat";
            args = [
              "-"
              "--impl"
            ];
          };
        }
        {
          name = "markdown";
          auto-format = true;
          language-servers = [ "marksman" ];
          formatter = {
            command = "mdformat";
            args = [
              "--wrap"
              "80"
              "-"
            ];
          };
        }
      ]
      ++ webLangs;

      languages.language-server = {
        pylsp.config.pylsp.plugins = {
          autopep8.enabled = false;
          mccabe.enabled = false;
          pycodestyle.enabled = false;
          pyflakes.enabled = false;
          pylint.enabled = false;
          ruff.enabled = false;
          yapf.enabled = false;
        };

        rust-analyzer.config = {
          cargo.features = "all";
          check.command = "clippy";
        };
      };
    };
  };
}
