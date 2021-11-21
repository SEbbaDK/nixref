{ pkgs ? import <nixpkgs> {}
, mkDerivation ? pkgs.stdenv.mkDerivation
}:
let
	nixpkgs-src = pkgs.fetchFromGitHub {
    	owner = "NixOS";
    	repo = "nixpkgs";
    	rev = "21.05";
    	sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
	};
in
mkDerivation {
    name = "nixref-ref";
	src = ./.;

    buildInputs = with pkgs; [
        ghc haskellPackages.hnix
    ];

	shellHook = ''
		export NIXPKGS_SRC="${nixpkgs-src}"
	'';
}
