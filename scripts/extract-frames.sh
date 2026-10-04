#!/usr/bin/env bash
set -euo pipefail

source_video="${1:-assets/source/aura-x1-master.mp4}"
output_dir="${2:-public/sequence}"

if [[ ! -f "$source_video" ]]; then
  echo "Source video not found: $source_video" >&2
  exit 1
fi

mkdir -p "$output_dir"
rm -f "$output_dir"/frame-*.webp "$output_dir"/manifest.json
temporary_dir=$(mktemp -d)
trap 'rm -rf "$temporary_dir"' EXIT

ffmpeg -hide_banner -loglevel error -y -i "$source_video" \
  -vf "fps=24,scale='min(1600,iw)':-2" \
  "$temporary_dir/frame-%04d.png"

export output_dir
find "$temporary_dir" -maxdepth 1 -name 'frame-*.png' -print0 | \
  xargs -0 -P 6 -n 1 sh -c '
    frame="$1"
    name=$(basename "$frame" .png)
    cwebp -quiet -q 83 -m 0 "$frame" -o "$output_dir/$name.webp"
  ' _

frame_count=$(find "$output_dir" -maxdepth 1 -name 'frame-*.webp' -type f | wc -l | tr -d ' ')
if [[ "$frame_count" -lt 2 ]]; then
  echo "Frame extraction failed: expected at least 2 frames, got $frame_count" >&2
  exit 1
fi

printf '{"frameCount":%s,"frames":[' "$frame_count" > "$output_dir/manifest.json"
first=1
for frame in "$output_dir"/frame-*.webp; do
  if [[ "$first" -eq 0 ]]; then printf ',' >> "$output_dir/manifest.json"; fi
  printf '"/%s"' "$frame" >> "$output_dir/manifest.json"
  first=0
done
printf ']}' >> "$output_dir/manifest.json"

echo "Extracted $frame_count WebP frames to $output_dir"
