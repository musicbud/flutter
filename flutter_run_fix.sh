#!/usr/bin/env bash

echo "🚀 Starting Flutter app with automatic bundle fix..."

# Function to create bundle structure
create_bundle() {
    echo "📦 Creating bundle structure..."
    mkdir -p build/linux/x64/debug/bundle/data
    mkdir -p build/linux/x64/debug/bundle/lib
    
    # Copy executable
    if [ -f "build/linux/x64/debug/intermediates_do_not_run/musicbud_flutter" ]; then
        cp build/linux/x64/debug/intermediates_do_not_run/musicbud_flutter build/linux/x64/debug/bundle/
        chmod +x build/linux/x64/debug/bundle/musicbud_flutter
        echo "✅ Executable copied and made executable"
    fi
    
    # Copy flutter assets
    if [ -d "build/flutter_assets" ]; then
        cp -r build/flutter_assets build/linux/x64/debug/bundle/data/
        echo "✅ Flutter assets copied"
    fi
    
    # Copy shared libraries
    find build/linux/x64/debug/flutter/ -name "*.so" -exec cp {} build/linux/x64/debug/bundle/lib/ \; 2>/dev/null
    echo "✅ Shared libraries copied"
}

# Build the app first
echo "🔨 Building Flutter app..."
nix-shell --run "flutter build linux --debug"

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    create_bundle
    
    echo "🎉 Bundle created! Now running the app..."
    # Try to run the app
    nix-shell --run "flutter run -d linux --debug --no-build"
else
    echo "❌ Build failed!"
    exit 1
fi