{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Rodrigo Monteiro";
        email = "rodrigo.mgm148@gmail.com";
        signingKey = "C634E2672D233274";
      };

      commit.gpgsign = true;

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        cm = "commit -m";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "hx";  
      url."git@github.com:".insteadOf = "https://github.com/";
    };   
    
  };
}
