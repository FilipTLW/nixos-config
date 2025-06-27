{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    chaotic-nyx.url = "github:chaotic-cx/nyx/main";
    chaotic-nyx.inputs.home-manager.follows = "home-manager";

    garuda.url = "gitlab:garuda-linux/garuda-nix-subsystem/stable";
    garuda.inputs.nixpkgs.follows = "nixpkgs";
    garuda.inputs.chaotic-nyx.follows = "chaotic-nyx";

    nix-colors.url = "github:misterio77/nix-colors";

    nixvim.url = "github:nix-community/nixvim";

    hyprland.url = "github:hyprwm/Hyprland";

    vo1ded-panel.url = "github:FilipTLW/vo1ded-panel";
    vo1ded-panel.inputs.nixpkgs.follows = "nixpkgs";

    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # forgive me..
    vimix-cursors.url = "path:./subflakes/vimix-cursors";
  };

  outputs =

    {
      self,
      nixpkgs,
      garuda,
      lix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      nixosConfigurations = {
        filipnixos = garuda.lib.garudaSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            lix.nixosModules.default
            ./nixos/configuration.nix
          ];
        };
      };
      nixConfig = {
        access_tokens = {
          "github.com" = builtins.readFile "/home/filip/.secrets/nix-github-token";
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
