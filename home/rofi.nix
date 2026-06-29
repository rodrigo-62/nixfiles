{ pkgs, ... }:

{
  programs.rofi = {
    enable  = true;
    package = pkgs.rofi;

    font = "DM Sans";
    theme = ./rofi/deep-purple.rasi;
  };

  xdg.configFile."rofi/rofidmenu.rasi".source = ./rofi/rofidmenu.rasi;
}
