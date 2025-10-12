#!/usr/bin/env bash

echo "🚀 Flutter run -d linux --debug with bundle fix"

# Create the bundle directory structure before Flutter tries to run
create_bundle_if_missing() {
    if [ ! -f "build/linux/x64/debug/bundle/musicbud_flutter" ]; then
        echo "📦 Bundle missing, creating it..."
        mkdir -p build/linux/x64/debug/bundle/data
        mkdir -p build/linux/x64/debug/bundle/lib
        
        if [ -f "build/linux/x64/debug/intermediates_do_not_run/musicbud_flutter" ]; then
            cp build/linux/x64/debug/intermediates_do_not_run/musicbud_flutter build/linux/x64/debug/bundle/
            chmod +x build/linux/x64/debug/bundle/musicbud_flutter
        fi
        
        # Copy assets if they exist
        [ -d "build/flutter_assets" ] && cp -r build/flutter_assets build/linux/x64/debug/bundle/data/ 2>/dev/null
        find build/linux/x64/debug/flutter/ -name "*.so" -exec cp {} build/linux/x64/debug/bundle/lib/ \; 2>/dev/null
    fi
}

# Run in a loop to handle the bundle creation issue
for i in {1..3}; do
    echo "🔄 Attempt $i: Running flutter run -d linux --debug"
    
    # Run the flutter command in background so we can monitor it
    nix-shell --run "flutter run -d linux --debug" &
    FLUTTER_PID=$!
    
    # Wait a moment for the build to complete
    sleep 5
    
    # Check if bundle needs to be created
    create_bundle_if_missing
    
    # Wait for Flutter process
    wait $FLUTTER_PID
    RESULT=$?
    
    if [ $RESULT -eq 0 ]; then
        echo "✅ Flutter app started successfully!"
        break
    elif [ $i -lt 3 ]; then
        echo "⚠️  Attempt $i failed, trying again..."
        sleep 2
    else
        echo "❌ All attempts failed"
        exit 1
    fi
done