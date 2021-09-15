{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
, runCommand ? pkgs.runCommand
, mkDerivation ? pkgs.stdenv.mkDerivation
}:
let
	nixpkgs-src = fetchFromGitHub {
    	owner = "NixOS";
    	repo = "nixpkgs";
    	rev = "21.05";
    	sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
	};
	libFuncs = builtins.attrNames pkgs.lib;
in
mkDerivation {
    name = "nixref-ref";
	src = ./.;

    buildInputs = with pkgs; [
        gcc
    ];

	dontFixup = true;
    buildPhase = ''
        gcc $src/parse.c
        cat ${nixpkgs-src}/lib/*.nix | ./a.out > ref.json
        '';

    installPhase = ''
        mkdir -p $out
        cp ref.json $out/ref.json
    '';

	shellHook = ''
		export NIXPKGS_SRC="${nixpkgs-src}"
	'';
}
