{
lib,
config,
...
}:
{
  options.fastfetch-module = {
    enable = lib.mkEnableOption "Enable Starship config";
  };
  
  config = lib.mkIf config.fastfetch-module.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos";
          color = {
            "1" = "38;5;127";
            "2" = "38;5;55";
          };
        };
        display = {
          separator = " ";
          size = {
            binaryPrefix = "si";
          };
          color = "1;38;5;201";
        };
        modules = [
          "title"
          {
            type = "os";
            key = " OS";
            keyColor = "1;38;5;201";
            format = "{name} {version}";
          }
          {
            type = "kernel";
            key = "├ Kernel";
            keyColor = "1;38;5;201";
          }
          {
            type = "packages";
            key = "├󰏖 Packages";
            keyColor = "1;38;5;201";
          }
          {
            type = "shell";
            key = "└ Shell";
            keyColor = "1;38;5;201";
          }
          "break"
          {
            type = "wm";
            key = "󰨇 WM";
            keyColor = "1;38;5;199";
          }
          {
            type = "theme";
            key = "├󰉼 Theme";
            keyColor = "1;38;5;199";
          }
          {
            type = "terminal";
            key = "├ Terminal";
            keyColor = "1;38;5;199";
          }
          {
            type = "terminalfont";
            key = "└ Terminal Font";
            keyColor = "1;38;5;199";
          }
          "break"
          {
            type = "host";
            key = "󰌢 Host";
            keyColor = "1;38;5;197";
          }
          {
            type = "display";
            key = "├󰍹 Display ({name})";
            keyColor = "1;38;5;197";
          }
          {
            type = "cpu";
            key = "├ CPU";
            keyColor = "1;38;5;197";
          }
          {
            type = "gpu";
            key = "├ GPU";
            keyColor = "1;38;5;197";
          }
          {
            type = "memory";
            key = "└ RAM";
            keyColor = "1;38;5;197";
          }
        ];
      };
    };
  };
}
