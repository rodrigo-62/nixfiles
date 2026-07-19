{ pkgs, ... }:

let
  t = import ./theme.nix;

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

  cmusNowPlaying = pkgs.writeShellScript "waybar-cmus" ''
    info=$(${pkgs.cmus}/bin/cmus-remote -Q 2>/dev/null)

    if [ -z "$info" ]; then
      printf '{"text": ""}\n'
      exit 0
    fi

    json_escape() {
      printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
    }

    status=$(printf '%s\n' "$info" | awk '/^status /{print $2}')
    artist=$(printf '%s\n' "$info" | grep '^tag artist ' | cut -d ' ' -f 3-)
    title=$(printf '%s\n'  "$info" | grep '^tag title '  | cut -d ' ' -f 3-)

    if [ -z "$artist" ] && [ -z "$title" ]; then
      printf '{"text": ""}\n'
      exit 0
    fi

    [ -z "$artist" ] && artist="Unknown artist"
    [ -z "$title" ]  && title="Unknown title"

    label="$artist - $title"
    len=$(printf '%s' "$label" | wc -c)
    if [ "$len" -gt 42 ]; then
      label=$(printf '%s' "$label" | cut -c1-39)"..."
    fi

    if [ "$status" = "playing" ]; then class="playing"; else class="paused"; fi

    printf '{"text": "%s", "tooltip": "%s - %s", "class": "%s"}\n' \
      "$(json_escape "$label")" \
      "$(json_escape "$artist")" \
      "$(json_escape "$title")" \
      "$class"
  '';

in
{
  programs.waybar = {
    enable   = true;
    settings = [
      # BAR 1: MAIN (laptop)
      {
        name          = "main";
        output        = "eDP-1";
        
        layer         = "top";[cite: 1]
        position      = "bottom";[cite: 1]
        height        = 28;[cite: 1]
        spacing       = 1;[cite: 1]
        margin-bottom = 0;[cite: 1]

        modules-left   = [ "sway/workspaces" ];[cite: 1]
        modules-center = [];[cite: 1]
        modules-right  = [
          "custom/cmus" "cpu" "memory" "pulseaudio" "battery" "clock" "custom/power"[cite: 1]
        ];

        "sway/workspaces" = {
          disable-scroll = true;[cite: 1]
          all-outputs    = false;[cite: 1]
          format         = "{name}";[cite: 1]
        };

        cpu = {
          interval = 2;[cite: 1]
          format   = "CPU {usage}%";[cite: 1]
          tooltip  = false;[cite: 1]
        };

        memory = {
          interval = 2;[cite: 1]
          format   = "RAM {percentage}%";[cite: 1]
          tooltip  = false;[cite: 1]
        };

        battery = {
          interval        = 30;[cite: 1]
          format          = "{icon} {capacity}%";[cite: 1]
          format-charging = " {capacity}%";[cite: 1]
          format-full     = " {capacity}%";[cite: 1]
          format-icons    = [ "" "" "" "" "" ];[cite: 1]
          states          = { warning = 30; critical = 15; };[cite: 1]
        };

        pulseaudio = {
          format       = "VOL {volume}%";[cite: 1]
          format-muted = "muted";[cite: 1]
          on-click     = "pavucontrol";[cite: 1]
          scroll-step  = 5;[cite: 1]
        };

        clock = {
          interval       = 60;[cite: 1]
          format         = "{:%a %d %b %H:%M}";[cite: 1]
          locale         = "en_US.UTF-8";[cite: 1]
          tooltip-format = "{calendar}";[cite: 1]
        };

        "custom/power" = {
          format   = "";[cite: 1]
          on-click = "${powerMenuScript}";[cite: 1]
          tooltip  = false;[cite: 1]
        };

        "custom/cmus" = {
          exec        = "${cmusNowPlaying}";[cite: 1]
          interval    = 3;[cite: 1]
          return-type = "json";[cite: 1]
          on-click    = "${pkgs.cmus}/bin/cmus-remote -u";[cite: 1]
          tooltip     = true;[cite: 1]
        };
      }

      # BAR 2: SIDE MONITORS
      {
        name          = "minimal";
        output        = [ "HDMI-A-1" "DP-1" ]; 
        
        layer         = "top";[cite: 1]
        position      = "bottom";[cite: 1]
        height        = 28;[cite: 1]
        spacing       = 1;[cite: 1]
        margin-bottom = 0;[cite: 1]

        modules-left   = [ "sway/workspaces" ];[cite: 1]
        modules-center = [];[cite: 1]
        modules-right  = [ "clock" ];

        "sway/workspaces" = {
          disable-scroll = true;[cite: 1]
          all-outputs    = false;[cite: 1]
          format         = "{name}";[cite: 1]
        };

        clock = {
          interval       = 60;[cite: 1]
          format         = "{:%H:%M}"; 
          locale         = "en_US.UTF-8";[cite: 1]
          tooltip-format = "{calendar}";[cite: 1]
        };
      }
    ];
    
    style = ''
      @define-color fg     #${t.white};
      @define-color dim    #${t.grey};
      @define-color accent #${t.purple};
      @define-color brown  #${t.yellowbrown};
      @define-color urgent #${t.urgentred};

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
        color:            @fg;
      }

      #workspaces button {
        padding:          0 7px;
        background-color: transparent;
        background-image: none;
        color:            @dim;
        border-bottom:    2px solid transparent;
        transition:       all 0.2s ease;
        box-shadow:       none;
      }

      #workspaces button:hover {
        background-color: #3a3740;
        background-image: none;
        color:            @accent;
        box-shadow:       none;
        border-bottom:    2px solid @brown;
      }

      #workspaces button.focused,
      #workspaces button.active {
        background-color: #32303a;
        background-image: none;
        color:            #d4c8da;
        border-bottom:    3px solid @accent;
        box-shadow:       none;
      }

      #workspaces button.urgent {
        background-color: @urgent;
        background-image: none;
        color:            #e8e6f0;
        box-shadow:       none;
      }

      #cpu, #memory, #battery,
      #pulseaudio, #clock, #custom-power {
        padding:     1px 7px 0px 7px;
        color:       @fg;
        font-family: "FiraCode Nerd Font", "FiraCode Nerd Font Mono", "Inter";
        font-size:   15px;
      }

      #custom-cmus {
        padding:    1px 7px 0px 7px;
        font-size:  13px;
        transition: color 0.2s ease;
      }

      #custom-cmus.playing { color: @fg; }
      #custom-cmus.paused  { color: @dim; }

      #custom-cmus:hover {
        color: @accent;
      }

      #cpu {
        border-left:  1px solid #3a373e;
        padding-left: 11px;
      }

      #pulseaudio { color: #95aec7; }
      #battery    { color: #95c7ae; }
      #clock      { color: @fg; }

      #battery.warning  { color: @brown; }
      #battery.critical {
        color:            @fg;
        background-color: @urgent;
      }

      tooltip {
        background-color: #000000;
        border:           1px solid #2e2a2e;
        border-radius:    6px;
      }

      tooltip > label {
        color:   @fg;
        padding: 4px 8px;
      }

      #custom-power {
        color:         @fg;
        padding-left:  11px;
        padding-right: 15px;
        margin-left:   4px;
        border-left:   1px solid #3a373e;
        transition:    color 0.2s ease;
      }

      #custom-power:hover {
        color: @accent;
      }

    '';
  };

}
