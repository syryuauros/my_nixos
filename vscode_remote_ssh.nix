{ config, lib, pkgs, ... }:
  let

  in {
    environment.systemPackages = with pkgs; [
      
    ];
    systemd.tmpfiles.rules = [
      "d /home/youruser/.vscode-server 0700 auros -"
    ];


  }
