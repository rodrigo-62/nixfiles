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

  services.wlsunset = {
    enable = true;
    temperature.day = 5600;
    temperature.night = 5000;
  
    gamma = "0.8"; 
  
    latitude = "41.15";
    longitude = "-8.63";
  };

}
