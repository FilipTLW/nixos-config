{ lib, config, pkgs, ... }:
let
  cfg = config.containers-module; 
in
{
  imports = [
    ./mariadb.nix
  ];

  options.containers-module = {
    enable = lib.mkEnableOption "enable containers module";
  };
  
  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";
    
    containers-module.mariadb.enable = true;
  };
}
