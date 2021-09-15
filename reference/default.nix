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
	src = runCommand "nixref-ref" {} ''
		mkdir $out
		ln -s ${nixpkgs-src} $out/nixpkgs
	'';

	dontInstall = true;
	buildPhase = builtins.concatStringsSep "\n" ([
    	"echo test"
    	"mkdir $out"
	] ++ (map (s: "mkdir \"$out/${s}\"") libFuncs));

	shellHook = ''
		NIXPKGS-SRC=${nixpkgs-src}
	'';
}
