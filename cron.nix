

{ config, lib, pkgs, ... }: {

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * *  auros  [ ! `git fetch > /dev/null 2>&1 && git pull | grep file | wc -l` = 0 ] && sudo nixos-rebuild switch --flake ~/gits/my_nixos#syryuhds --impur"
      ];
    };
  }

# http://brownbears.tistory.com/191 -- reverse proxy server concepts
