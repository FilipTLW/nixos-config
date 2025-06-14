{
pkgs,
lib,
config,
...
}:
{
  options.rofi-module = {
    enable = lib.mkEnableOption "Enable rofi module";
  };
  
  config = lib.mkIf config.rofi-module.enable {
    home.packages = with pkgs; [
      rofi
    ];
    
    home.file.".config/rofi/themes/vo1ded.rasi".text = ''
    /******************************************************************************
     * ROFI Color theme
     * User: FilipTLW
     * Copyright: Filip Myslinski
     ******************************************************************************/
    * {
        font-family:                 "JetBrainsMono Nerd Font";
        red:                         rgba ( 220, 50, 47, 66 % );
        selected-active-foreground:  var(background);
        lightfg:                     #8c6ce6aa;
        separatorcolor:              var(foreground);
        urgent-foreground:           var(red);
        alternate-urgent-background: var(lightbg);
        lightbg:                     #392173aa;
        spacing:                     2;
        border-color:                var(foreground);
        normal-background:           var(background);
        background-color:            rgba ( 0, 0, 0, 0 % );
        alternate-active-background: var(lightbg);
        active-foreground:           var(blue);
        blue:                        rgba ( 38, 139, 21, 66 % );
        urgent-background:           var(background);
        alternate-normal-foreground: var(foreground);
        selected-active-background:  var(blue);
        background:                  #291d44aa;
        selected-normal-foreground:  var(lightbg);
        active-background:           var(background);
        alternate-active-foreground: var(blue);
        alternate-normal-background: var(lightbg);
        foreground:                  #c6bcf6aa;
        selected-urgent-background:  var(red);
        selected-urgent-foreground:  var(background);
        normal-foreground:           var(foreground);
        alternate-urgent-foreground: var(red);
        selected-normal-background:  var(lightfg);
    }
    element {
        padding: 1px ;
        spacing: 5px ;
        border:  0;
        cursor:  pointer;
    }
    element normal.normal {
        background-color: var(normal-background);
        text-color:       var(normal-foreground);
    }
    element normal.urgent {
        background-color: var(urgent-background);
        text-color:       var(urgent-foreground);
    }
    element normal.active {
        background-color: var(active-background);
        text-color:       var(active-foreground);
    }
    element selected.normal {
        background-color: var(selected-normal-background);
        text-color:       var(selected-normal-foreground);
    }
    element selected.urgent {
        background-color: var(selected-urgent-background);
        text-color:       var(selected-urgent-foreground);
    }
    element selected.active {
        background-color: var(selected-active-background);
        text-color:       var(selected-active-foreground);
    }
    element alternate.normal {
        background-color: var(alternate-normal-background);
        text-color:       var(alternate-normal-foreground);
    }
    element alternate.urgent {
        background-color: var(alternate-urgent-background);
        text-color:       var(alternate-urgent-foreground);
    }
    element alternate.active {
        background-color: var(alternate-active-background);
        text-color:       var(alternate-active-foreground);
    }
    element-text {
        background-color: rgba ( 0, 0, 0, 0 % );
        text-color:       inherit;
        highlight:        inherit;
        cursor:           inherit;
    }
    element-icon {
        background-color: rgba ( 0, 0, 0, 0 % );
        size:             1.0000em ;
        text-color:       inherit;
        cursor:           inherit;
    }
    window {
        padding:          5;
        background-color: var(background);
        border:           1;
        border-radius:    0;
        transparency:     "real";
    }
    mainbox {
        padding: 0;
        border:  0;
    }
    message {
        padding:      1px ;
        border-color: var(separatorcolor);
        border:       2px dash 0px 0px ;
    }
    textbox {
        text-color: var(foreground);
    }
    listview {
        padding:      2px 0px 0px ;
        scrollbar:    true;
        border-color: var(separatorcolor);
        spacing:      2px ;
        fixed-height: 0;
        border:       2px dash 0px 0px ;
    }
    scrollbar {
        width:        4px ;
        padding:      0;
        handle-width: 8px ;
        border:       0;
        handle-color: var(normal-foreground);
    }
    sidebar {
        border-color: var(separatorcolor);
        border:       2px dash 0px 0px ;
    }
    button {
        spacing:    0;
        text-color: var(normal-foreground);
        cursor:     pointer;
    }
    button selected {
        background-color: var(selected-normal-background);
        text-color:       var(selected-normal-foreground);
    }
    
    num-filtered-rows, num-rows {
        text-color: grey;
        expand:     false;
    }
    textbox-num-sep {
        text-color: grey;
        expand:     false;
        str:        "/";
    }
    inputbar {
        padding:    1px ;
        spacing:    0px ;
        text-color: var(normal-foreground);
        children:   [ prompt,textbox-prompt-colon,entry, num-filtered-rows, textbox-num-sep, num-rows, case-indicator ];
    }
    case-indicator {
        spacing:    0;
        text-color: var(normal-foreground);
    }
    entry {
        spacing:           0;
        text-color:        var(normal-foreground);
        placeholder-color: grey;
        placeholder:       "Type to filter";
        cursor:            text;
    }
    prompt {
        spacing:    0;
        text-color: var(normal-foreground);
    }
    textbox-prompt-colon {
        margin:     0px 0.3000em 0.0000em 0.0000em ;
        expand:     false;
        str:        ":";
        text-color: inherit;
    }
    '';
    
    home.file.".config/rofi/config.rasi".text = ''
    configuration {
      modes: [ combi ];
      combi-modes: [ window, drun, run ];
    }
    
    @theme "vo1ded"
    '';
  };
}