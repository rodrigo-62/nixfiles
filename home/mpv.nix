{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "vaapi";
      gpu-context = "wayland";
      vo = "gpu";
      profile = "fast";

      keep-open = "yes";
      autofit = "50%";

      save-position-on-quit = "yes";
      watch-later-directory = "~/.cache/mpv/watch-later";    
    };

    bindings = {
      "UP" = "add volume 5";
      "DOWN" = "add volume -5";
      "WHEEL_UP" = "add volume 5";
      "WHEEL_DOWN" = "add volume -5";
      "c" = "run wl-copy \"\${path}\"; show-text \"Copied: \${path}\"";
    };
  };

  # delete cache older than 7 days
  systemd.user.tmpfiles.rules = [
    "d %h/.cache/mpv/watch-later 0755 - - 3d"
  ];
}
