{
  home = {
    shellAliases = {
      nginx_confirm_config="ls /nix/store/ | grep nginx.conf | xargs -I {} stat /nix/store/{} | grep -E 'File|Birth'";
      nginx_update= ''
       rsync -avu --delete /home/auros/gits/shapemaster/daily/ /var/www/SM_daily/ |
       rsync -avu --delete /home/auros/gits/programming/python3_10/projects/webUI/test1/html/ /var/www/webUI01/ |
       rsync -avu --delete /home/auros/gits/ANS/webTest/ /var/www/webTest/
       rsync -avu --delete /home/auros/gits/programming/python3_10/projects/webUI/test4/html/ /var/www/webUI01/
       rsync -avu --delete /home/auros/gits/programming/python3_10/projects/ML/hybrid/thicknessDynamicPrecision/htmlDPDB/ /var/www/ML_hybrid_DPrec/
      '';
      nginx_authority_setup="sudo chown -R auros:users /var/www";
    };
  };
}

       #rsync -avu --delete /home/auros/gits/programming/Haskell/projects/miso/result/bin/app.jsexe/ /var/www/miso/