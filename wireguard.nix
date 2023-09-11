{ config, lib, pkgs, ... }: {

  networking ={
    nat.enable = true;
    nat.externalInterface = "eth0";
    nat.internalInterface = [ "sra0" ];
    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
  };
  networking.wireguard.interfaces = {
    sra0 = {
      ips = [ "10.100.0.1/24"];
      listenPosrt = 51820;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      privateKeyFile = "~/wireguard-keys/private/";

      peers = [
        {
          publicKey = "kNteCelNfQlGjhhWcP/OtE9Rc12bdPMgpDsmzx7kpn8=";
          allowedIPs = [ "10.100.0.3/32" ];
        }

        {
          publicKey = "Uzld/a3SscjfNlLKIre+wuesxt1dyk3pJN6SqZJZ1XI=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };

  }

#https://nixos.wiki/wiki/WireGuard
#https://github.com/jjdosa/mysystem/blob/a8d661be2c7c9a739211f772de574a8e5138dd6d/nixosConfigurations/features/wireguard.nix
