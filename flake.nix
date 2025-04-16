{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs2305.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils/main";

    myxmonad.url = "github:syryuauros/myxmonad";
    doom-private.url = "github:syryuauros/doom-private";
    doom-private.flake = false;
    nix-doom-emacs = {
      url = "github:syryuauros/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs2305 = import inputs.nixpkgs2305 {
        inherit system;
        config.permittedInsecurePackages = [
          "tightvnc-1.3.10"
          "electron-24.8.6"
        ];

        config.allowUnfree =true;
        # config.allowInsecure = true;
      };

      pkgsUnstable = import inputs.nixpkgsUnstable {
        inherit system;
        config.permittedInsecurePackages = [
        ];

        config.allowUnfree =true;
      };

      nixpkgs = {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [ "tightvnc-1.3.10" "electron-24.8.6" ];
        overlays = [
          # inputs.nix-doom-emacs.overlays.default
          # inputs.nix-doom-emacs.overlay
              (final: prev: {
                xmonad-restart = inputs.myxmonad.packages.${system}.xmonad-restart;
                tightvnc = pkgs2305.tightvnc;
                xpra = prev.xpra.override {
                  # enableHtml5 = true;
                };
                xpraHtml5 = pkgsUnstable.xpra-html5;
              })
        ];  };
      pkgs = import inputs.nixpkgs nixpkgs;

      inherit (inputs.nixpkgs.lib) genAttrs;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = genAttrs supportedSystems;
    in
    {
    imports = [
        ./test.nix
      ];
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
          # ({pkgs, ...} :{
          #   services.emacs = {
          #     enable = true;
          #     package = pkgs.doom-emacs;
          #      # client.enable = true;
          #    };
          #  })
          # inputs.home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.auros = import ./home.nix;
          #   home-manager.extraSpecialArgs = {
          #     inherit inputs;
          #   };

          #   #home-manager.users.auros.home.stateVersion = "22.11";

          #   # Optionally, use home-manager.extraSpecialArgs to pass
          #   # arguments to home.nix
          # }
          (import ./configuration.nix)
          (import ./allowInsecure.nix)
          (import ./nginx.nix)
          (import ./tightvnc.nix)
          (import ./qemu.nix)
          (import ./wireguard.nix)
          (import ./mariaDB.nix)
          (import ./obsidian.nix)
          (import ./rclone.nix)
          # (import ./dhcpd4.nix)
          #(import ./timer.nix)
          #(import ./cron.nix)
          # (import ./xpra.nix)
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
# wallPapers update: wallPaper git push -> my_xmonad nix flake update-> my_xmonad git push -> my_nixos nix flake update -> home-manager switch
#
# xmonad add 'flameshot gui'hotkey update:
#  myxmonad/modules/home-manager/myxmonad.nix -> add flameshot to home.packages
#  xmonad.hs -> modify key bindings for 'flameshot gui' to 'M-C-S-s'
#  git push to remote (myxmonad)
#  terminal: myxmonad> nix flake update
#  terminal: my_nixos> nix flake update
#  terminal: my_nixos> sudo nixos-rebuild switch --flake .#syryuhds --impure
#  terminal: my_nixos> home-manager switch --flake .#auros --impure
#
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
