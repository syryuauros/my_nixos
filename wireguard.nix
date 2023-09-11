{ config, lib, pkgs, ... }: {

  networking.nat ={
    enable = true;
    externalInterface = "enp1s0";
    internalInterface = "sra0";
  };
  networking.wireguard.interfaces = {
    sra0 = {


      ips = [ "10.100.0.1/24"];
      listenPosrt = 51820;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp1s0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp1s0 -j MASQUERADE
      '';
      privateKeyFile = "~/wireguard-keys/private/";

      peers = [
        {
          publicKey = "Uzld/a3SscjfNlLKIre+wuesxt1dyk3pJN6SqZJZ1XI=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };

  }
