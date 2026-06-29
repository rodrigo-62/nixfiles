{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false; 
    
    pinentry = {
      package = pkgs.pinentry-gnome3;
    };

    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
  };
}
