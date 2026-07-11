{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false; 
    
    pinentry = {
      package = pkgs.pinentry-gnome3;
    };

    defaultCacheTtl = 3456000;
    maxCacheTtl = 3456000;
  };
}
