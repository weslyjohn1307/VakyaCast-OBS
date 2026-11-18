#!/usr/bin/env bash
set -e
TARGET_DIR="$HOME/OBS-VakyaCast"
mkdir -p "$TARGET_DIR"
cp "$(dirname "$0")/../bible_lower_third_studio.html" "$TARGET_DIR/bible_lower_third_studio.html"
echo "Installed to $TARGET_DIR/bible_lower_third_studio.html"
echo "OBS Dock URL: file://$TARGET_DIR/bible_lower_third_studio.html?mode=dock"
echo "OBS Overlay URL: file://$TARGET_DIR/bible_lower_third_studio.html?mode=overlay"
