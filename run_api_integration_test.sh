#!/bin/bash
# Script to run API integration tests on Linux desktop (avoids Chrome root user issues)

echo "Running API integration tests on Linux desktop..."
flutter test integration_test/api_integration_test.dart -d linux
