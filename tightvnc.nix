{ config, lib, pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [ "tightvnc-1.3.10" ];
  environment.systemPackages = with pkgs; [
    tightvnc
  ];

}


  # $ vncviewer [server-ip]
  # $ vncviewer -quality 5 [server-ip]
  # $ vncviewer -help
