{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian
  ];
  #
}


  # $ vncviewer [server-ip]
  # $ vncviewer -quality 5 [server-ip]
  # $ vncviewer -help
  # F8 in vncviewer makes menu
#https://www.kali.org/tools/tightvnc/
