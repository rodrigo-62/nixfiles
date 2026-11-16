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
    "type:tablet_tool" = {
      map_to_output = "DP-1";
    };

    "0:0:OpenTabletDriver_Virtual_Artist_Tablet" = {
      map_to_output = "DP-1";
    };

    "0:0:OpenTabletDriver_Virtual_Tablet" = {
      map_to_output = "DP-1";
    };
  };

  # Fallback rules for newly created workspaces in Sway:
  wayland.windowManager.sway.config.workspaceOutputAssign = [
    { workspace = "1";  output = "HDMI-A-1 eDP-1"; } # Monitor first; laptop if monitor unplugged
    { workspace = "2";  output = "eDP-1"; }          # Laptop panel
    { workspace = "10"; output = "DP-1 eDP-1"; }     # Tablet first; laptop if tablet unplugged
  ];

  # Dynamic display positions and live workspace switching on hotplug:
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "all-three";
        profile.outputs = [
          { criteria = "HDMI-A-1"; position = "0,0"; }
          { criteria = "eDP-1";    position = "0,1080"; }
          { criteria = "DP-1";     position = "1920,1080"; }
        ];
        profile.exec = [
          "swaymsg workspace 1, move workspace to output HDMI-A-1"
          "swaymsg workspace 2, move workspace to output eDP-1"
          "swaymsg workspace 10, move workspace to output DP-1"
        ];
      }
      {
        profile.name = "tablet-only";
        profile.outputs = [
          { criteria = "eDP-1"; position = "0,0"; }
          { criteria = "DP-1";  position = "1920,0"; }
        ];
        profile.exec = [
          "swaymsg workspace 1, move workspace to output eDP-1"
          "swaymsg workspace 10, move workspace to output DP-1"
        ];
      }
      {
        profile.name = "monitor-only";
        profile.outputs = [
          { criteria = "HDMI-A-1"; position = "0,0"; }
          { criteria = "eDP-1";    position = "0,1080"; }
        ];
        profile.exec = [
          "swaymsg workspace 1, move workspace to output HDMI-A-1"
          "swaymsg workspace 2, move workspace to output eDP-1"
        ];
      }
      {
        profile.name = "laptop-only";
        profile.outputs = [
          { criteria = "eDP-1"; position = "0,0"; }
        ];
        profile.exec = [
          "swaymsg workspace 1, move workspace to output eDP-1"
        ];
      }
    ];
  };
}
