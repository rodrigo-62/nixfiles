{ config, pkgs, lib, inputs, ... }:

let
  wrapFirejail = executable: pkg: extraArgs:
    pkgs.runCommand "${executable}-firejailed" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
    } ''
      mkdir -p $out/bin
      
      # bring back the desktop files and icons for the launcher
      if [ -d "${pkg}/share" ]; then
        ln -s "${pkg}/share" "$out/share"
      fi
      
      # point explicitly to the NixOS SUID firejail wrapper
      makeWrapper ${pkg}/bin/${executable} $out/bin/${executable} \
        --run "exec /run/wrappers/bin/firejail ${extraArgs} ${pkg}/bin/${executable} \"\$@\""
    '';

  pythonScriptsEnv = pkgs.python3.withPackages (ps: with ps; [
    cryptography
    
    pymupdf
    regex
    beautifulsoup4
    lxml
    numpy
    pygame
    pyperclip
    rich
    
    pytesseract
    pdf2image
    opencv4
  ]);

in
{
  home.packages = with pkgs; [
    pythonScriptsEnv

    foot 
    waybar
    swaylock
    swayidle
    swaybg
    wl-clipboard
    mako
    libnotify
    brightnessctl
    pavucontrol
    grim
    slurp
    satty
    playerctl
    bibata-cursors
    swayosd
    swww
    wl-screenrec

    neovim
    vim
    nano
    htop
    zip
    unzip
    ffmpeg
    lm_sensors
    btop
    duf
    wl-clipboard
    hyprpicker
    cliphist
    cmus
    udiskie
    imv
    chafa

    imagemagick
    ffmpegthumbnailer
    poppler-utils
    
    jq
    p7zip
    fd
    ripgrep
    zoxide
    fzf

    lsof 
    psmisc
    testdisk
    mediainfo
    parted
    util-linux
    
    krita
    wireguard-tools 
    caligula 

    ytfzf
    yt-dlp
        
    obsidian
    sherlock
    exiftool

    firefox # (wrapFirejail "firefox" firefox "")
    vesktop
    calibre
    gnome-calendar
    termdown
  ];

  features.programs.cli.fastfetch = {
    enable = true;
  };

  xdg.configFile."firejail/firefox.local" = {
    force = true;
    text = ''
      noblacklist ''${HOME}/.config/mozilla
      noblacklist ''${HOME}/.mozilla
      noblacklist ''${HOME}/scripts
      whitelist ''${HOME}/.config/mozilla
      whitelist ''${HOME}/.mozilla
      whitelist ''${HOME}/scripts
      read-only ''${HOME}/scripts
    '';
  };

}
