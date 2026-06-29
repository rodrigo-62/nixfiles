{ config, ... }:

{
  programs.alacritty = {
    enable   = true;
    settings = {
      window = {
        opacity                   = 0.7;
        padding                   = { x = 10; y = 10; };
        decorations               = "Full";
        decorations_theme_variant = "Dark";
      };

      font.size = 18.0;

      colors = {
        primary = { background = "#1D1B1D"; foreground = "#c7ccd1"; };
        cursor  = { text = "#1D1B1D"; cursor = "#c7ccd1"; };
        normal = {
          black   = "#1D1B1D"; red     = "#c7ae95"; green   = "#95c7ae";
          yellow  = "#aec795"; blue    = "#9683a8"; magenta = "#c795ae";
          cyan    = "#95aec7"; white   = "#c7ccd1";
        };
        bright = {
          black   = "#747c84"; red     = "#c7ae95"; green   = "#95c7ae";
          yellow  = "#aec795"; blue    = "#ae95c7"; magenta = "#c795ae";
          cyan    = "#95aec7"; white   = "#f3f4f5";
        };
      };
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "natural";
      };
      preview = {
        image_provider = "chafa"; 
        max_width = 1000;
        max_height = 1000;
      };
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "g" "u" ];
          run = "cd /run/media/${config.home.username}";
          desc = "Go to USB drives";
        }
        {
          on = [ "u" "u" ]; # 'u' for unmount
          run = ''
            shell 'udiskie-umount /run/media/${config.home.username}/* && notify-send "USB Safe" "All drives unmounted successfully."' --block
          '';
          desc = "Unmount all USB drives";
        }
      ];
    };    
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=18.0";
        pad = "10x10";
      };

      colors = {
        alpha = 0.7;
        background = "000000";
        foreground = "c7ccd1";

        cursor = "000000 c7ccd1";

        regular0 = "000000"; # black
        regular1 = "c7ae95"; # red
        regular2 = "95c7ae"; # green
        regular3 = "aec795"; # yellow
        regular4 = "9683a8"; # blue
        regular5 = "c795ae"; # magenta
        regular6 = "95aec7"; # cyan
        regular7 = "c7ccd1"; # white

        bright0 = "747c84"; # bright black
        bright1 = "c7ae95"; # bright red
        bright2 = "95c7ae"; # bright green
        bright3 = "aec795"; # bright yellow
        bright4 = "ae95c7"; # bright blue
        bright5 = "c795ae"; # bright magenta
        bright6 = "95aec7"; # bright cyan
        bright7 = "f3f4f5"; # bright white
      };

      csd = {
        preferred = "server";
      };
    };
  };
}
