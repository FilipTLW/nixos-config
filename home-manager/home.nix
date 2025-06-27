{
  nix-colors,
  nixvim,
  ags,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  nix-colors-lib = nix-colors.lib.contrib {inherit pkgs;};
  vo1ded-base16 = {
    base00 = "#291d44";
    base01 = "#392173";
    base02 = "#5a30a7";
    base03 = "#7645d9";
    base04 = "#8c6ce6";
    base05 = "#c6bcf6";
    base06 = "#dfdafa";
    base07 = "#edebfc";
    base08 = "#a959dc";
    base09 = "#fc9586";
    base0A = "#ceb55c";
    base0B = "#90d365";
    base0C = "#66de9b";
    base0D = "#69d0df";
    base0E = "#97b0ff";
    base0F = "#d592ff";
  };
in
{
  imports = [
    nix-colors.homeManagerModule
    nixvim.homeManagerModules.nixvim
    ./modules/hyprland.nix
    ./modules/kitty.nix
    ./modules/rofi.nix
    ./modules/neovim.nix
    ./modules/starship.nix
    ./modules/fastfetch.nix
  ];

  home = {
    username = "filip";
    homeDirectory = "/home/filip";

    packages = with pkgs; [
      vimix-cursors
      glib
      dconf
      swww
    ];
  };

  home.file.".config/swww/swww-init.sh" = {
    text = ''
      swww-daemon & sleep 0.1 & swww img ${config.home.homeDirectory}/.config/swww/wallpaper.png
    '';
    executable = true;
  };

  colorScheme = {
    slug = "vo1ded-dark";
    name = "vo1ded-dark";
    variant = "light";
    author = "Filip Myslinski (https://github.com/FilipTLW)";
    palette = vo1ded-base16;
  };

  neovim-module = {
    enable = true;
    theme = vo1ded-base16;
  };

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
  starship-module.enable = true;
  fastfetch-module.enable = true;

  systemd.user.startServices = "sd-switch";

  services.gnome-keyring.enable = true;

  home.pointerCursor = {
    enable = true;
    name = "Vimix-cursors";
    package = pkgs.vimix-cursors;
    size = 24;
    gtk.enable = true;
    x11 = {
      enable = true;
    };
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Vimix-cursors";
    XCURSOR_SIZE = "24";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "vo1ded-dark";
      package = nix-colors-lib.gtkThemeFromScheme {
        scheme = config.colorScheme;
      };
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = "1";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = "1";
    };
  };

  home.activation.setCursor = config.lib.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
  '';

  home.stateVersion = "24.05";
}
