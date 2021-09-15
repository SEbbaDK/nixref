#!/bin/sh
output=${1:-index.html}
elm make src/Main.elm --output=$output
sed 's/{ node:/{ flags: "", node:/' -i $output
