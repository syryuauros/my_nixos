{ config, lib, pkgs, ... }:
  let
      # # Use a specific version of Xpra for stability
      # xpraVersion = "4.2.1";

      # # Start an Xpra server with a test window
      startCommand = ''
        xpra start :100 --bind-tcp=0.0.0.0:10000 --html=on --start-child=xterm
      '';

      displayOption = ''
        display=:100
      '';

      # # Generate a systemd service for the Xpra server
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.xpra}/bin/xpra start :100 --bind-tcp=0.0.0.0:10000 --html=on --start-child=xterm";
        Restart = "always";
      };

  in {

    # Build Xpra with web browser client support
    services.xserver.displayManager.xpra = {
      enable = true;
#      extraOptions = [ startCommand displayOption ];
    };

    # light weight window manager for move execution window when execute program via xpra
    environment.systemPackages = with pkgs; [
      openbox
    ];

  }
