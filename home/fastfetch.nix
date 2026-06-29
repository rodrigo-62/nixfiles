{ config, lib, ... }:
let
  cfg = config.features.programs.cli.fastfetch;
in
{
  options.features.programs.cli.fastfetch = {
    enable = lib.mkEnableOption "fastfetch";
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        display = {
          separator = " ➜  ";
        };

        modules = [
          "break"
          { type = "os"; key = "OS        "; keyColor = "red"; }
          { type = "kernel"; key = "├ kernel  "; keyColor = "red"; }
          { type = "packages"; key = "├ packages"; keyColor = "red"; }
          { type = "shell"; key = "└ shell   "; keyColor = "red"; }
          "break"
          { type = "wm"; key = "WM        "; keyColor = "green"; }
          { type = "wmtheme"; key = "├ wm theme"; keyColor = "green"; }
	  { type = "theme"; key = "├ gtk     "; keyColor = "green"; }
          { type = "icons"; key = "├ icons   "; keyColor = "green"; }
          { type = "cursor"; key = "├ cursor  "; keyColor = "green"; }
          { type = "terminal"; key = "├ terminal"; keyColor = "green"; }
          { type = "terminalfont"; key = "└ font    "; keyColor = "green"; }
          "break"
          { type = "host"; format = "{5} {1} Type {2}"; key = "PC        "; keyColor = "yellow"; }
          { type = "cpu"; format = "{1} ({3} cores) @ {7}"; key = "├ cpu     "; keyColor = "yellow"; }
          { type = "gpu"; format = "{1} {2} @ {12}"; key = "├ gpu     "; keyColor = "yellow"; }
          { type = "memory"; key = "├ memory  "; keyColor = "yellow"; }
          { type = "swap"; key = "├ swap    "; keyColor = "yellow"; }
          { type = "disk"; key = "├ disk    "; keyColor = "yellow"; }
          { type = "monitor"; format = "{2}x{3} @ {11} Hz"; key = "└ monitor "; keyColor = "yellow"; }
        ];
      };
    };
  };
}
