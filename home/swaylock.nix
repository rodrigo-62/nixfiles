{ ... }:

{
  programs.swaylock = {
    enable   = true;
    settings = {
      image = ./wallpapers/lockimage.png;
      scaling = "fill";

      font = "DM Sans"; # "FiraCode Nerd Font Mono";
      # color                = "000000";
      indicator-radius     = 85;
      ring-color           = "485e7f";
      key-hl-color         = "c388aa";
      bs-hl-color          = "8b5b65";
      inside-color         = "00000000";
      line-color           = "2a272b";
      text-color           = "fcfcfa";
      show-failed-attempts = true;

      ring-ver-color    = "c388aa";
      inside-ver-color  = "00000000";
      text-ver-color    = "b0b5bd";
      ring-wrong-color  = "824867";
      inside-wrong-color = "00000000";
      text-wrong-color  = "c388aa";

      ring-clear-color   = "485e7f";
      inside-clear-color = "00000000";
      text-clear-color   = "b0b5bd";

      separator-color = "00000000";
    };
  };
}
