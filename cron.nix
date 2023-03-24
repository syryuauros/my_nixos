

{ config, lib, pkgs, ... }: {

  services.cron = {
    enable = true;
    systemCronJobs = [''
      */5 * * * *     auros      git --git-dir=/home/auros/gits/shapemaster/.git --work-tree=/home/auros/gits/shapemaster pull
      ''];
    };
  }

# http://brownbears.tistory.com/191 -- reverse proxy server concepts
