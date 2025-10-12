#!/bin/bash

# Flutter Linux Development Environment Setup
echo "🚀 Setting up Flutter Linux development environment..."

# Get library paths from pkg-config
FONTCONFIG_LIB=$(pkg-config --variable=libdir fontconfig 2>/dev/null || echo "/usr/lib/x86_64-linux-gnu")
EPOXY_LIB=$(pkg-config --variable=libdir epoxy 2>/dev/null || echo "/usr/lib/x86_64-linux-gnu")
GTK3_LIB=$(pkg-config --variable=libdir gtk+-3.0 2>/dev/null || echo "/usr/lib/x86_64-linux-gnu")
GLIB_LIB=$(pkg-config --variable=libdir glib-2.0 2>/dev/null || echo "/usr/lib/x86_64-linux-gnu")
CAIRO_LIB=$(pkg-config --variable=libdir cairo 2>/dev/null || echo "/usr/lib/x86_64-linux-gnu")
PANGO_LIB=$(pkg-config --variable=libdir pango 2>/dev/null || echo "/usr/lib/x86_64-linux-gnu")

# Common Linux library paths
COMMON_PATHS="/usr/lib:/usr/lib/x86_64-linux-gnu:/lib:/lib/x86_64-linux-gnu"

# Nix store paths (for NixOS)
NIX_PATHS="/nix/store/*/lib"

# Set up comprehensive LD_LIBRARY_PATH
export LD_LIBRARY_PATH="${FONTCONFIG_LIB}:${EPOXY_LIB}:${GTK3_LIB}:${GLIB_LIB}:${CAIRO_LIB}:${PANGO_LIB}:${COMMON_PATHS}:${LD_LIBRARY_PATH}"

# Additional environment variables for better Linux support
export GDK_BACKEND=x11
export XDG_SESSION_TYPE=x11
export DISPLAY=${DISPLAY:-:0}

# Flutter environment
export FLUTTER_ROOT=/opt/flutter
export PATH="$FLUTTER_ROOT/bin:$PATH"

# Debug info
echo "📦 Library paths configured:"
echo "  - FontConfig: $FONTCONFIG_LIB"
echo "  - Epoxy: $EPOXY_LIB"  
echo "  - GTK3: $GTK3_LIB"
echo "  - GLib: $GLIB_LIB"
echo "  - Cairo: $CAIRO_LIB"
echo "  - Pango: $PANGO_LIB"
echo ""
echo "🔧 Environment variables set:"
echo "  - GDK_BACKEND: $GDK_BACKEND"
echo "  - XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
echo "  - DISPLAY: $DISPLAY"
echo ""
echo "✅ Environment setup complete!"
echo ""

# Run Flutter with the configured environment
if [ "$1" = "run" ]; then
    echo "🏃 Running Flutter app..."
    flutter run -d linux --hot
else
    echo "💡 To run Flutter, execute: source ./setup_flutter_env.sh run"
    echo "💡 Or run manually: flutter run -d linux --hot"
fi