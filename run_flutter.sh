#!/usr/bin/env bash

echo "🚀 Starting Flutter app with NixOS development environment..."
echo "📚 Using nix-shell with all required dependencies"

# Run Flutter within the nix-shell environment
nix-shell --run "flutter run -d linux --debug"
