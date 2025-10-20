#!/usr/bin/env bash
set -e

echo "Testing Flutter app with login redirect fix..."
echo "Make sure your backend is running on localhost:8000"
echo ""

cd /home/mahmoud/Documents/GitHub/musicbud/musicbud_flutter

# Run the app
timeout 60 ./run-flutter-fhs.sh 2>&1 | tee /tmp/flutter-test.log

echo ""
echo "=== Test completed ==="
echo "Logs saved to: /tmp/flutter-test.log"
