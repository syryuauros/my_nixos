{ lib, stdenv, emacs, coreutils }:

stdenv.mkDerivation {
  name = "doom-private";
  src = lib.sourceByRegex ./. [ "README.org" ];

  buildInputs = [ emacs coreutils ];
  buildPhase = ''
    cp $src/* .
    # Tangle org files
    emacs --batch -Q \
      -l org \
      README.org \
      -f org-babel-tangle
  '';

  dontUnpack = true;

  installPhase = ''
    install -D -t $out *.el
  '';
}
