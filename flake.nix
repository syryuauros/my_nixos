{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      syryuhds = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./configuration.nix)
        ];
      };
    };
  };

}
