#!/usr/bin/env bash
set -e

# Navigate to project directory
cd /home/mahmoud/Documents/GitHub/musicbud/musicbud_flutter

# Run the app in a nix-shell with all required runtime libraries
exec nix-shell \
  -p flutter freetype zlib fontconfig cairo pango gdk-pixbuf \
  -p harfbuzz atk at-spi2-atk gtk3 glib libGL libxkbcommon \
  -p xorg.libX11 xorg.libXext libsecret \
  --run 'LD_LIBRARY_PATH=$LD_LIBRARY_PATH ./build/linux/x64/debug/bundle/musicbud_flutter'
