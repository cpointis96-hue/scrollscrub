#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/assets/source/exploded.png"
OUT="$ROOT/assets/components"
mkdir -p "$OUT"

# Each mask is intentionally local and conservative: dark product detail is never
# chroma-keyed away. Coordinates are in the 1672x941 source reference.
make_layer() {
  local name="$1" box="$2" shape="$3"
  local dims="${box%%+*}" w="${dims%x*}" h="${dims#*x}"
  magick "$SRC" -crop "$box" +repage \
    \( -size "${w}x${h}" xc:black -fill white -draw "$shape" \) \
    -alpha off -compose CopyOpacity -composite \
    -trim +repage "$OUT/$name.png"
}

make_layer "01-left-shell" "52x386+48+364" "ellipse 26,194 166,384 0,360"
make_layer "02-left-hinge" "104x266+236+344" "polygon 34,16 82,28 70,112 83,150 63,232 22,207 30,132 13,84"
make_layer "03-left-driver" "150x255+342+459" "ellipse 75,128 146,244 0,360"
make_layer "04-left-ring" "93x265+500+441" "ellipse 46,133 90,255 0,360"
make_layer "05-left-cushion" "154x305+616+421" "ellipse 77,152 150,300 0,360"
make_layer "06-headband" "500x285+587+134" "path 'M 10,215 C 26,48 132,4 250,4 C 376,4 470,48 490,215 L 454,220 C 434,84 350,42 250,42 C 150,42 66,84 46,220 Z'"
make_layer "07-right-cushion" "154x305+902+423" "ellipse 77,152 150,300 0,360"
make_layer "08-right-ring" "93x265+1077+441" "ellipse 46,133 90,255 0,360"
make_layer "09-right-driver" "150x255+1190+459" "ellipse 75,128 146,244 0,360"
make_layer "10-right-hinge" "104x266+1321+345" "polygon 22,18 70,8 91,78 82,132 91,208 47,242 30,151 15,114"
make_layer "11-right-shell" "176x386+1434+364" "ellipse 148,194 174,384 0,360"

mkdir -p "$ROOT/public/assets/components"
cp "$OUT"/*.png "$ROOT/public/assets/components/"

echo "Generated $(find "$OUT" -name '*.png' | wc -l | tr -d ' ') component layers in $OUT"
