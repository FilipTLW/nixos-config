{ lib, config, pkgs, ... }:
let
  cfg = config.user; 
in
{
  options.user = {
    enable = lib.mkEnableOption "enable user module";
    
    username = lib.mkOption {
      default = "user";
      description = "username";
    };
    
    sudoer = lib.mkEnableOption "user is a sudoer";
    
    useHomeManager = lib.mkEnableOption "use home manager";
    
    homeManagerConfig = lib.mkOption {
      default = "";
      description = "home-manager config file";
    };
  };
  
  config = lib.mkIf cfg.enable {
    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = lib.mkIf cfg.sudoer [ "wheel" "audio" ];
    };
    
    home-manager.users.${cfg.username} = lib.mkIf cfg.useHomeManager (import cfg.homeManagerConfig);
  };
}
