{ config, lib, pkgs, ... }:
  let

  in {
    environment.systemPackages = with pkgs; [
      
    ];
    systemd.tmpfiles.rules = [
      "d /home/auros/.vscode-server 0700 auros -"
    ];
    # programs.nix-ld.enable = true;
    # nix-ld.enable is included in configuration.nix



  }
