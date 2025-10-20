#!/usr/bin/env bash
set -e

echo "Building Flutter Linux application..."

# Build in nix-shell with minimal dependencies
nix-shell -p flutter --run "flutter build linux --debug"

echo "Patching binary with correct library paths..."

# Patch the binary to use correct interpreter and libraries
nix-shell -p patchelf freetype zlib fontconfig cairo pango gdk-pixbuf \
  harfbuzz atk at-spi2-atk gtk3 glib libGL libxkbcommon \
  xorg.libX11 xorg.libXext libsecret --run '
  
  BINARY=./build/linux/x64/debug/bundle/musicbud_flutter
  
  # Get library paths from nix store (64-bit only)
  FREETYPE_LIB=$(find /nix/store -path "*/freetype-*/lib" -type d 2>/dev/null | grep -v "i686" | head -1)
  ZLIB_LIB=$(find /nix/store -path "*/zlib-*/lib" -type d 2>/dev/null | grep -v "i686" | head -1)
  GTK_LIB=$(find /nix/store -path "*/gtk+3-*/lib" -type d 2>/dev/null | head -1)
  GLIB_LIB=$(find /nix/store -path "*/glib-2*/lib" -type d 2>/dev/null | grep -v "i686" | head -1)
  CAIRO_LIB=$(find /nix/store -path "*/cairo-*/lib" -type d 2>/dev/null | grep -v "i686" | head -1)
  PANGO_LIB=$(find /nix/store -path "*/pango-*/lib" -type d 2>/dev/null | head -1)
  
  # Build rpath
  RPATH="$FREETYPE_LIB:$ZLIB_LIB:$GTK_LIB:$GLIB_LIB:$CAIRO_LIB:$PANGO_LIB"
  
  echo "Setting RPATH to: $RPATH"
  patchelf --set-rpath "$RPATH" "$BINARY"
  
  echo "Patched successfully!"
'

echo "Running application..."
./build/linux/x64/debug/bundle/musicbud_flutter
