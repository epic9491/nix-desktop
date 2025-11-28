#!/usr/bin/env bash

WALL_DIR="$HOME/nixos/pics/walls"

# Pick random image
wall=$(find "$WALL_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | shuf -n 1)

# Exit if failed
[ -z "$wall" ] && exit 0

# Temp config
TMP_CONF="${XDG_RUNTIME_DIR:-/tmp}/hyprpaper-random.conf"

cat > "$TMP_CONF" <<EOF
preload = $wall
wallpaper = ,$wall
EOF

# Make sure 1 hyprpaper instance running
pkill hyprpaper 2>/dev/null || true

# Start hyprpaper
hyprpaper -c "$TMP_CONF" >/dev/null 2>&1 &