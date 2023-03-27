
{ config, lib, pkgs, ... }:
let
  auto-pull-cmd = ''${pkgs.git}/bin/git pull'';
  #auto-pull-cmd = ''${pkgs.coreutils}/bin/cd /home/auros/gits/shapemaster && ${pkgs.git}/bin/git pull'';
  #auto-pull-cmd = "cd /home/auros/gits/shapemaster && [ ! `git pull | grep file | wc -l` = 0 ]";
  write-cmd = ''echo "pull-success" >> /home/auros/test/cront.txt'';
  rebuild-cmd = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake /home/auros/gits/my_nixos#syryuhds --impure";
in
{
  systemd.timers."auto-pull" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "1m";
        Unit = "auto-pull.service";
      };
  };

  systemd.services."auto-pull" = {
    script = ''
      ${rebuild-cmd}
    '';
    serviceConfig = {
      Type = "oneshot";
      User= "root";
    };
  };
}
      #*/1 * * * *      auros    cd /home/auros/gits/shapemaster && [ ! `git pull | grep file | wc -l` = 0 ] && echo "pull-success" >> /home/auros/test/cront.txt
      #"*/1 * * * *      auros    cd /home/auros/gits/shapemaster && [ ! `git pull | grep file | wc -l` = 0 ] && sudo nixos-rebuild switch --flake /home/auros/gits/my_nixos#syryuhds --impure"

      #*/1 * * * *      root    ${auto-pull-cmd} && ${rebuild-cmd}
