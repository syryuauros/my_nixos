{ pkgs, config, inputs, lib, ... }: let

  mytex =
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-full
        pgf
        ;
    });

  mynerdfonts = pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; };
  mypackages = inputs.self.packages.${pkgs.system};

  inherit (mypackages)
    noto-sans-kr
    noto-serif-kr
    seoul-hangan
    # mynerdfonts
  ;
in {
  home.username = "auros";
  home.homeDirectory = "/home/auros/";

  programs.home-manager.enable = true;
  programs.jq.enable = true;
  programs.bat.enable = true;

  fonts.fontconfig.enable = true;
  # nixpkgs.config.permittedInsecurePackages = [ "tightvnc-1.3.10" ];

  imports = [
    inputs.myxmonad.homeManagerModules.default
    inputs.nix-doom-emacs.hmModule
    ./tightvncHome.nix
    ./qemuHome.nix
    ./nginxHome.nix
    # ./xpraHome.nix
  ];
  mysystem.windowManager.xmonad.enable = true;

  home.packages = [
  pkgs.ripgrep
  pkgs.hyperfine
  mynerdfonts
  mytex
  pkgs.kolourpaint
  inputs.myxmonad.packages.${pkgs.system}.xmonad-restart
  #fonts
  noto-sans-kr
  noto-serif-kr
  # # nerdfonts
  # pkgs.symbola
  seoul-hangan
  # mynerdfonts
  pkgs.noto-fonts-cjk
  # noto-fonts
  pkgs.material-design-icons
  pkgs.weather-icons
  pkgs.font-awesome
  pkgs.emacs-all-the-icons-fonts
];
  # home.packages = with pkgs;[
  #   ripgrep
  #   hyperfine
  #   mynerdfonts
  #   mytex
  #   kolourpaint
  #   # inputs.myxmonad.packages.${pkgs.system}.xmonad-restart
  # ];

#  imports = [
#    inputs.nix-doom-emacs.hmModule
#  ];

  services.flameshot.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "hproxy" = {
        forwardX11 = true;
        hostname = "192.168.12.180";
        port = 2220;
        user = "solma";
      };
      "gitea" = {
        hostname = "20.20.1.1";
        proxyJump = "hproxy";
        user = "solma";
      };
      "githubObsidian" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_obsidian_git";
      };
    };
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./packages/doom-private;
    doomPackageDir = pkgs.linkFarm "my-doom-packages" [
      # straight needs a (possibly empty) `config.el` file to build
      { name = "config.el"; path = pkgs.emptyFile; }
      { name = "init.el"; path = ./packages/doom-private/init.el; }
      { name = "packages.el"; path = ./packages/doom-private/packages.el; }
    ];
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      set -o vi
      ${pkgs.neofetch}/bin/neofetch
    '';
  };

  programs.zathura = {
    enable = true;
    options = {
      incremental-search = true;
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set-option -ga terminal-overrides ",*256col*:Tc:RGB"
    '';
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; } # surfingkeys
      { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; } # grammarly
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # darkreader
      { id = "chphlpgkkbolifaimnlloiipkdnihall"; } # onetab
      { id = "lpfemeioodjbpieminkklglpmhlngfcn"; } # WebChatGPT
      { id = "cipccbpjpemcnijhjcdjmkjhmhniiick"; } # SciSpace
      { id = "cbgecfllfhmmnknmamkejadjmnmpfjmp"; } # ChatGPT>>Summarize & Chat
      { id = "nmmicjeknamkfloonkhhcjmomieiodli"; } # YouTube Summary with ChatGPT & Claude
      { id = "hlgbcneanomplepojfcnclggenpcoldo"; } # Perplexity - AI Companion
    ];
  };
  # extensions ID check (below, answer from chatgpt)
  # Open Chrome and go to the URL chrome://extensions
  # Enable "Developer mode" by clicking the toggle switch in the upper right corner.
  # Find the extension you want the ID for and click on the "Details" button.
  # The ID for the extension will be listed on the extension details page. It is a long string of letters and numbers.
  # Alternatively, you can right-click on the extension icon in the Chrome toolbar and select "Manage extensions". This will take you to the "chrome://extensions" page and you can follow the steps above to find the extension ID.



  programs.git = {
    enable = true;
    userEmail = "sy.ryu@aurostech.com";
    userName = "syryuauros";
  };

  xdg.enable = true;

  xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    x-scheme-handler/http=brave-browser.desktop
    x-scheme-handler/https=brave-browser.desktop
    x-scheme-handler/ftp=brave-browser.desktop
    x-scheme-handler/chrome=brave-browser.desktop
    text/html=brave-browser.desktop
    application/x-extension-htm=brave-browser.desktop
    application/x-extension-html=brave-browser.desktop
    application/x-extension-shtml=.desktop
    application/xhtml+xml=brave-browser.desktop
    application/x-extension-xhtml=brave-browser.desktop
    application/x-extension-xht=brave-browser.desktop
    application/pdf=org.pwmt.zathura.desktop
    application/pdf=org.pwmt.zathura.desktop
    inode/directory=xfce4-file-manager.desktop
    image/png=sxiv.desktop
    image/jpeg=sxiv.desktop
    text/plain=nvim.desktop
  '';

  home.shellAliases = {
    # ls   = "exa";
    du   = "ncdu --color dark";
    la   = "ls -a";
    ll   = "ls -l";
    lla  = "ls -al";
    ec   = "emacsclient";
    ecc  = "emacsclient -c";
    #ping = "prettyping";
    ".." = "cd ..";
    p = "pushd";
    d = "dirs -v";
    o = "xdg-open";
    xterm="xterm +132 -fg grey70 -bg grey20 -fa 'Monospace' -fs 11";
    #xterm color name https://www.ditig.com/256-colors-cheat-sheet, $ xterm -help
    tmux="xterm +132 -fg grey70 -bg grey20 -fa 'Mnospace' -fs 11 -e tmux";
    pkgs="/nix/var/nix/profiles/per-user/root/channels/nixos/pkgs";
    lib="/nix/var/nix/profiles/per-user/root/channels/nixos/lib";
    picom_80="picom -cf -i 0.8 --use-ewmh-active-win &";
    #xset s off -dpms
    #xset s on
    #xset s 600
  };

  home.sessionVariables = {

      NIX_PATH =
        lib.concatStringsSep ":" [
        "$HOME/.nix-defexpr/channels"
        "nixpkgs=${inputs.nixpkgs.outPath}"
        "nixos-config=/home/auros/gits/my_nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];

    };

  home.stateVersion = "23.05";
}
