# MusicBud Flutter - Test & Development Makefile

.PHONY: help test test-unit test-widget test-integration test-coverage clean analyze format run-debug run-release build

# Default target
help:
	@echo "MusicBud Flutter - Available Commands"
	@echo "======================================"
	@echo ""
	@echo "Testing Commands:"
	@echo "  make test                  - Run all tests"
	@echo "  make test-unit             - Run unit tests only"
	@echo "  make test-widget           - Run widget tests only"
	@echo "  make test-integration      - Run integration tests"
	@echo "  make test-coverage         - Run tests with coverage report"
	@echo "  make test-verbose          - Run tests with verbose output"
	@echo ""
	@echo "Code Quality:"
	@echo "  make analyze               - Run Flutter analyzer"
	@echo "  make format                - Format code"
	@echo "  make lint                  - Run linter"
	@echo ""
	@echo "Development:"
	@echo "  make run-debug             - Run app in debug mode"
	@echo "  make run-release           - Run app in release mode"
	@echo "  make build                 - Build APK"
	@echo "  make clean                 - Clean build artifacts"
	@echo ""
	@echo "Dependencies:"
	@echo "  make get                   - Get dependencies"
	@echo "  make upgrade               - Upgrade dependencies"
	@echo "  make outdated              - Check outdated packages"
	@echo ""

# Testing
test:
	@echo "🧪 Running all tests..."
	@flutter test

test-unit:
	@echo "🧪 Running unit tests..."
	@flutter test test/blocs/ test/services/

test-widget:
	@echo "🧪 Running widget tests..."
	@flutter test test/widgets/

test-integration:
	@echo "🧪 Running integration tests..."
	@flutter test test/integration_tests/

test-coverage:
	@echo "📊 Running tests with coverage..."
	@flutter test --coverage
	@echo "Generating HTML coverage report..."
	@genhtml coverage/lcov.info -o coverage/html 2>/dev/null || echo "Install lcov for HTML reports: brew install lcov"
	@echo "✅ Coverage report generated at coverage/html/index.html"

test-verbose:
	@echo "🧪 Running tests with verbose output..."
	@flutter test --verbose

test-watch:
	@echo "👀 Watching tests..."
	@flutter test --watch

# Code Quality
analyze:
	@echo "🔍 Analyzing code..."
	@flutter analyze

format:
	@echo "✨ Formatting code..."
	@dart format lib/ test/

lint:
	@echo "🔍 Running linter..."
	@flutter analyze --no-fatal-infos

fix:
	@echo "🔧 Applying automatic fixes..."
	@dart fix --apply

# Development
run-debug:
	@echo "🚀 Running app in debug mode..."
	@flutter run

run-release:
	@echo "🚀 Running app in release mode..."
	@flutter run --release

run-profile:
	@echo "📊 Running app in profile mode..."
	@flutter run --profile

build:
	@echo "🏗️  Building APK..."
	@flutter build apk

build-ios:
	@echo "🏗️  Building iOS..."
	@flutter build ios

build-web:
	@echo "🏗️  Building web..."
	@flutter build web

clean:
	@echo "🧹 Cleaning build artifacts..."
	@flutter clean
	@rm -rf coverage/

deep-clean: clean
	@echo "🧹 Deep cleaning..."
	@rm -rf .dart_tool/
	@rm -rf build/
	@rm -rf .flutter-plugins
	@rm -rf .flutter-plugins-dependencies
	@flutter pub get

# Dependencies
get:
	@echo "📦 Getting dependencies..."
	@flutter pub get

upgrade:
	@echo "⬆️  Upgrading dependencies..."
	@flutter pub upgrade

outdated:
	@echo "📦 Checking for outdated packages..."
	@flutter pub outdated

# Generate Code
generate:
	@echo "🔨 Generating code..."
	@flutter pub run build_runner build --delete-conflicting-outputs

generate-watch:
	@echo "👀 Watching for code generation..."
	@flutter pub run build_runner watch --delete-conflicting-outputs

# Debug Tools
debug-dashboard:
	@echo "🐛 Opening debug dashboard..."
	@echo "Add DebugFAB() to your screen to access the dashboard"

# Performance
performance:
	@echo "📊 Profiling performance..."
	@flutter run --profile --trace-skia

# Complete check before commit
pre-commit: format analyze test
	@echo "✅ Pre-commit checks passed!"

# CI/CD
ci: analyze test-coverage
	@echo "✅ CI checks passed!"

# Install development tools
install-tools:
	@echo "🔧 Installing development tools..."
	@brew install lcov 2>/dev/null || echo "Skipping lcov install"
	@flutter pub global activate coverage
	@flutter pub global activate flutter_gen

# App info
info:
	@echo "ℹ️  App Information"
	@echo "=================="
	@flutter --version
	@echo ""
	@echo "Dependencies:"
	@flutter pub deps --style=compact

# Doctor
doctor:
	@echo "🏥 Running Flutter doctor..."
	@flutter doctor -v

# Quick commands
q: test
v: test-verbose
c: test-coverage
a: analyze
f: format
r: run-debug

# All-in-one quality check
quality: format analyze test-coverage
	@echo "🎉 Quality checks completed!"
