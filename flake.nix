{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils/main";
    myxmonad.url = "github:syryuauros/myxmonad";
    doom-private.url = "github:jjdosa/doom-private";
    doom-private.flake = false;
    nix-doom-emacs = {
      url = "github:jjdosa/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nix-doom-emacs.url = "github:syryuauros/nix-doom-emacs";
    #nix-doom-emacs.inputs.doom-private.follows = "doom-private";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      nixpkgs = {
        inherit system;
        overlays = [
          # inputs.nix-doom-emacs.overlays.default
          # inputs.nix-doom-emacs.overlay
              (final: prve: {
                xmonad-restart = inputs.myxmonad.packages.${system}.xmonad-restart;
              })
        ];  };
      pkgs = import inputs.nixpkgs nixpkgs;

      inherit (inputs.nixpkgs.lib) genAttrs;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = genAttrs supportedSystems;
      hds1-wireguard = import ./wireguard.nix {
        name = "hds1";
        port = 51820;
        wg-key = "UGN+tylsszZUiPyoYF8n0wkOfkmsQQWHHeVHdJTsRVY=";
        wg-ips = [ "20.20.20.20/32" ];
        allowedIPs = [ "20.20.0.0/16" ];
      };

    in
    {
    packages = forAllSystems (import ./packages inputs);
    # packages = import ./packages { inherit inputs system; };

    homeConfigurations = {
      auros =  inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";  #https://discourse.nixos.org/t/fn-homemanagerconfiguration-missing-arg-system-but-why/21192
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        #home.username = "syryu@auros";
        #home.homeDirectory = "/home/auros";
        modules = [ ./home.nix ];
        extraSpecialArgs = {  inherit inputs; };
       };
    };

    nixosConfigurations = {
      syryuhds = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ inherit nixpkgs;})
          hds1-wireguard
          (import ./configuration.nix)
          #(import ./nginx.nix)
          (import ./cron.nix)
          (import ./qemu.nix)
          (import ./tightvnc.nix)
        ];
      };
      v15 = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ inherit nixpkgs;})
          (import ./nixosConfigurations/v15/configuration.nix)
        ];
      };
      usb = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({modulesPath, ... }: {
            imports = [
              (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix")
            ];
          })
          ( {config, ...}: {
            users.users.auros = {
              isNormalUser = true;
              uid = 1000;
              home = "/home/auros";
              extraGroups = [ "wheel" "networkmanager" ];
            # to generate : nix-shell -p mkpasswd --run 'mkpasswd -m sha-512'
              hashedPassword = "$6$4eILJE5YFY$RDB8ra1mdoFaPscoDnEgoQBI83StsUEVhwUp2mAWK0b082ocZ44hdLBlRTPt.6IayLqr/6wuwRCTpxAacfE56.";
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxdbcY6seNTSAZm4s5o+aMrZehE5tqEWub+rs7sLmh2 auros@auros"
              ];
            };

            networking.networkmanager.enable = true;
            systemd.services.NetworkManager-wait-online.enable = false;

            nix.settings.trusted-users = [
              "auros" "root" "@admin" "@wheel"
            ];

            # Enable the OpenSSH daemon.
            services.openssh.enable = true;
            services.openssh.settings.X11forwarding = true;
            services.openssh.settings.PermitRootLogin = "yes";

            users.users.root.openssh.authorizedKeys.keys = config.users.extraUsers.auros.openssh.authorizedKeys.keys;
          })
        ];
      };
    };
    devShells.x86_64-linux.default = pkgs.mkShell rec {
      nativeBuildInputs = with pkgs; [
        nix
        home-manager
        xmonad-restart
      ];
    };

  };

}
# home-manager set up & use nixos version 22.11
# emacs setup
#     org-roam-ui :: https://www.youtube.com/watch?v=HXa5fZjbioA
#
# org-mode, tagging
#      https://thagomizer.com/blog/2018/05/30/org-mode-tagging.html
#
#
# home-manager option
#      https://mipmip.github.io/home-manager-option-search/
