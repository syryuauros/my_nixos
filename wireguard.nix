{ name, port, wg-key, wg-ips, allowedIPs } : { config, ... }:

{
  networking.firewall = {
    allowedUDPPorts = [ port ];
  };

  #age.secrets.wg.file = wg-key;

  networking.wireguard.interfaces = {
    "${name}" = {
      ips = wg-ips;
      listenPort = port;
      privateKey = wg-key;
      #privateKeyFile = config.age.secrets.wg.path;
      peers = [
        {
          publicKey = "i0ZorMa8S9fT8/TI/U01K5HGhYPGRESnrq36k2I7MBU=";
          inherit allowedIPs;
          endpoint = "121.136.244.64:${toString port}";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
