{ pkgs, ... }:

let
  powerMenuScript = pkgs.writeShellScript "rofi-power-menu" ''
    entries="   Shutdown\n   Reboot\n   Suspend"
    
    theme_overrides='
      window { width: 270px; }
      listview { lines: 3; columns: 1; scrollbar: false; spacing: 6px; }
      element { padding: 8px 12px; }
    '
    
    selected=$(echo -e "$entries" | rofi -dmenu -i -p "Power" -theme-str "$theme_overrides")
    
    case $selected in
      "   Shutdown") exec systemctl poweroff;;
      "   Reboot") exec systemctl reboot;;
      "   Suspend") exec systemctl suspend;;
    esac
  '';

in
{
  programs.waybar = {
    enable   = true;
    settings = [{
      layer         = "top";
      position      = "bottom";
      height        = 28;
      spacing       = 1;
      margin-bottom = 0;

      modules-left   = [ "sway/workspaces" ];
      modules-center = [];
      modules-right  = [
        "cpu" "memory" "pulseaudio" "battery" "clock" "custom/power"
      ];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs    = false;
        format         = "{name}";
      };

      cpu = {
        interval = 2;
        format   = "CPU {usage}%";
        tooltip  = false;
      };

      memory = {
        interval = 2;
        format   = "RAM {percentage}%";
        tooltip  = false;
      };

      battery = {
        interval        = 30;
        format          = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-full     = " {capacity}%";
        format-icons    = [ "" "" "" "" "" ];
        states          = { warning = 30; critical = 15; };
      };

      pulseaudio = {
        format       = "VOL {volume}%";
        format-muted = "muted";
        on-click     = "pavucontrol";
        scroll-step  = 5;
      };

      clock = {
        interval       = 60;
        format         = "{:%a %d %b %H:%M}";
        locale         = "en_US.UTF-8";
        tooltip-format = "{calendar}";
      };

      "custom/power" = {
        format   = "";
        on-click = "${powerMenuScript}";
        tooltip  = false;
      };
    }];

    style = ''
      * {
        border:        none;
        border-radius: 0;
        font-family:   "DM Sans",  "Inter", "FiraCode Nerd Font Mono";
        font-size:     13px;
        min-height:    0;
      }

      window#waybar {
        margin:           0;
        border-top:       1px solid #3D383D;
        background-color: #000000;
        color:            #fcfcfa;
      }

      #workspaces button {
        padding:          0 7px;
        background-color: transparent;
        background-image: none;
        color:            #b0b5bd;
        border-bottom:    2px solid transparent;
        transition:       all 0.2s ease;
        box-shadow:       none;
      }

      #workspaces button:hover {
        background-color: #3a3740;
        background-image: none;
        color:            #c388aa;
        box-shadow:       none;
        border-bottom:    2px solid #8b5b65;
      }

      #workspaces button.focused,
      #workspaces button.active {
        background-color: #32303a;
        background-image: none;
        color:            #d4c8da;
        border-bottom:    3px solid #c388aa;
        box-shadow:       none;
      }

      #workspaces button.urgent {
        background-color: #824867;
        background-image: none;
        color:            #e8e6f0;
        box-shadow:       none;
      }

      #cpu, #memory, #battery,
      #pulseaudio, #clock, #custom-power {
        padding:     1px 7px 0px 7px; /* top right bottom left */
        color:       #fcfcfa;
        font-family: "FiraCode Nerd Font", "FiraCode Nerd Font Mono", "Inter";
        font-size:   15px;
      }

      #cpu {
        border-left:  1px solid #3a373e;
        padding-left: 11px;
      }

      #pulseaudio            { color: #95aec7; }
      #battery               { color: #95c7ae; }
      #clock                 { color: #fcfcfa; }

      #battery.warning  { color: #8b5b65; }
      #battery.critical {
        color:            #fcfcfa;
        background-color: #824867;
      }
      
      tooltip {
        background-color: #000000;
        border:           1px solid #2e2a2e;  /* matches the bar's top border */
        border-radius:    6px;
      }

      tooltip > label {
        color:   #fcfcfa;
        padding: 4px 8px;
      }
      
      #custom-power {
        color:         #fcfcfa;
        padding-left:  11px;
        padding-right: 15px; 
        margin-left:   4px;
        border-left:   1px solid #3a373e; 
        transition:    color 0.2s ease;
      }

      #custom-power:hover {
        color: #c388aa;
      }
    '';
  };
}
