{
lib,
config,
pkgs,
...
}:
{
  options.hyprland-module = {
    enable = lib.mkEnableOption "Enable Hyprland config";
  };

  config = let
    additional_binds = if config.rofi-module.enable then [
      "$mainMod, space, exec, rofi -show run"
    ] else [];
  in
  lib.mkIf config.hyprland-module.enable {

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {

      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$mainMod" = "SUPER";

      monitor = [ "DP-1,2560x1440@165,0x0,1" "DP-2,2560x1440@165,2560x0,1" ];
      general = {
        border_size = 2;
        gaps_in = 5;
        gaps_out = 10;
        gaps_workspaces = 50;
        "col.inactive_border" = "rgba(595959aa)";
        "col.active_border" = "rgba(860ac9ff) rgba(0ab0c9cc) 45deg";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;

        active_opacity = 0.90;
        inactive_opacity = 0.90;

        shadow = {
          enabled = true;
          range = 4;
          color = "rgba(1a1a1aee)";
          render_power = 3;
        };

        blur = {
          enabled = true;
          size = 5;
          passes = 4;

          xray = true;
          special = false;
          brightness = 0.8;
          noise = 0.01;
          contrast = 0.8;
          vibrancy = 0.5;
          vibrancy_darkness = 0.2;
          new_optimizations = true;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle = {
        preserve_split = true;
        smart_resizing = false;
      };

      input = {
        kb_layout = "de";
        numlock_by_default = true;
      };

      gestures = {
        workspace_swipe = false;
      };

      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, C, killactive"
        "$mainMod, F, togglefloating"
        "$mainMod, F11, fullscreen"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod, F1, workspace, 11"
        "$mainMod, F2, workspace, 12"
        "$mainMod, F3, workspace, 13"
        "$mainMod, F4, workspace, 14"
        "$mainMod, F5, workspace, 15"
        "$mainMod, F6, workspace, 16"
        "$mainMod, F7, workspace, 17"
        "$mainMod, F8, workspace, 18"
        "$mainMod, F9, workspace, 19"
        "$mainMod, F10, workspace, 20"
        "$mainMod, D, togglespecialworkspace"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod SHIFT, F1, movetoworkspace, 11"
        "$mainMod SHIFT, F2, movetoworkspace, 12"
        "$mainMod SHIFT, F3, movetoworkspace, 13"
        "$mainMod SHIFT, F4, movetoworkspace, 14"
        "$mainMod SHIFT, F5, movetoworkspace, 15"
        "$mainMod SHIFT, F6, movetoworkspace, 16"
        "$mainMod SHIFT, F7, movetoworkspace, 17"
        "$mainMod SHIFT, F8, movetoworkspace, 18"
        "$mainMod SHIFT, F9, movetoworkspace, 19"
        "$mainMod SHIFT, F10, movetoworkspace, 20"
        "$mainMod SHIFT, D, movetoworkspace, special"
        "$mainMod SHIFT, S, exec, hyprshot -z -m region"
      ] ++ additional_binds;

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      exec-once = [
        "dbus-update-activation-environment --systemd DISPLAY"
        "streamcontroller -b"
        "${config.home.homeDirectory}/.config/swww/swww-init.sh"
        "${pkgs.vo1ded-panel}/bin/vo1ded-panel"
      ];

      env = [
        "XCURSOR_THEME,Vimix-cursors"
        "XCURSOR_SIZE,24"
      ];
    };
  };
}
