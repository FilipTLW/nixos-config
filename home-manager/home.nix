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
  ];

  home = {
    username = "filip";
    homeDirectory = "/home/filip";
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
  hyprland-module.rofi.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
