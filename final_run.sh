#!/usr/bin/env bash
set -e

cd /home/mahmoud/Documents/GitHub/musicbud/musicbud_flutter

echo "=== Building Flutter Linux App ==="
nix-shell -p flutter --run "flutter build linux --debug"

echo ""
echo "=== Running Flutter Linux App ==="
echo "Setting up library environment..."

# Run with explicit library path setup
nix-shell -p freetype zlib fontconfig cairo pango gdk-pixbuf \
  harfbuzz atk at-spi2-atk gtk3 glib libGL libxkbcommon \
  xorg.libX11 xorg.libXext libsecret glibc --run '
  
  # Use NIX_LD_LIBRARY_PATH which is set by nix-shell
  export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH"
  
  echo "Starting application..."
  exec ./build/linux/x64/debug/bundle/musicbud_flutter
'
