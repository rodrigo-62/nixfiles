{ pkgs, lib, ... }:

{
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  programs.zsh = {
    enable            = true;
    enableCompletion  = true;
    autosuggestion.enable      = true;
    syntaxHighlighting.enable  = true;

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # enable Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      (lib.mkAfter ''
        # to customize prompt run "p10k configure" or edit "~/.p10k.zsh"
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '')
    ];

    shellAliases = {
      ls   = "ls --color=auto";
      ll   = "ls -lah --color=auto";

      nrs  = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      nrsu  = "sudo nix flake update nixpkgs && sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      nrsua = "sudo nix flake update && sudo nixos-rebuild switch --flake /etc/nixos#nixos"; # all inputs
      nrst = "sudo nixos-rebuild switch --flake /etc/nixos#nixos --show-trace -L -v";
      nsv  = "nix-store --verify --check-contents";

      yt  = "ytfzf --detach --ytdl-pref='bestvideo[height<=?720]+bestaudio/best'";
      yt2 = "ytfzf --ytdl-pref='bestvideo[height<=?720]+bestaudio/best'";

      histoff = "fc -p /dev/null 1000 0";
      histon  = "fc -P";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src  = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    oh-my-zsh = {
      enable  = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "last-working-dir"
        "genpass"
        "copypath"
        "copyfile"
        "colored-man-pages"
        "web-search"
        "tldr"
        "safe-paste"
        "pass"
      ];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
