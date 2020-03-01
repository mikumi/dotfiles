cs=$(get-colorspace.sh "$1") && time ffmpeg -i "$1" -c:v libx265 -preset medium -tune grain -crf $2 -pix_fmt yuv420p10le -color_primaries "$cs" -color_trc "$cs" -colorspace "$cs" -tag:v hvc1 "$1"_x265_crf"$2".mp4
