{ config, lib, pkgs, ... }:

{

  services.dhcpd4 = {
    enable = true;
    # machines = [
    #   {
    #     ethernetAddress = "00:01:29:78:70:bb";
    #     hostName = "hproxy";
    #     ipAddress = "192.168.12.171";
    #   }
    # ];
    interfaces = [
      "enp1s0"
    ];
    extraConfig = ''
      subnet 192.168.12.0 netmask 255.255.255.0 {
        option routers  192.168.12.1;
        option subnet-mask  255.255.255.0;
        option domain-search  "hrpoxy.xyz";
        option domain-name-servers 168.126.63.1;
        range 192.168.12.160 192.168.12.179;
      }    '';
  };
  #
  # services.kea.dhcp4 = {
  #   enable = true;
  #   settings = {
  #     interfaces-config = {
  #       interfaces = [
  #         "eth0"
  #       ];
  #     };
  #     lease-database = {
  #       name = "/var/lib/kea/dhcp4.leases";
  #       persist = true;
  #       type = "memfile";
  #     };
  #     rebind-timer = 2000;
  #     renew-timer = 1000;
  #     subnet4 = [
  #       {
  #         pools = [
  #           {
  #             pool = "192.168.12.10 - 192.168.12.240";
  #           }
  #         ];
  #         subnet = "192.168.12.0/24";
  #       }
  #     ];
  #     valid-lifetime = 4000;
  #       };
  # };

}
