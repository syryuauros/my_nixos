{ pkgs, config, ... }:

{

  fonts.fontconfig.enable = true;
  home.packages = with pkgs;[
    ripgrep
    starship
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    hyperfine
  ];

}
