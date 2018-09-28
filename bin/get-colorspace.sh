#!/bin/bash
space=$(ffprobe -show_streams -i "$1" -v 16 | grep color_space | cut -c 13-)
space=$(echo $space|tr -d '\n')
if [ "$space" == "unknown" ]; then
	space="unspecified"
fi
echo $space