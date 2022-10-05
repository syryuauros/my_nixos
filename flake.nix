{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doom-private.url = "github:syryuauros/doom-private";
    doom-private.flake = false;
    nix-doom-emacs.url = "github:syryuauros/nix-doom-emacs";
    nix-doom-emacs.inputs.doom-private.follows = "doom-private";
    fmmdosa-api.url = "git+ssh://git@github.com/haedosa/fmmdosa-api.git";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      nixpkgs = {
        inherit system;
        overlays = [
          inputs.nix-doom-emacs.overlay
          (final: prev: {
            fmmdosa-api = inputs.fmmdosa-api.defaultPackage.${system};
            }
          )
        ];
      };
      pkgs = import inputs.nixpkgs nixpkgs;
    in
    {
    homeConfigurations = {
      auros =  inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
         ];
       };

    };

    nixosConfigurations = {
      syryuhds = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ inherit nixpkgs;})
          ({pkgs, ...} :{
            services.emacs = {
              enable = true;
              package = pkgs.doom-emacs;
              # client.enable = true;
            };

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

              proxyTimeout = "90s";

              virtualHosts."fmmdosa-api" = {

                # enableACME = true;
                # addSSL = true;

                locations."/fmmdosa-api".proxyPass =
                    "http://localhost:3000";
              };
            };

          })
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.auros = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          (import ./configuration.nix)
        ];
      };
    };
  };

}
