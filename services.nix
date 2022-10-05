 systemd.services.fmmdosa-api = {
    enable = true;
    description = "fmmdosa-api";
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${pkgs.fmmdosa-api}/bin/fmmdosa-api";
  };
  networking.firewall.allowedTCPPorts = [ 80 443 3000 ];

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
