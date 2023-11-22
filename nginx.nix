{ config, lib, pkgs, ... }: {

  services.nginx = {
    enable = true;

    virtualHosts."_"= {
      listen = [ { addr = "0.0.0.0"; port = 80; ssl = false; } ];
      locations."/" = {
         proxyPass = "http://localhost:35901";
        #root = "/home/auros/gits/shapemaster/daily/test2.html";
        #proxyWebsockets = true;
        };
      locations."/ws" = {
        proxyPass = "http://localhost:35903";
        proxyWebsockets = true;
        };
      };

    virtualHosts."__"= {
      listen = [ {addr = "0.0.0.0"; port = 50696; ssl = false; } ];
      #root = "/home/auros/gits/shapemaster/daily";
      locations."/" = {
        root = "/var/www/SM_daily";
        #root = /home/auros/gits/shapemaster/daily;
        extraConfig =
          "autoindex on;"
          ;
        };
      };

    virtualHosts."___"= {
      listen = [ {addr = "0.0.0.0"; port = 50697; ssl = false; } ];
      #root = "/home/auros/gits/shapemaster/daily";
      locations."/" = {
        # root = /home/auros/gits/programming/Haskell/projects/miso/result/bin/app.jsexe;
        root = "/var/www/miso";
        # root = PATH, if we give PATH as string then it follows the path literaly, but if we just give it without "", then it makes snapshot folder in /nix/store/ that is confirmed by nix.conf file that is searched by ls /nix/store | grep nginx.conf
        # $ rsync -av --delete /home/auros/gits/shapemaster/daily/ /var/www/SM_daily/
        #    --delete option means 'enable deletion of extraneous files, you need to include the --delete option'
        # $ chown -R nginx:nginx [PATH_to_folder]     first nginx userID(/etc/passwd) 2nd nginx groupID(/etc/group)
        extraConfig =
          "autoindex on;"
          ;
        };
      };

    virtualHosts."____"= {
      listen = [ {addr = "0.0.0.0"; port = 50698; ssl = false; } ];
      #root = "/home/auros/gits/shapemaster/daily";
      locations."/" = {
        root = "/var/www/webTest";
        extraConfig =
          "autoindex on;"
          ;
        };
      };

    };
  }


# chown -R auros:users /var/www/webTest/

# http://brownbears.tistory.com/191 -- reverse proxy server concepts
# https://soojong.tistory.com/entry/Nginx%EB%A1%9C-%EC%A0%95%EC%A0%81-%EC%BB%A8%ED%85%90%EC%B8%A0-%EC%A0%9C%EA%B3%B5%ED%95%98%EA%B8%B0
# https://velog.io/@devjooj/Server-Ngnix-%EC%99%9C-%EC%82%AC%EC%9A%A9%ED%95%A0%EA%B9%8C
# https://velog.io/@0307kwon/%EC%9B%B9%EC%9D%80-%EC%96%B4%EB%96%BB%EA%B2%8C-%EB%8F%99%EC%9E%91%ED%95%A0%EA%B9%8C-1.-%EC%82%AC%EC%9A%A9%EC%9E%90%EA%B0%80-%EC%9B%B9%ED%8E%98%EC%9D%B4%EC%A7%80%EB%A5%BC-%EB%B3%B4%EA%B8%B0%EA%B9%8C%EC%A7%80
# https://velog.io/@bky373/Web-%EC%9B%B9-%EC%84%9C%EB%B2%84%EC%99%80-WAS
#https://blog.toycrane.xyz/web-was-%EC%84%9C%EB%B2%84%EC%97%90-%EB%8C%80%ED%95%B4-%EC%95%8C%EC%95%84%EB%B3%B4%EC%9E%90-34861e69ac4e
#https://yoonjong-park.tistory.com/entry/php-%EC%99%80-javascript-%EC%B0%A8%EC%9D%B4-%EC%83%81%ED%98%B8-%EA%B0%84%EC%9D%98-%ED%98%B8%EC%B6%9C-%EB%B0%A9%EB%B2%95
#https://blex.me/@baealex/php%EC%97%90%EC%84%9C-ajax-%EC%82%AC%EC%9A%A9%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95
#https://sojinhwan0207.tistory.com/145
#https://tecoble.techcourse.co.kr/post/2021-08-14-web-socket/
#https://inpa.tistory.com/entry/WEB-%F0%9F%8C%90-%EC%9B%B9-%EC%86%8C%EC%BC%93-Socket-%EC%97%AD%EC%82%AC%EB%B6%80%ED%84%B0-%EC%A0%95%EB%A6%AC
#

# | change authority       | :: | $ sudo chown -R nginx:nginx /var/www/miso |
# | confirm authority list | :: | $ bat /etc/passwd                |
# |ls /nix/store [pl] grep nginx.conf [pl] xargs -I {} stat /nix/store/{} [pl] grep -E 'File[pl]Birth'|
#
    # $ cd /nix/var/nix/profiles/
    # remove unnecessary system-[number]-link/ folder
    # be careful not to delete system/ folder!!!
    # $ nix-store --gc | nix-collect-garbage -d
