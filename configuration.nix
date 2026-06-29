{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "i915.enable_psr=0" "i915.enable_dc=0" ];
  boot.extraModprobeConfig = ''
    options btusb enable_autosuspend=n
    options iwlwifi bt_coex_active=0
  '';

  # Networking
  networking.hostName                  = "nixos";
  networking.networkmanager.enable     = true;
  networking.firewall.trustedInterfaces = [ "virbr0" "virbr1" "virbr2" ];

  # Locale & time
  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT    = "pt_PT.UTF-8";
    LC_MONETARY       = "pt_PT.UTF-8";
    LC_NAME           = "pt_PT.UTF-8";
    LC_NUMERIC        = "pt_PT.UTF-8";
    LC_PAPER          = "pt_PT.UTF-8";
    LC_TELEPHONE      = "pt_PT.UTF-8";
    LC_TIME           = "pt_PT.UTF-8";
  };

  console.keyMap = "uk";

  # Users
  programs.zsh.enable = true;
  users.users.parrhasius = {
    isNormalUser = true;
    description  = "Parrhasius";
    extraGroups  = [ "networkmanager" "wheel" "wireshark" "docker" "libvirtd" "storage" "dialout" "kvm" "audio" ];
    shell        = pkgs.zsh;
  };

  # Nix
  nixpkgs.config.allowUnfree          = true;
  nix.settings.experimental-features  = [ "nix-command" "flakes" ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  nix.gc = {
    automatic = true;
    dates     = "daily";
    options   = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  # RAM
  zramSwap.enable = true;
  services.earlyoom.enable = true;
  services.earlyoom.freeMemThreshold = 10;
  systemd.slices."user".sliceConfig = {
    MemoryMax = "88%";
    MemorySwapMax = "88%"; 
  };

  # System-wide fonts 
  fonts.packages = with pkgs; [
    dm-sans
    inter
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.meslo-lg
    noto-fonts
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif  = [ "DM Sans" ];
    monospace  = [ "FiraCode Nerd Font Mono" ];
  };

  # programs & system packages
  environment.systemPackages = with pkgs; [
    wget
  ];

  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;

  programs.firejail.enable = true;
  programs.localsend.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.gvfs.enable = true;    # mount, trash, and remote filesystems
  services.tumbler.enable = true; # thumbnail support for images

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-wlr
    ];
    config.common.default = [ "wlr" "gtk" ];
  };
  
  # Hardware
  hardware.enableAllFirmware = true;

  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # driver for 11th Gen (iHD)
      libvdpau-va-gl     # translation layer
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; 
  };

  # Services
  services.libinput.enable = true;
  services.blueman.enable  = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable             = true;
    jack.enable        = true;
    alsa.enable        = true;
    alsa.support32Bit  = true;
    pulse.enable       = true;
    wireplumber.enable = true;
    wireplumber.extraConfig = {
      "10-disable-hfp" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
        "monitor.bluez.properties" = {
          "bluez5.roles"         = [ "a2dp_sink" "a2dp_source" ];
          "bluez5.codecs"        = [ "sbc" ];
          "bluez5.enable-sbc-xq" = true;
        };
      };
    };
  };

  services.udisks2.enable = true;
  services.flatpak.enable = true;

  # privileged programs
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # virtualisation.waydroid.enable = true;
  # virtualisation.docker.enable = true;
  # virtualisation.docker.package = pkgs.docker;
  
  programs.nix-ld.enable = true; # so that pre-compiled Python binaries can run
  
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true; 

  # Sway (actual config is in home.nix)
  programs.sway = {
    enable              = true;
    wrapperFeatures.gtk = true;
  };

  # Login manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${lib.getExe pkgs.tuigreet} --time --remember --cmd sway";
      user    = "greeter";
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type             = "idle";
    StandardInput    = "tty";
    StandardOutput   = "tty";
    StandardError    = "journal";
    TTYReset         = true;
    TTYHangup        = true;
    TTYVTDisallocate = true;
  };

  system.stateVersion = "25.11";
}
