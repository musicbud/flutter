#!/usr/bin/env bash
set -e

cd /home/mahmoud/Documents/GitHub/musicbud/musicbud_flutter

echo "Starting Flutter in FHS environment..."
echo "This will create an isolated environment with all required libraries."
echo ""

# Run Flutter in the FHS environment
nix-shell flutter-fhs.nix --run "flutter run -d linux --debug"
