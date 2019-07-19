#!/bin/sh
set -e

PDF=$1
TEMP_DIR=$(mktemp -d)

echo $TEMP_DIR


echo "Converting $PDF to JEPGs..."

convert -density 150 -colorspace sRGB "$PDF" +adjoin -background white "$TEMP_DIR/$PDF-%04d.png"
for i in $TEMP_DIR/*.png; do sips -s format jpeg -s formatOptions 70 "${i}" --out "${i%png}jpg"; done

cp $TEMP_DIR/*.jpg .

rm -rf $TEMP_DIR
