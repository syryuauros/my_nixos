

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
      locations."/" = {
        root = "/var/www/shapemaster/daily";
        extraConfig =
          "autoindex on;"
          ;
        };
      };

    };
  }

# http://brownbears.tistory.com/191 -- reverse proxy server concepts
