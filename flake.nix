{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doom-private.url = "github:syryuauros/doom-private";
    doom-private.flake = false;
    nix-doom-emacs.url = "github:syryuauros/nix-doom-emacs";
    nix-doom-emacs.inputs.doom-private.follows = "doom-private";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      nixpkgs = {
        inherit system;
        overlays = [ inputs.nix-doom-emacs.overlay ];
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
          })
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.auros = import ./home.nix;
            #home-manager.users.auros.home.stateVersion = "22.11";

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          (import ./configuration.nix)
        ];
      };
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
