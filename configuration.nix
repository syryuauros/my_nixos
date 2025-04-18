# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # configuration.nix와 hardware-configuration.nix의 디렉토리가 다르기 때문에 nixos-rebuild ... 뒤에 --impure 옵션이 붙어야 한다.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Seoul";

  nixpkgs.config.allowUnfree = true;


  nix = {
  # package = pkgs.nixUnstable;
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
  #   experimental-features = nix-command flakes ca-references
      keep-outputs = true
      keep-derivations = true
    '';
    settings.trusted-users = [ "root" "@admin" "@wheel" ];
    # settings.settings.trusted-users = [ "root" "@admin" "@wheel" ];
    #binaryCaches = [
    settings.substituters = [
      "https://cache.nixos.org/"
      "https://cachix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    #binaryCachePublicKeys = [
    settings.trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  networking = {
    hostName = "auros";
    networkmanager.enable = true;
  };


  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  #i18n.inputMethod = {
  #  enabled = "ibus";
  #  ibus.engines = with pkgs.ibus-engines; [ hangul ];
  # enabled = "ibus";
  #};
  # 한글 및 폰트
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      # type = "kime";
      # enable = true;
      enabled = "kime";
      kime = {};
  };
};

  #noto-fonts added
  #fonts.enableFontDir = true;
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    inter
  ];

  # fonts.packages = with pkgs; [
  #   noto-fonts
  #   noto-fonts-cjk-sans
  #   inter
  # ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;
  services.xserver.desktopManager.gnome.enable = true;


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
    # sound.enable = true;
    hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

    users.mutableUsers = false;
    users.users.auros = {
      isNormalUser = true;
      uid = 1000;
      home = "/home/auros/";
      extraGroups = [ "wheel" "networkmanager" ];
    # to generate : nix-shell -p mkpasswd --run 'mkpasswd -m sha-512'
      hashedPassword = "$6$4eILJE5YFY$RDB8ra1mdoFaPscoDnEgoQBI83StsUEVhwUp2mAWK0b082ocZ44hdLBlRTPt.6IayLqr/6wuwRCTpxAacfE56.";
      openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwOvMlnEB1Qk2Aj/R7CcCSnzu3LlBrS6eh75IZzFEe4 auros"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILsg3JqQm0WwFW2CRNzJOwjyy8DPN+2zKGLvd4tWpUP"
    ];
  };
  #   users.users.auroskks = {
  #     isNormalUser = true;
  #     uid = 1001;
  #     home = "/home/auroskks";
  #     extraGroups = [ "networkmanager" ];
  #   # to generate : nix-shell -p mkpasswd --run 'mkpasswd -m sha-512'
  #     hashedPassword = "$6$IJjCksKJ2BG1FYYe$MYwMQ5bR8Bd5F7bx79VAD4CxiI6Hy824C39LYcWHio5AygMC9/sSmxfOwov5KJpe4UN7ib.s2UtFVUIQD4m8C0";
  #     openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwOvMlnEB1Qk2Aj/R7CcCSnzu3LlBrS6eh75IZzFEe4 auros"
  #   ];
  # };



  # List packages installed in system profile. To search, run:
  # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      git
      ripgrep
      kime
     #gnuplot
      brave
      tmux
     #tightvnc
    ];

    environment.variables = {
      GTK_IM_MODULE = "kime";
      QT_IM_MODULE = "kime";
      XMODIFIERS = "@im=kime";
    };

    # nix options for derivations to persist garbage collection
    #nix.extraOptions = ''
    #  keep-outputs = true
    #  keep-derivations = true
    #'';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  #
  # default editor setting from nano to vi editor
    programs.neovim.defaultEditor = true;

  # List services that you want to enable:
    services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      # forwardX11 = true;
      settings.X11Forwarding = true;
      extraConfig = ''
      X11DisplayOffset 10
      X11UseLocalhost no
      UseLogin no
      '';
    };
    security.sudo.wheelNeedsPassword = false;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
