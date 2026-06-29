{ pkgs, inputs, ... }:

{
  programs.vscode = {
    enable  = true;
    package = pkgs.vscodium;

    profiles.default = {
      extensions = [
        inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace.monokai.theme-monokai-pro-vscode
        pkgs.vscode-extensions.jnoortheen.nix-ide
      ];

      userSettings = {
        "workbench.colorTheme" = "Monokai Pro";
        "update.mode"          = "none";
        "editor.fontSize"      = 18;
        "window.zoomLevel"     = 1;
      };
    };
  };

  programs.helix = {
    enable  = true;
    package = pkgs.helix;

    settings = {
      theme = "base16_transparent";    
    };

    extraPackages = [
      # Python
      pkgs.pyright # type checking
      pkgs.ruff    # fast formatting and linting
      
      # JavaScript / TypeScript
      pkgs.nodePackages.typescript-language-server # auto-complete, go-to-definition
      pkgs.typescript                              # required by typescript-language-server
      pkgs.biome                                   # formatting and linting

      pkgs.sqls    # auto-complete and SQL formatting
    ];

    languages = {
      language-server = {
        ruff = {
          command = "ruff";
          args = [ "server" ];
        };
        biome = {
          command = "biome";
          args = [ "lsp-proxy" ];
        };
      };

      language = [
        {
          name = "python";
          auto-format = true;
          language-servers = [ "pyright" "ruff" ];
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = [ "typescript-language-server" "biome" ];
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = [ "typescript-language-server" "biome" ];
        }
        {
          name = "sql";
          auto-format = true;
          language-servers = [ "sqls" ];
        }
      ];
    };
  };
}
