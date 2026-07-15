{ ... }:

let
  t = import ./theme.nix;
in
{
  programs.swaylock = {
    enable   = true;
    settings = {
      image = ./wallpapers/lockimage.png;
      scaling = "fill";

      font = "DM Sans"; # "FiraCode Nerd Font Mono";
      indicator-radius     = 85;
      ring-color           = t.lightblue;
      key-hl-color         = t.purple;
      bs-hl-color          = t.yellowbrown;
      inside-color         = "00000000";
      line-color           = t.bgAlt;
      text-color           = t.white;
      show-failed-attempts = true;

      ring-ver-color      = t.purple;
      inside-ver-color    = "00000000";
      text-ver-color      = t.grey;
      ring-wrong-color    = t.urgentred;
      inside-wrong-color  = "00000000";
      text-wrong-color    = t.purple;

      ring-clear-color    = t.lightblue;
      inside-clear-color  = "00000000";
      text-clear-color    = t.grey;

      ring-caps-lock-color   = t.yellowbrown; 
      inside-caps-lock-color = "00000000";   
      text-caps-lock-color   = t.white;

      separator-color = "00000000";
    };
  };
}
