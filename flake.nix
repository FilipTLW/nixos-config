{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
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
    
    # Home manager
    
    hyprland.url = "github:hyprwm/Hyprland";
       
    vo1ded-panel.url = "github:FilipTLW/vo1ded-panel";
    vo1ded-panel.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
  
    {
      self,
      nixpkgs,
      garuda,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      
      nixosConfigurations = {
        # FIXME replace with your hostname
        filipnixos = garuda.lib.garudaSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          # > Our main nixos configuration file <
          modules = [ ./nixos/configuration.nix ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      #homeConfigurations = {
      #  # FIXME replace with your username@hostname
      #  "filip@filipnixos" = home-manager.lib.homeManagerConfiguration {
      #    pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      #    extraSpecialArgs = {
      #      inherit nix-colors;
      #    };
      #    # > Our main home-manager configuration file <
      #    modules = [ 
      #      #nix-colors.homeManagerModules.default 
      #      ./home-manager/home.nix 
      #    ];
      # };
      #};
    };
}
