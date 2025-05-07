{
lib,
config,
...
}:
{
  options.starship-module = {
    enable = lib.mkEnableOption "Enable Starship config";
  };
  
  config = lib.mkIf config.starship-module.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        format = lib.concatStrings [
          "[┌─> ](bold purple)$username[@](bold purple)[$hostname](bold purple) $os\n"
          "[│](bold purple) $directory$all"
          "[└─────](bold purple)$character"
        ];
        username = {
          show_always = true;
          style_root = "bold red";
          style_user = "bold bright-purple";
          format = "[$user]($style)";
        };
        hostname = {
          ssh_only = false;
          style = "bold bright-purple";
          format = "[$ssh_symbol$hostname]($style)";
        };
        os = {
          disabled = false;
          format = "[$symbol]($style)[$name $version](bright-cyan)";
        };
      };
    };
  };
}
