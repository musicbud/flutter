#!/usr/bin/env bash

# Flutter Linux Application Runner
# This script sets up the environment and runs the Flutter app with all required dependencies

set -e

cd "$(dirname "$0")"

echo "🚀 Starting Flutter MusicBud App..."

# Check if FastAPI backend is running
if ! curl -s http://localhost:8000/health >/dev/null 2>&1; then
    echo "⚠️  FastAPI backend not running at localhost:8000"
    echo "   Please start the backend with: cd ../fastapi_backend && python -m uvicorn app.main:app --host 0.0.0.0 --port 8000"
    echo ""
fi

# Ensure the Flutter app is built
if [ ! -f "./build/linux/x64/debug/bundle/musicbud_flutter" ]; then
    echo "🔨 Building Flutter app..."
    nix-shell -p gtk3 pkg-config cmake ninja libepoxy fontconfig gcc libsecret sysprof --run "
        cd build/linux/x64/debug && 
        cmake -DCMAKE_INSTALL_PREFIX=./bundle /home/mahmoud/Documents/GitHub/musicbud/musicbud_flutter/linux && 
        ninja install
    "
fi

echo "🎯 Launching app with proper dependencies..."

# Run in nix-shell with all required runtime dependencies
exec nix-shell -p gtk3 glib pango cairo gdk-pixbuf fontconfig libepoxy zlib libsecret atk at-spi2-atk wayland --run "
    export DISPLAY=\${DISPLAY:-:0}
    export WAYLAND_DISPLAY=\${WAYLAND_DISPLAY:-wayland-0}
    
    echo '📱 Flutter MusicBud is starting...'
    echo '🔗 API will connect to: http://localhost:8000/v1/auth/login/json'
    echo ''
    
    exec ./build/linux/x64/debug/bundle/musicbud_flutter
"