{ config, lib, pkgs, ... }: {

  services.nginx = {
    enable = true;
    virtualHosts."_"= {
      listen = [ { addr = "0.0.0.0"; port = 80; ssl = false; } ];
      locations."/" = {
        proxyPass = "http://localhost:35901";
        #proxyWebsockets = true;
      };
      locations."/ws/" = {
        proxyPass = "http://localhost:35903";
        proxyWebsockets = true;
      };


      # locations."/ws" = {
      #   proxyPass = "http://0.0.0.0:35903";
      #   proxyWebsockets = true;
      # };
    };

    # virtualHosts."192.168.12.135"= {
    #  listen = [ { addr = "0.0.0.0"; port = 80; ssl = false; } ];
    #   locations."/ws" = {
    #     proxyPass = "http://localhost:35903";
    #     proxyWebsockets = true;
    #   };
    #  # locations."/" = {
    #  #   proxyPass = "http://localhost:35903";
    #  #   proxyWebsockets = true;
    #  # };
    # };

  };
}

# http://brownbears.tistory.com/191 -- reverse proxy server concepts
