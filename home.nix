{ pkgs, config, ... }:

{
  home.packages = with pkgs;[
    ripgrep
  ];

}
