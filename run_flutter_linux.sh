#!/usr/bin/env bash
set -e

echo "Starting Flutter Linux app with Nix shell environment..."

# Run Flutter with all required libraries for Linux desktop
exec nix-shell \
  -p flutter freetype zlib fontconfig cairo pango gdk-pixbuf \
  -p harfbuzz atk at-spi2-atk gtk3 glib libGL libxkbcommon \
  -p xorg.libX11 xorg.libXext libsecret pkg-config cmake ninja \
  --run 'export LD_LIBRARY_PATH="" && flutter run -d linux --debug'
