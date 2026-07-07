#!/bin/sh
tmpdir=`mktemp -d`
file=$1
ffmpeg -i "$file" -vf fps=10,scale=-1:720:-1:flags=lanczos,palettegen "$tmpdir"/palette.png
ffmpeg -i "$file" -i "$tmpdir"/palette.png -filter_complex "fps=10,scale=-1:720:-1:flags=lanczos[x];[x] [1:v]paletteuse" "$file".gif
