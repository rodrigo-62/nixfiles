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

}
