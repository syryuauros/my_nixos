{ pkgs, config, ... }: let

  mytex =
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-full
        pgf
        ;
    });

  mynerdfonts = pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; };

in {

  programs.home-manager.enable = true;
  programs.jq.enable = true;
  programs.bat.enable = true;

  fonts.fontconfig.enable = true;
  home.packages = with pkgs;[
    ripgrep
    hyperfine
    mynerdfonts
    mytex
    kolourpaint
  ];

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

  programs.brave = {
    enable = true;
    extensions = [
      { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; } # surfingkeys
      { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; } # grammarly
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # darkreader
    ];
  };

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
    ping = "prettyping";
    ".." = "cd ..";
    p = "pushd";
    d = "dirs -v";
    o = "xdg-open";
  };

}
