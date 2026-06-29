{ pkgs, ... }:

{
  # mako notification daemon (started by sway)
  home.file.".config/mako/config".text = ''
    background-color=#2a272bcc
    text-color=#fcfcfa
    border-color=#485e7f
    border-radius=4
    border-size=1
    padding=8,12
    font=Inter 10
    default-timeout=5000
    anchor=top-right
  '';

  # cmus colour scheme
  # note to self -> activate inside cmus once with: :colorscheme cmus_noir
  home.file.".config/cmus/cmus_noir.theme".text = ''
    # theme by Nicklas Rudolfsson — https://github.com/nirucon/
    set color_cmdline_fg=254
    set color_cmdline_bg=default
    set color_separator=235
    set color_statusline_bg=default
    set color_statusline_fg=245
    set color_titleline_bg=default
    set color_titleline_fg=254
    set color_win_bg=default
    set color_win_fg=254
    set color_win_cur=15
    set color_win_dir=254
    set color_win_inactive_cur_sel_bg=235
    set color_win_inactive_cur_sel_fg=15
    set color_win_inactive_sel_bg=235
    set color_win_inactive_sel_fg=254
    set color_win_cur_sel_bg=235
    set color_win_cur_sel_fg=15
    set color_win_sel_bg=235
    set color_win_sel_fg=254
    set color_win_title_bg=235
    set color_win_title_fg=254
    set color_error=88
    set color_info=88
  '';
 
  programs.zathura = {
    enable = true;
    options = {
      font = "DM Sans 16";
      
      selection-clipboard = "clipboard";
      sandbox             = "strict";
      
      recolor            = true;      # start in dark mode by default
      recolor-darkcolor  = "#dddcde"; # text
      recolor-lightcolor = "#1C1C1E"; # background
      recolor-keephue    = true;      # don't mess with colors of images/links
      
      completion-bg           = "#1C1C1E";
      completion-fg           = "#dddcde";

      completion-highlight-bg = "#afcbf9";
      completion-highlight-fg = "#1C1C1E";

      completion-group-bg     = "#252527";
      completion-group-fg     = "#9a87fa"; 

      inputbar-bg             = "#1C1C1E";
      inputbar-fg             = "#9a87fa";

      statusbar-bg            = "#1C1C1E";
      statusbar-fg            = "#dddcde";

      notification-bg         = "#1C1C1E";
      notification-fg         = "#afcbf9";
      notification-error-bg   = "#1C1C1E";
      notification-error-fg   = "#9a87fa";
    };

    mappings = {
      "i" = "recolor";
    };

  };  
}
