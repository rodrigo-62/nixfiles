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

# Bind each output's primary workspace strictly so Sway picks 10 for DP-1 at boot:
  wayland.windowManager.sway.config.workspaceOutputAssign = [
    { workspace = "1";  output = "HDMI-A-1 eDP-1"; } # Monitor first; laptop if monitor is unplugged
    { workspace = "2";  output = "eDP-1"; }          # Second choice for laptop (used when monitor takes 1)
    { workspace = "10"; output = "DP-1"; }           # Strictly tablet (Sway auto-migrates if unplugged)
  ];

  # Ensure kanshi starts reliably with Sway on boot:
  wayland.windowManager.sway.config.startup = [
    { command = "${pkgs.systemd}/bin/systemctl --user restart kanshi"; always = true; }
  ];

  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";
    settings = [
      {
        profile.name = "all-three";
        profile.outputs = [
          { criteria = "HDMI-A-1"; position = "0,0"; }
          { criteria = "eDP-1";    position = "0,1080"; }
          { criteria = "DP-1";     position = "1920,1080"; }
        ];
        profile.exec = [
          "${pkgs.sway}/bin/swaymsg workspace 1, move workspace to output HDMI-A-1, focus output HDMI-A-1, workspace 1"
          "${pkgs.sway}/bin/swaymsg workspace 2, move workspace to output eDP-1, focus output eDP-1, workspace 2"
          "${pkgs.sway}/bin/swaymsg workspace 10, move workspace to output DP-1, focus output DP-1, workspace 10"
        ];
      }
      {
        profile.name = "tablet-only";
        profile.outputs = [
          { criteria = "eDP-1"; position = "0,0"; }
          { criteria = "DP-1";  position = "1920,0"; }
        ];
        profile.exec = [
          "${pkgs.sway}/bin/swaymsg workspace 10, move workspace to output DP-1, focus output DP-1, workspace 10"
          "${pkgs.sway}/bin/swaymsg workspace 1, move workspace to output eDP-1, focus output eDP-1, workspace 1"
        ];
      }
      {
        profile.name = "monitor-only";
        profile.outputs = [
          { criteria = "HDMI-A-1"; position = "0,0"; }
          { criteria = "eDP-1";    position = "0,1080"; }
        ];
        profile.exec = [
          "${pkgs.sway}/bin/swaymsg workspace 2, move workspace to output eDP-1, focus output eDP-1, workspace 2"
          "${pkgs.sway}/bin/swaymsg workspace 1, move workspace to output HDMI-A-1, focus output HDMI-A-1, workspace 1"
        ];
      }
      {
        profile.name = "laptop-only";
        profile.outputs = [
          { criteria = "eDP-1"; position = "0,0"; }
        ];
        profile.exec = [
          "${pkgs.sway}/bin/swaymsg workspace 1, move workspace to output eDP-1, focus output eDP-1, workspace 1"
        ];
      }
    ];
  };
