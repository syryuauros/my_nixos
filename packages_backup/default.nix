inputs: system:
let

  inherit (inputs.self) nixosConfigurations;

  pkgs = import inputs.nixpkgs { inherit system; };
  #pkgs = import ../pkgs.nix { inherit inputs system; };
  # mylib = import ../lib pkgs;

  # inherit (builtins) mapAttrs;
  # inherit (mylib) get-toplevel get-isoimage;

  # nixosSystems =
  #   (mapAttrs (_ : get-toplevel) nixosConfigurations) // {
  #     iguazu = get-isoimage nixosConfigurations.iguazu;
  #     usb = get-isoimage nixosConfigurations.usb;
  #   };

  # remote-install = { system-toplevel, mount-point ? "/mnt" }:
  #   pkgs.writeShellScriptBin "remote-install" ''
  #     ${pkgs.nix}/bin/nix copy ${system-toplevel}
  #     ${pkgs.nixos-install}/bin/nixos-install --root ${mount-point} --system ${system-toplevel} --no-root-passwd
  #   '';

  inherit (pkgs) callPackage;

  # tmux = callPackage ./tmux {};
  # tex = callPackage ./tex {};
  myfonts = import ./myfonts { inherit (pkgs) runCommand nerdfonts; };
  # myscripts = callPackage ./myscripts {};
  # doom-private = callPackage ./doom-private {};

  in myfonts
# in nixosSystems
# // myfonts
# // myscripts
# //
# {
#   inherit tmux tex doom-private;
# }
