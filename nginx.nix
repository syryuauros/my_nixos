{ config, lib, pkgs, ... }: {

  services.nginx = {
    enable = true;
    virtualHosts."syryu.xyz"= {
      listen = [ { addr = "0.0.0.0"; port = 80; ssl = false; } ];
      locations."/" = {
        proxyPass = "http://localhost:35901";
        #proxyWebsockets = true;
      };
      # locations."/ws" = {
      #   proxyPass = "http://localhost:35903";
      #   proxyWebsockets = true;
      # };
    };
    virtualHosts."websocket"= {
      listen = [ { addr = "0.0.0.0"; port = 80; ssl = false; } ];
      # locations."/" = {
      #   proxyPass = "http://localhost:35901";
      #   #proxyWebsockets = true;
      # };
      locations."/" = {
        proxyPass = "http://localhost:35903";
        proxyWebsockets = true;
      };
    };

  };
}
