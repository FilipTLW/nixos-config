{ pkgs, lib, config, ... }:
{
  options.neovim-module = {
    enable = lib.mkEnableOption "enable neovim module"; theme = lib.mkOption {
      description = "neovim theme";
    };
  };
  
  config = lib.mkIf config.neovim-module.enable {
    programs.nixvim = {
      enable = true;

      globalOpts = {
      	number = true;
	relativenumber = true;
      };

      keymaps = [
        {
	  mode = "t";
	  action = "<C-\\><C-n>";
	  key = "<Esc>";
	}
	{
	  mode = "n";
	  action = ":below terminal<CR>";
	  key = "<Leader>t";
	}
	{
	  mode = "n";
	  action = ":NvimTreeFocus<CR>";
	  key = "<Leader>nt";
        }
	{
	  mode = "n";
	  action = ":NvimTreeFindFile<CR>";
	  key = "<Leader>nff";
	}
      ];

      globals = {
        mapleader = " ";
      };

      colorschemes.base16 = {
        enable = true;
        colorscheme = config.neovim-module.theme;
      };
      
      plugins = {
        lualine = {
          enable = true;
          settings = {
            sections = {
              lualine_a = ["mode"];
              lualine_b = ["branch"];
              lualine_c = ["filename"];
              lualine_x = ["encoding" "filetype"];
              lualine_y = ["progress"];
              lualine_z = ["location"];
            };
          };
        };

	nvim-tree = {
	  enable = true;
	  hijackCursor = true;
	};
        
	telescope = {
	  enable = true;
	};

	nix = {
	  enable = true;
	};

        treesitter = {
          enable = true;
          settings = {
            indent = {
              enable = true;
            };
            highlight = {
              enable = true;
            };
          };
          grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        };

        lsp = {
          enable = true;
          servers = {
            nixd = {
              enable = true;
              settings = 
                let
                  flake = ''(builtins.getFlake "/home/filip/git/nixos-config""'';
                in
                {
                  nixpkgs = {
                    expr = "import ${flake}.inputs.nixpkgs { }";
                  };
                  formatting = {
                    command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
                  };
                  options = {
                    nixos.expr = ''${flake}.nixosConfigurations.filip.options'';
                    home-manager.expr = "${flake}.nixosConfigurations.filip.home-manager.users.filip.options";
                  };
                };
            };
          };

          keymaps = {
            diagnostic = {
              "<leader>of" = "open_float";
            };
          };
        };

        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            mapping = {
              "<C-Space" = "cmp.mapping.complete()";
            };

            sources = [
              {
                name = "nvim_lsp";
                priority = 1000;
              }
              {
                name = "path";
                priority = 1000;
              }
              {
                name = "buffer";
                priority = 1000;
              }
              {
                name = "treesitter";
                priority = 850;
              }
            ];
          };
        };

      };
    };
  };
}
