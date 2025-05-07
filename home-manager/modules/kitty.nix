{
pkgs,
lib,
config,
...
}:
{
  options.kitty-module = {
    enable = lib.mkEnableOption "Enable kitty terminal module";
  };
  
  config = lib.mkIf config.kitty-module.enable {
    home.packages = with pkgs; [
      kitty
    ];
    
    home.file.".config/kitty/kitty.conf".text = ''
    
    font_family           JetBrainsMono Nerd Font 
    bold_font             auto
    italic_font           auto
    bold_italic_font      auto
    
    background            #291d44
    background_opacity    0.5
    '';
  };
}