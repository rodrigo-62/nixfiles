{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./services.nix
    ./sway.nix
    ./waybar.nix
    ./swaylock.nix
    ./terminal.nix
    ./shell.nix
    ./editors.nix
    ./gtk.nix
    ./media.nix
    ./git.nix
    ./ssh.nix
    ./gpg.nix
    ./rofi.nix
    ./fastfetch.nix
    ./mpv.nix
  ];

  home.username      = "parrhasius";
  home.homeDirectory = "/home/parrhasius";

  home.pointerCursor = {
    name    = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size    = 24;
    gtk.enable = true;
  };

  home.sessionVariables = {
    EDITOR             = "hx";
    NIXOS_OZONE_WL     = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  home.stateVersion = "25.11";

  systemd.user.tmpfiles.rules = [
    "e %h/Downloads - - - 14d"
  ];

  wayland.windowManager.sway.config.input = {
    "0:0:OpenTabletDriver_Virtual_Artist_Tablet" = {
      map_to_output = "DP-1";
    };

    "0:0:OpenTabletDriver_Virtual_Tablet" = {
      map_to_output = "DP-1";
    };  
  };

  wayland.windowManager.sway.config.workspaceOutputAssign = [
    { workspace = "1";  output = "HDMI-A-1"; } # AOC monitor
    { workspace = "2";  output = "eDP-1"; }    # laptop panel
    { workspace = "10"; output = "DP-1"; }     # Kamvas tablet
  ];

  wayland.windowManager.sway.config.output = {
    "HDMI-A-1" = { position = "0,0"; };       # monitor
    "eDP-1"    = { position = "0,1080"; };    # laptop, below
    "DP-1"     = { position = "1920,1080"; }; # tablet, right of the laptop
  };

}
