#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle HDR
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 💻
# @raycast.author Michael Kuck
# @raycast.description Turns HDR on or off.
# @raycast.authorURL https://github.com/mikumi

output=$(~/bin/ToggleHDR)
hdr_enabled=$(echo "$output" | awk 'NR==2 {print $4}')

if [[ "$hdr_enabled" == "true" ]]; then
  ~/bin/ToggleHDR "LG ULTRAFINE" "OFF"
  echo "HDR is now OFF"
else
  ~/bin/ToggleHDR "LG ULTRAFINE" "ON"
  echo "HDR is now ON"
fi
