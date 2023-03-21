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
      locations."/ws/" = {
        proxyPass = "http://localhost:35903";
        proxyWebsockets = true;
        };
      };

    virtualHosts."__"= {
      listen = [ {addr = "0.0.0.0"; port = 50696; ssl = false; } ];
      #root = "/home/auros/gits/shapemaster/daily";
      locations."/" = {
        root = /home/auros/gits/shapemaster/daily;
        extraConfig =
          "autoindex on;"
          ;
        };
      };

    };
  }

# http://brownbears.tistory.com/191 -- reverse proxy server concepts
# https://soojong.tistory.com/entry/Nginx%EB%A1%9C-%EC%A0%95%EC%A0%81-%EC%BB%A8%ED%85%90%EC%B8%A0-%EC%A0%9C%EA%B3%B5%ED%95%98%EA%B8%B0
# https://velog.io/@devjooj/Server-Ngnix-%EC%99%9C-%EC%82%AC%EC%9A%A9%ED%95%A0%EA%B9%8C
