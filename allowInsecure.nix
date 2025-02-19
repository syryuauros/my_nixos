{ config, lib, pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [ "tightvnc-1.3.10" "electron-24.8.6" ];
}


  # $ vncviewer [server-ip]
  # $ vncviewer -quality 5 [server-ip]
  # $ vncviewer -help
  # F8 in vncviewer makes menu
#https://www.kali.org/tools/tightvnc/
