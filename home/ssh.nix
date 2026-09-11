{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false; 

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

      "github.com-old" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_old";
        identitiesOnly = true;
      };

      "*" = {
         # global defaults here
      };

    };
  };

  services.ssh-agent.enable = true;
}
