{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking ={
    nat.enable = true;
    nat.externalInterface = "enp1s0";
    nat.internalInterfaces = [ "sra0" ];
    firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 51820 ];
    };
  };
  networking.wireguard.interfaces = {
    sra0 = {
      ips = [ "10.100.0.1/24"];
      listenPort = 51820;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp1s0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp1s0 -j MASQUERADE
      '';
      privateKeyFile = "home/auros/wireguard-keys/private";
      peers = [
        {
          publicKey = "bvUdF50XkuXJqp/7emWL9nEqYC9yz7/Hy3M8ExDahlc=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };

  }

#https://nixos.wiki/wiki/WireGuard
#https://github.com/jjdosa/mysystem/blob/a8d661be2c7c9a739211f772de574a8e5138dd6d/nixosConfigurations/features/wireguard.nix
