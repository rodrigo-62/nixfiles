{ config, pkgs, ... }:

let
  wallpaper = ./wallpapers/solid-color-image.png;
  scripts_path = ./scripts;

  c = {
    darkblue    = "#08052b";
    lightblue   = "#485e7f";
    urgentred   = "#824867";
    white       = "#fcfcfa";
    black       = "#1d1b1d";
    purple      = "#c388aa";
    darkgrey    = "#3C393D";
    grey        = "#b0b5bd";
    midgrey     = "#413F41";
    mediumgrey  = "#8b8b8b";
    yellowbrown = "#8b5b65";
  };

  smart_resize = pkgs.writeShellScriptBin "sway-smart-resize" ''
    case $1 in
      left)  swaymsg resize grow left 30 px  || swaymsg resize shrink right 30 px ;;      
      right) swaymsg resize grow right 30 px || swaymsg resize shrink left 30 px ;;      
      up)    swaymsg resize grow up 30 px    || swaymsg resize shrink down 30 px ;;      
      down)  swaymsg resize grow down 30 px  || swaymsg resize shrink up 30 px ;;
    esac
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      menu = "rofi -show drun -config ~/.config/rofi/rofidmenu.rasi";

      fonts = {
        names = [ "DM Sans" "Inter" "FiraCode Nerd Font" ];
        size  = 12.0;
      };

      gaps   = { inner = 8; outer = 0; };
      window = {
        border   = 1;
        titlebar = false;
        commands = [
          {
            criteria = { app_id = "pavucontrol"; };
            command  = "floating enable, resize set 800 600, move position center";
          }
          {
            criteria = { app_id = "blueman-manager"; };
            command  = "floating enable, resize set 800 600, move position center";
          }
          {
            criteria = { app_id = "foot-launcher"; };
            command  = "floating enable, resize set 1100 550, move position center";
          }
          {
            criteria = { title = "Picture-in-Picture"; };
            command  = "floating enable, sticky enable";
          }
          {
            criteria = { app_id = "thunar"; title = ".*(Progress|Confirm|Properties|Create|Rename|Conflict|File Operation).*"; };
            command  = "floating enable";
          }
	  #{
          #  criteria = { app_id = "firefox"; title = "Extension\: \(Bitwarden Password Manager\).*"; };
          #  command = "floating enable";
          #}
        ];
      };
      floating = { border = 1; titlebar = false; };

      colors = {
        focused = {
          border      = c.lightblue;
          background  = c.darkblue;
          text        = c.white;
          indicator   = c.mediumgrey;
          childBorder = c.mediumgrey;
        };
        unfocused = {
          border      = c.midgrey;
          background  = c.darkblue;
          text        = c.grey;
          indicator   = c.darkgrey;
          childBorder = c.midgrey;
        };
        focusedInactive = {
          border      = c.midgrey;
          background  = c.darkblue;
          text        = c.grey;
          indicator   = c.black;
          childBorder = c.midgrey;
        };
        urgent = {
          border      = c.urgentred;
          background  = c.urgentred;
          text        = c.white;
          indicator   = c.yellowbrown;
          childBorder = c.yellowbrown;
        };
        background = c.black;
      };

      input = {
        "type:keyboard" = { xkb_layout = "gb"; xkb_options = "compose:ralt"; };
        "type:touchpad" = {
          tap            = "enabled";
          natural_scroll = "enabled";
          dwt            = "enabled";
        };
        "7847:100:2.4G_Mouse" = {
          pointer_accel = "-0.4"; 
          accel_profile = "adaptive";
        };
      };

      keybindings = let mod = "Mod4"; in {
        # Core
        "${mod}+Return"      = "exec foot";
        "${mod}+q"           = "kill";
        "${mod}+d"           = "exec rofi -show drun -config ~/.config/rofi/rofidmenu.rasi";
        "${mod}+Shift+c"     = "reload";
        "${mod}+Shift+e"     = "exec swaynag -t warning -m 'Exit sway?' -b 'Yes, exit sway' 'swaymsg exit'";
        "${mod}+l"           = "exec swaylock";

        # Focus
        "${mod}+j"           = "focus left";
        "${mod}+k"           = "focus down";
        "${mod}+b"           = "focus up";
        "${mod}+o"           = "focus right";
        "${mod}+Left"        = "focus left";
        "${mod}+Down"        = "focus down";
        "${mod}+Up"          = "focus up";
        "${mod}+Right"       = "focus right";

        # Move
        "${mod}+Shift+j"     = "move left";
        "${mod}+Shift+k"     = "move down";
        "${mod}+Shift+b"     = "move up";
        "${mod}+Shift+o"     = "move right";
        "${mod}+Shift+Left"  = "move left";
        "${mod}+Shift+Down"  = "move down";
        "${mod}+Shift+Up"    = "move up";
        "${mod}+Shift+Right" = "move right";

        # Splits & layouts
        "${mod}+h"           = "splith";
        "${mod}+v"           = "splitv";
        "${mod}+e"           = "layout toggle split";
        "${mod}+f"           = "fullscreen toggle";

        # Floating
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space"       = "focus mode_toggle";
        "${mod}+a"           = "focus parent";

        # Workspace navigation
        "${mod}+Shift+Tab"   = "workspace next"; 
        "${mod}+Ctrl+Tab   " = "workspace prev";
        "${mod}+Tab"         = "exec rofi -show window -config ~/.config/rofi/rofidmenu.rasi";
        "Mod1+Tab"           = "workspace back_and_forth"; # "exec swaymsg '[con_mark=_prev] focus'";

        # Workspaces 1–10
        "${mod}+1"           = "workspace 1";
        "${mod}+2"           = "workspace 2";
        "${mod}+3"           = "workspace 3";
        "${mod}+4"           = "workspace 4";
        "${mod}+5"           = "workspace 5";
        "${mod}+6"           = "workspace 6";
        "${mod}+7"           = "workspace 7";
        "${mod}+8"           = "workspace 8";
        "${mod}+9"           = "workspace 9";
        "${mod}+0"           = "workspace 10";

        # Move container to workspace
        "${mod}+Shift+1"     = "move container to workspace 1";
        "${mod}+Shift+2"     = "move container to workspace 2";
        "${mod}+Shift+3"     = "move container to workspace 3";
        "${mod}+Shift+4"     = "move container to workspace 4";
        "${mod}+Shift+5"     = "move container to workspace 5";
        "${mod}+Shift+6"     = "move container to workspace 6";
        "${mod}+Shift+7"     = "move container to workspace 7";
        "${mod}+Shift+8"     = "move container to workspace 8";
        "${mod}+Shift+9"     = "move container to workspace 9";
        "${mod}+Shift+0"     = "move container to workspace 10";

        # Resize mode
        "${mod}+r"           = "mode resize";
        "${mod}+Ctrl+Left"   = "exec ${smart_resize}/bin/sway-smart-resize left";
        "${mod}+Ctrl+Right"  = "exec ${smart_resize}/bin/sway-smart-resize right";
        "${mod}+Ctrl+Up"     = "exec ${smart_resize}/bin/sway-smart-resize up";
        "${mod}+Ctrl+Down"   = "exec ${smart_resize}/bin/sway-smart-resize down";

        # Scratchpad
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus"       = "scratchpad show";

        # Screenshot
        "Print"              = ''exec grim -g "$(slurp)" - | wl-copy'';
        "Ctrl+Print"         = ''exec grim - | wl-copy'';
        "Shift+Print"        = ''exec bash -c 'grim -g "$(slurp)" - | tee >(wl-copy) | satty --filename -' '';
        "${mod}+Shift+Print" = ''exec grim - | satty --filename -'';

        # Screen Recording
        "${mod}+Shift+r"     = "exec ${scripts_path}/screen_record_toggle.sh";
 
        # Volume
        "XF86AudioRaiseVolume"  = "exec swayosd-client --output-volume raise";
        "XF86AudioLowerVolume"  = "exec swayosd-client --output-volume lower";
        "XF86AudioMute"         = "exec swayosd-client --output-volume mute-toggle";
        "XF86AudioMicMute"      = "exec swayosd-client --input-volume mute-toggle";

        # "XF86AudioRaiseVolume"  = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
        # "XF86AudioLowerVolume"  = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        # "XF86AudioMute"         = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        # "XF86AudioMicMute"      = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        # Music
        "${mod}+p"            = "exec playerctl play-pause";
        "${mod}+bracketleft"  = "exec playerctl previous";
        "${mod}+bracketright" = "exec playerctl next";

        # Brightness
        "XF86MonBrightnessUp"   = "exec swayosd-client --brightness raise 1";
        "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower 1";
        # "XF86MonBrightnessUp"   = "exec brightnessctl set +2%";
        # "XF86MonBrightnessDown" = "exec brightnessctl set 2%-";

        # Wallpaper swap
        # "${mod}+Shift+w" = "exec /etc/nixos/home/scripts/wallpaper_swap.sh";
        "${mod}+w"         = "exec ${scripts_path}/wallpaper_select.sh";

        # launch scripts
        "${mod}+s" = "exec ${scripts_path}/run.sh";
      };

      modes.resize = {
        "h"      = "resize shrink width 20px";
        "j"      = "resize grow height 20px";
        "k"      = "resize shrink height 20px";
        "l"      = "resize grow width 20px";
        "Left"   = "resize shrink width 20px";
        "Down"   = "resize grow height 20px";
        "Up"     = "resize shrink height 20px";
        "Right"  = "resize grow width 20px";
        "Return" = "mode default";
        "Escape" = "mode default";
      };

      bars    = [ { command = "waybar"; } ];
      startup = [
        { command = "mako"; }
        # { command = "swaybg -i ${wallpaper} -m fill"; always = true; }
        {
          command = ''
            swayidle -w \
              timeout 300  'swaylock' \
              timeout 600  'swaymsg "output * dpms off"' \
              resume       'swaymsg "output * dpms on"' \
              before-sleep 'swaylock'
          '';
        }
        { command = "swaymsg workspace 1"; }
        { command = "swww-daemon --format xrgb"; }
        { command = "sleep 1 && swww img ${wallpaper} --transition-type none"; always = true; }
        # { command = "swayrd"; }
      ];
    };

    extraConfig = ''
      seat * xcursor_theme Bibata-Modern-Classic 26
      
      # SwayFX settings
      blur enable
      blur_passes 2
      blur_radius 3
      corner_radius 8

      layer_effects "waybar" blur enable
      layer_effects "rofi" blur enable
      layer_effects "rofi" corner_radius 8
      layer_effects "mako" blur enable
    '';
  };
}
