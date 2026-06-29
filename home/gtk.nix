{ pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name    = "Yaru-blue-dark";
      package = pkgs.yaru-theme;
    };

    iconTheme = {
      name    = "Tela-black-dark";
      package = pkgs.tela-icon-theme;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name         = "adwaita-dark";
  };
}
