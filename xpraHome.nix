{ config, lib, pkgs, ... }:
let

in
{
  home = {
    shellAliases = {
      xpraHtml5Start="xpra start :100 --start='xterm +132 -fg grey70 -bg grey20 -fa 'Mnospace' -fs 11 -e tmux' --bind-tcp=0.0.0.0:10000 --html=/nix/store/zgxa709dwaq2i6yh7jjqcnb1fmjjrm9y-xpra-html5/share/xpra/www/ --daemon=no --debug=all --log-file=/tmp/xpra.log";
    };
  };
}
