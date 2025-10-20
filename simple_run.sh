#!/usr/bin/env bash
set -e

cd /home/mahmoud/Documents/GitHub/musicbud/musicbud_flutter

echo "Step 1: Building Flutter app..."
nix-shell -p flutter --run "flutter build linux --debug"

echo ""
echo "Step 2: Running Flutter app with runtime libraries..."
nix-shell -p freetype zlib fontconfig cairo pango gdk-pixbuf \
  harfbuzz atk at-spi2-atk gtk3 glib libGL libxkbcommon \
  xorg.libX11 xorg.libXext libsecret --run '
  
  export LD_LIBRARY_PATH=""
  for pkg in freetype zlib fontconfig cairo pango gdk-pixbuf harfbuzz atk at-spi2-atk gtk3 glib libGL libxkbcommon; do
    libdirs=$(find /nix/store -maxdepth 1 -name "*-$pkg-*" -type d 2>/dev/null | grep -v "i686" | grep -v "\-dev$")
    for libdir in $libdirs; do
      if [ -d "$libdir/lib" ] && [ -n "$(ls -A $libdir/lib/*.so* 2>/dev/null)" ]; then
        export LD_LIBRARY_PATH="$libdir/lib:$LD_LIBRARY_PATH"
        break
      fi
    done
  done
  
  echo "LD_LIBRARY_PATH set to: $LD_LIBRARY_PATH"
  ./build/linux/x64/debug/bundle/musicbud_flutter
'
