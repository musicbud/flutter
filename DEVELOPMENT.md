# MusicBud Flutter - Development Guide

## 🎵 Welcome to MusicBud Development

MusicBud is a Flutter application for music lovers to discover, share, and connect through music. This guide will help you get started with development.

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Development Environment](#development-environment)
- [Available Scripts](#available-scripts)
- [Development Features](#development-features)
- [Architecture Overview](#architecture-overview)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## 🚀 Quick Start

### Prerequisites

- **Linux System** (NixOS or other Linux distributions)
- **Flutter SDK** (3.24.3 or higher)
- **Nix Package Manager** (for Linux dependencies)

### Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-org/musicbud_flutter.git
   cd musicbud_flutter
   ```

2. **Run the app quickly:**
   ```bash
   ./dev run
   ```

3. **That's it!** The development script handles all the complexity.

## 📁 Project Structure

```
lib/
├── blocs/                    # BLoC state management
│   ├── auth/                # Authentication logic
│   ├── content/             # Music content management
│   ├── user/                # User profile management
│   └── ...
├── core/                    # Core utilities and configurations
│   ├── error/               # Error handling
│   ├── theme/               # App theming
│   └── constants/           # App constants
├── data/                    # Data layer
│   ├── models/              # Data models
│   ├── repositories/        # Repository implementations
│   ├── data_sources/        # Remote/local data sources
│   └── network/             # Network clients (Dio)
├── domain/                  # Domain layer
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   └── use_cases/           # Business logic use cases
├── presentation/            # UI layer
│   ├── screens/             # App screens
│   ├── widgets/             # Reusable widgets
│   └── pages/               # Page widgets
├── services/                # Services and utilities
│   ├── mock_data_service.dart
│   └── dynamic_navigation_service.dart
└── main.dart               # App entry point

scripts/
└── dev.sh                 # Development helper script

test/                       # Unit and widget tests
integration_test/           # Integration tests
```

## 🛠️ Development Environment

### Linux Dependencies

The app requires several Linux libraries for desktop development. These are automatically handled by our development script:

- `libsecret` - For secure credential storage
- `pkg-config` - For package configuration
- `sysprof` - For profiling support  
- `glib` - Core library
- `gtk3` - GUI toolkit
- `xorg.libX11` - X11 support

### Environment Variables

The following environment variables are automatically set:

```bash
export LD_LIBRARY_PATH="/nix/store/.../fontconfig/lib:/nix/store/.../libepoxy/lib:$LD_LIBRARY_PATH"
```

These are persistent in your `~/.zshrc` and configured automatically.

## 🎛️ Available Scripts

We provide a convenient development script (`./dev`) for all common tasks:

### Main Commands

```bash
./dev run              # Run the app on Linux (debug mode)
./dev build            # Build the app for Linux
./dev clean            # Clean build artifacts and get dependencies
./dev test             # Run all tests
./dev analyze          # Run static code analysis
./dev format           # Format code according to Dart style
./dev deps             # Get/update dependencies
./dev doctor           # Check Flutter installation
./dev kill             # Kill all running Flutter processes
./dev help             # Show help message
```

### Usage Examples

```bash
# Start development
./dev run

# Check code quality
./dev analyze
./dev format

# Run tests
./dev test

# Clean build when things go wrong
./dev clean
```

## 🔥 Development Features

### Hot Reload

The app supports Flutter's hot reload for rapid development:

- Press `r` in the terminal while the app is running
- Or use `./dev run` and modify your code - changes appear instantly

### Mock Data Service

For offline development, we provide a comprehensive mock data service:

```dart
import 'package:musicbud_flutter/services/mock_data_service.dart';

// Generate realistic sample data
final artists = MockDataService.generateTopArtists(count: 20);
final tracks = MockDataService.generateTopTracks(count: 50);
final buds = MockDataService.generateBudRecommendations(count: 15);
```

### Error State Widgets

Comprehensive error handling widgets for offline scenarios:

```dart
import 'package:musicbud_flutter/presentation/widgets/error_states/offline_error_widget.dart';

// Network error with retry and mock data options
NetworkErrorWidget(
  onRetry: () => _retryApiCall(),
  onUseMockData: () => _loadMockData(),
)

// Loading with automatic fallback to mock data
LoadingWithOfflineFallback(
  loadingMessage: 'Loading your music...',
  onTimeout: () => _handleTimeout(),
  mockDataBuilder: () => _buildMockDataWidget(),
)
```

## 🏗️ Architecture Overview

### Clean Architecture

The app follows Clean Architecture principles:

1. **Presentation Layer** (`lib/presentation/`)
   - Screens, widgets, and BLoCs
   - Handles UI and user interactions

2. **Domain Layer** (`lib/domain/`)
   - Business logic and entities
   - Repository interfaces
   - Use cases for business operations

3. **Data Layer** (`lib/data/`)
   - Repository implementations
   - Data sources (remote/local)
   - Models and network clients

### State Management

We use **BLoC (Business Logic Component)** pattern:

```dart
// Example BLoC usage
context.read<ContentBloc>().add(LoadTopTracks());

// Listen to state changes
BlocBuilder<ContentBloc, ContentState>(
  builder: (context, state) {
    if (state is ContentLoading) {
      return LoadingWidget();
    } else if (state is ContentLoaded) {
      return TracksList(tracks: state.tracks);
    } else if (state is ContentError) {
      return ErrorWidget(error: state.error);
    }
    return EmptyWidget();
  },
)
```

### Dependency Injection

Service locator pattern with GetIt:

```dart
// Registration (in main.dart)
GetIt.instance.registerSingleton<AuthRepository>(AuthRepositoryImpl());

// Usage
final authRepo = GetIt.instance<AuthRepository>();
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
./dev test

# Run specific test suites
flutter test test/unit/
flutter test test/widget/
flutter test integration_test/
```

### Test Structure

```
test/
├── unit/                   # Unit tests
├── widget/                 # Widget tests  
├── integration/            # Integration tests
└── mocks/                  # Mock objects
```

### Writing Tests

```dart
// Example unit test
testWidgets('Should display loading indicator', (tester) async {
  await tester.pumpWidget(MyWidget());
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Build Errors

```bash
# Clean and rebuild
./dev clean
./dev build
```

#### 2. Dependency Issues

```bash
# Update dependencies
./dev deps

# Check Flutter installation
./dev doctor
```

#### 3. Linux Library Missing

```bash
# The development script handles this automatically
# If you see library errors, ensure you're using:
./dev run  # instead of direct flutter run
```

#### 4. Hot Reload Not Working

- Ensure you're using `./dev run`
- Press `R` for full restart instead of `r`

#### 5. Process Hanging

```bash
# Kill all Flutter processes
./dev kill

# Then restart
./dev run
```

### Debug Mode

The app runs in debug mode by default, providing:

- Detailed error messages
- Performance overlay (if enabled)
- Debug console output
- Hot reload capabilities

### DevTools

Access Flutter DevTools for advanced debugging:

```bash
# After running the app, DevTools URL will be shown:
# http://127.0.0.1:9100?uri=http://127.0.0.1:XXXXX/
```

## 📱 Platform Support

### Current Support

- ✅ **Linux Desktop** (Primary development target)
- ✅ **Web** (Chrome/Chromium)
- ⚠️ **Android** (Configured but not actively tested)

### Platform-Specific Features

#### Linux Desktop
- Native window management
- System tray integration (planned)
- Desktop notifications (planned)

#### Web
- Responsive design
- Progressive Web App features (planned)

## 🎨 UI/UX Guidelines

### Design System

- **Material Design 3** with custom MusicBud theme
- **Dark theme** optimized for music apps
- **Consistent spacing** using theme-based spacing methods
- **Accessibility** support with proper contrast ratios

### Component Guidelines

```dart
// Use theme-based spacing
EdgeInsets.all(Theme.of(context).spacing.medium)

// Use consistent text styles
Text(
  'Title',
  style: Theme.of(context).textTheme.headlineMedium,
)

// Follow naming conventions
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
  // ...
}
```

## 🔧 Configuration

### Environment Configuration

Development configurations are in:

- `lib/config/` - App configurations
- `analysis_options.yaml` - Dart analyzer settings
- `pubspec.yaml` - Dependencies and app metadata

### Feature Flags

The app uses dynamic configuration for features:

```dart
if (DynamicConfigService.instance.isFeatureEnabled('chat_system')) {
  // Show chat features
}
```

## 🚀 Deployment

### Building for Production

```bash
# Build for Linux
./dev build

# The executable will be at:
# build/linux/x64/debug/bundle/musicbud_flutter
```

### Release Preparation

1. Update version in `pubspec.yaml`
2. Run full test suite: `./dev test`
3. Check code quality: `./dev analyze`
4. Format code: `./dev format`
5. Build: `./dev build`

## 📚 Resources

### Flutter Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [BLoC Documentation](https://bloclibrary.dev/)

### MusicBud Specific

- API Documentation (when available)
- Design System Guidelines (in progress)
- Architecture Decision Records (planned)

## 🤝 Contributing

### Code Style

- Follow Dart style guidelines
- Use our analysis options configuration
- Format code with `./dev format`
- Write tests for new features

### Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linting
5. Submit a pull request

### Commit Messages

Use conventional commits:

```
feat: add music player controls
fix: resolve authentication issues
docs: update development guide
test: add unit tests for user service
```

## 📞 Support

For development questions and issues:

- Create a GitHub issue
- Check existing documentation
- Use the development script: `./dev help`

---

**Happy Coding! 🎵✨**

Built with ❤️ for music lovers everywhere.