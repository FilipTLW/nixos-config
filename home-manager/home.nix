# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs, 
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./modules/hyprland.nix
    ./modules/kitty.nix
    ./modules/rofi.nix
  ];

  home = {
    username = "filip";
    homeDirectory = "/home/filip";
    
    packages = with pkgs; [
      vimix-cursors
    ];
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Filip Myslinski";
    userEmail = "filipmyslinski2006@gmail.com";
  };
  
  programs.brave = {
    enable = true;
    extensions = [
      { id = "aicmkgpgakddgnaphhhpliifpcfhicfo"; } # postman interceptor
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
    ];
  };
  
  hyprland-module.enable = true;
  rofi-module.enable = true;
  kitty-module.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  
  services.gnome-keyring.enable = true;
  
  home.pointerCursor = {
    name = "Vimix-cursors";
    package = pkgs.vimix-cursors;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Vimix-cursors";
    };
  };
  
  home.sessionVariables = {
      XCURSOR_THEME = "Vimix-cursors";
      XCURSOR_SIZE = "24";
    };
  
    # Apply changes
    home.activation.setCursor = config.lib.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
    '';

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
