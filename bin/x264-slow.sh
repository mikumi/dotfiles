cs=$(get-colorspace.sh "$1") && time ffmpeg -i "$1" -c:v libx264 -preset slow -tune film -crf $2 -pix_fmt yuv420p -color_primaries "$cs" -color_trc "$cs" -colorspace "$cs" "$1"_264.mp4
