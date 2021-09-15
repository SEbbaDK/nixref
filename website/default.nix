{ pkgs ? import <nixpkgs> {}
, mkDerivation ? pkgs.stdenv.mkDerivation
}:
mkDerivation {
	name = "nixref-website";
	src = pkgs.runCommand "nixref-website-src" {} ''
		mkdir $out
		ln -s ${./elm.json} $out/elm.json
		ln -s ${./compile.sh} $out/compile.sh
		ln -s ${./src} $out/src
	'';
	buildInputs = [ pkgs.elmPackages.elm ];

	buildPhase = ''
    	mkdir $out
    	./compile.sh $out/index.html
    '';
}
