{
  home = {
    shellAliases = {
      nginx_confirm_config="ls /nix/store/ | grep nginx.conf | xargs -I {} stat /nix/store/{} | grep -E 'File|Birth'";
      nginx_update="rsync -avu --delete /home/auros/gits/shapemaster/daily/ /var/www/SM_daily/ | rsync -avu --delete /home/auros/gits/programming/Haskell/projects/miso/result/bin/app.jsexe/ /var/www/miso/";
      nginx_authority_setup="sudo chown -R auros:users /var/www";
    };
  };
}
