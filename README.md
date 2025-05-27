# MusicBud Flutter

A sophisticated music discovery and social platform built with Flutter that connects users through their music tastes.

## Project Description

MusicBud is a cross-platform application that brings music lovers together by matching users with similar music preferences. The app integrates with multiple music services including Spotify, Last.fm, and YouTube Music, allowing users to discover music buddies, chat about their favorite artists, and explore new content.

### Key Features

- **Multi-service Integration**: Connect with Spotify, Last.fm, and YouTube Music
- **Music Buddy Matching**: Find users with similar music tastes
- **Real-time Chat**: Communicate with other music enthusiasts
- **Content Discovery**: Explore new artists, tracks, and genres
- **User Profiles**: Showcase your music preferences and statistics
- **Media Integration**: Connect anime and manga preferences through MyAnimeList
- **Interactive Maps**: View played tracks by geographic location
- **Social Features**: Share stories and updates with followers
- **Comprehensive Analytics**: Track your listening habits and preferences

## Setup Instructions

### Prerequisites

- Flutter SDK (2.10.0 or later)
- Dart SDK (2.16.0 or later)
- Android Studio / VS Code with Flutter extensions
- For iOS development: Xcode and CocoaPods
- Active accounts on music services (Spotify, Last.fm, etc.) for full functionality

### Development Environment Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/54ba/musicbud_flutter.git
   cd musicbud_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up API keys**
   - Create a `lib/config/secrets.dart` file with your API keys:
   ```dart
   class Secrets {
     static const String spotifyClientId = 'your_spotify_client_id';
     static const String spotifyClientSecret = 'your_spotify_client_secret';
     static const String lastFmApiKey = 'your_lastfm_api_key';
     static const String malClientId = 'your_mal_client_id';
     // Add other required API keys
   }
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## Project Structure

The project follows a clean architecture approach with separation of concerns:

```
lib/
├── blocs/                  # BLoC state management components
│   ├── auth/               # Authentication-related BLoCs
│   ├── chat/               # Chat functionality BLoCs
│   ├── content/            # Content management BLoCs
│   └── user/               # User profile BLoCs
├── config/                 # Application configuration
├── core/                   # Core utilities and constants
├── data/                   # Data layer (repositories, models, etc.)
│   ├── data_sources/       # Remote and local data sources
│   ├── models/             # Data models
│   ├── network/            # Network clients and adapters
│   └── repositories/       # Repository implementations
├── domain/                 # Domain layer (entities, use cases)
│   ├── models/             # Domain entities
│   └── repositories/       # Repository interfaces
├── presentation/           # UI layer
│   ├── pages/              # Application screens
│   └── widgets/            # Reusable UI components
├── services/               # Service layer for business logic
├── utils/                  # Utility functions and helpers
├── app.dart                # Main application widget
└── main.dart               # Entry point
```

## Build and Run Instructions

### Debug Mode

```bash
flutter run
```

### Release Mode

#### Android
```bash
flutter build apk --release
# OR for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
# Then archive in Xcode
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path_to_test_file.dart
```

## Development Guidelines

### Code Style

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Use BLoC pattern for state management
- Follow the repository pattern for data access
- Write tests for all features

### Git Workflow

- Create feature branches from `develop`
- Use descriptive commit messages
- Create pull requests for review
- Squash commits when merging to `main`

### Architecture

The app follows Clean Architecture principles:
- **Domain Layer**: Business logic and models
- **Data Layer**: API integration and local storage
- **Presentation Layer**: UI components and state management

## Contributing

Contributions to MusicBud are welcome! To contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your code follows the project's coding standards and includes appropriate tests.

## Contact

- GitHub: [@54ba](https://github.com/54ba)
- Project Link: [https://github.com/54ba/musicbud_flutter](https://github.com/54ba/musicbud_flutter)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

Built with ❤️ by [54ba](https://github.com/54ba)

# MusicBud Flutter

A modern music player and management application built with Flutter.

## Project Description

MusicBud is a cross-platform music player application that offers a seamless listening experience with advanced features for music management, playlist creation, and audio customization. Built using Flutter, this app provides a consistent experience across multiple platforms with a beautiful, responsive UI.

### Key Features

- Music playback with advanced controls
- Playlist management
- Audio visualization
- Offline music storage
- Seamless cloud synchronization
- Customizable equalizer
- Dark and light theme support
- Cross-platform compatibility

## Requirements and Prerequisites

- Flutter SDK (2.10.0 or later)
- Dart SDK (2.16.0 or later)
- Android Studio / VS Code with Flutter extensions
- For iOS development: Xcode and CocoaPods
- Git for version control

## Installation Instructions

### Setting Up the Development Environment

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/musicbud_flutter.git
   cd musicbud_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application in debug mode**
   ```bash
   flutter run
   ```

### Building for Production

#### Android
```bash
flutter build apk --release
# OR for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
# Then open the iOS project in Xcode and archive it
```

## Development Workflow

### Project Structure

The project follows a feature-first organization with Clean Architecture principles:

```
lib/
├── core/              # Core functionality and utilities
├── data/              # Data sources, repositories implementations
├── domain/            # Business logic, entities, repositories interfaces
├── presentation/      # UI components (screens, widgets)
├── config/            # App configuration
├── app.dart           # Application entry point
└── main.dart          # Main entry point
```

### Development Flow

1. **Feature Development**
   - Create feature branch from `dev` branch
   - Implement feature following TDD principles
   - Write unit and widget tests
   - Create pull request to `dev` branch

2. **Release Process**
   - Merge `dev` to `staging` for testing
   - After testing, merge `staging` to `main` for production release

3. **Code Style and Standards**
   - Follow Flutter/Dart style guidelines
   - Use meaningful variable and function names
   - Keep functions small and focused
   - Document public APIs

## Configuration Customization Guide

### App Theming

The app theme can be customized in `lib/config/theme.dart`:

```dart
// Example for customizing colors
final lightTheme = ThemeData(
  primaryColor: YourCustomColor,
  accentColor: YourAccentColor,
  // Other theme properties
);
```

### Environment Configuration

Environment variables are managed in `.env` files:

- `.env.development` - Development settings
- `.env.production` - Production settings

### Feature Flags

Feature flags can be managed in `lib/config/feature_flags.dart`.

## Common Tasks and Commands

### Running Tests

```bash
# Unit and widget tests
flutter test

# Integration tests
flutter test integration_test
```

### Code Generation

```bash
# Generate model classes
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting

```bash
# Analyze the project
flutter analyze
```

### Updating Dependencies

```bash
# Update dependencies to latest compatible versions
flutter pub upgrade

# Update to exact versions
flutter pub upgrade --major-versions
```

## Troubleshooting

### Common Issues and Solutions

1. **Build Errors**
   - Clean the build: `flutter clean`
   - Get dependencies again: `flutter pub get`
   - Check for outdated packages: `flutter pub outdated`

2. **Performance Issues**
   - Run in profile mode: `flutter run --profile`
   - Check for performance issues in DevTools

3. **Platform-Specific Issues**
   - Android: Check Android Studio Logcat
   - iOS: Check Xcode Console

### Getting Help

If you encounter issues not covered here:
- Check the [issue tracker](https://github.com/yourusername/musicbud_flutter/issues)
- Join our [Discord community](https://discord.gg/musicbud)
- Contact the development team at dev@musicbud.example.com

## Contributing Guidelines

We welcome contributions to MusicBud! Here's how you can help:

1. **Reporting Bugs**
   - Use the issue tracker with the bug template
   - Include reproduction steps
   - Mention device, OS, and app version

2. **Suggesting Features**
   - Use the issue tracker with the feature request template
   - Explain the use case and benefits

3. **Pull Requests**
   - Fork the repository
   - Create a feature branch
   - Follow code style guidelines
   - Include tests
   - Update documentation
   - Submit a PR to the `dev` branch

4. **Code Review Process**
   - All PRs require at least one review
   - CI must pass before merging
   - Follow the feedback cycle

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors to this project
- Open source libraries used in this application

# musicbud_flutter
 
__