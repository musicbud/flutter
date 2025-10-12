#!/usr/bin/env bash

echo "🚀 Running Flutter app directly..."

# Build the app first
echo "🔨 Building Flutter app..."
nix-shell --run "flutter build linux --debug"

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Create proper bundle structure
    echo "📦 Setting up bundle..."
    mkdir -p build/linux/x64/debug/bundle/{data,lib}
    
    # Copy executable
    cp build/linux/x64/debug/intermediates_do_not_run/musicbud_flutter build/linux/x64/debug/bundle/
    chmod +x build/linux/x64/debug/bundle/musicbud_flutter
    
    # Copy flutter assets and libraries
    [ -d "build/flutter_assets" ] && cp -r build/flutter_assets/* build/linux/x64/debug/bundle/data/
    find build/linux/x64/debug/flutter/ -name "*.so" -exec cp {} build/linux/x64/debug/bundle/lib/ \; 2>/dev/null
    
    echo "🎉 Starting your Flutter app..."
    echo "📍 Running from: $(pwd)/build/linux/x64/debug/bundle/"
    
    # Run within nix-shell environment for proper library paths
    cd build/linux/x64/debug/bundle
    nix-shell --run "./musicbud_flutter" --command "echo '🌟 App started!'"
else
    echo "❌ Build failed!"
    exit 1
fi