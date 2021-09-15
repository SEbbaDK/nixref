{ pkgs ? import <nixpkgs> { }
, mkDerivation ? pkgs.stdenv.mkDerivation
, # Dependencies
  crystal ? pkgs.crystal
, shards ? pkgs.shards
, pkg-config ? pkgs.pkg-config
, openssl ? pkgs.openssl
, crystal2nix ? pkgs.crystal2nix
, buildCrystalPackage ? pkgs.crystal.buildCrystalPackage
, ...
}:
let
  shard = builtins.readFile ./shard.yml;
  version = builtins.head (builtins.match ".*version: ([0-9.]+).*" shard);
in
(buildCrystalPackage rec {
  pname = "nixref";
  inherit version;

  buildInputs = [ openssl openssl.out ];
  src = pkgs.runCommand "source" { } ''
    mkdir $out
    ln -s ${./shard.yml} $out/
    ln -s ${./server.cr} $out/
  '';

  format = "shards";
  lockFile = ./shard.lock;
  #shardsFile = ./shards.nix;

  # Disable tests until they work
  doCheck = false;
  doInstallCheck = false;
})
# This line enables quicker builds
.overrideAttrs (old: { buildPhase = builtins.replaceStrings [ "--release" ] [ "" ] old.buildPhase; })
