 systemd.services.fmmdosa-api = {
    enable = true;
    description = "fmmdosa-api";
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${pkgs.fmmdosa-api}/bin/fmmdosa-api";
  };
  networking.firewall.allowedTCPPorts = [ 80 443 3000 1714 1764 ]; # 1714, 1764 for kde connect, 80, 443 for pixiecore, 3000 for fmmdosa-api
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."fmmdosa-api" = {

      # enableACME = true;
      # addSSL = true;

      locations."/fmmdosa-api".proxyPass =
          "http://localhost:3000";
    };
  };
