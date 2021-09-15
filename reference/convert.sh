#!/bin/sh

out=${1:-./}
out=${out%/} # strip the trailing slashes

for f in $(find -name "*.nix")
do
    echo Converting $f
    mkdir -p "$out/$(dirname $f)"
    nix eval "(import ./$f)" --json > "$out/${f%.nix}.json"
done

