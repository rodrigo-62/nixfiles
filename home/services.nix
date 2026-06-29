{ config, pkgs, ... }:

{
  systemd.user.services.swayosd = {
    Unit = {
      Description    = "SwayOSD server";
      PartOf         = [ "graphical-session.target" ];
      After          = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      Restart   = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  services.udiskie = {
    enable = true;
    tray = "never";
  };

}
