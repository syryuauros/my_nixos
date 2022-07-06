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
  };

  outputs = inputs: {
    nixosConfigurations =
      let
        system = "x86_64-linux";
      in
      {
      syryuhds = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({
             nixpkgs = {
               inherit system;
               overlays = [ inputs.nix-doom-emacs.overlay ];
             };
          })
          ({pkgs, ...} :{
            services.emacs = {
              enable = true;
              package = pkgs.doom-emacs;
              # client.enable = true;
            };
          })
          (import ./configuration.nix)
        ];
      };
    };
  };

}
