import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/user/user_event.dart';

import 'blocs/chat/chat_bloc.dart';
import 'blocs/content/content_bloc.dart';
import 'blocs/bud/bud_bloc.dart';
import 'blocs/user_profile/user_profile_bloc.dart';
import 'blocs/bud_matching/bud_matching_bloc.dart';
import 'blocs/chat/chat_management_bloc.dart';
import 'blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import 'blocs/library/library_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'data/providers/token_provider.dart';
import 'domain/repositories/auth_repository.dart';
import 'app.dart';
import 'injection_container.dart' as di;
import 'blocs/profile/profile_bloc.dart';
import 'utils/api_endpoint_validator.dart';
import 'blocs/main/main_screen_bloc.dart';
import 'core/error/error_handler.dart';
import 'proxy_server.dart';

/// Main entry point of the MusicBud Flutter application
void main() async {
  // Run the application with error catching
  runZonedGuarded(() async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize error handler
    ErrorHandler.initialize();

    // Initialize dependency injection
    await di.init();

    debugPrint('🚀 MusicBud App: Starting application');

    // Start proxy server for dynamic API communication within the zone
    await startProxyServer();

    runApp(const MusicBudApp());
  }, (Object error, StackTrace stack) {
    ErrorHandler.handleZoneError(error, stack);
  });
}

/// Main application widget with BLoC providers
class MusicBudApp extends StatelessWidget {
  const MusicBudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _buildBlocProviders(),
      child: const App(),
    );
  }

  /// Builds the list of BLoC providers for the application
  List<BlocProvider> _buildBlocProviders() {
    return [
      // Core BLoCs
      BlocProvider<UserBloc>(
        create: (context) => di.sl<UserBloc>(),
      ),
      BlocProvider<ProfileBloc>(
        create: (context) => di.sl<ProfileBloc>(),
      ),

      // User Profile BLoC for user profile management
      BlocProvider<UserProfileBloc>(
        create: (context) => di.sl<UserProfileBloc>(),
      ),

      // Bud Matching BLoC for discover page
      BlocProvider<BudMatchingBloc>(
        create: (context) => di.sl<BudMatchingBloc>(),
      ),

      // Chat Management BLoC for chat page
      BlocProvider<ChatManagementBloc>(
        create: (context) => di.sl<ChatManagementBloc>(),
      ),

      // Main Screen BLoC for authentication status
      BlocProvider<MainScreenBloc>(
        create: (context) => di.sl<MainScreenBloc>(),
      ),

      // Chat BLoC for chat functionality
      BlocProvider<ChatBloc>(
        create: (context) => di.sl<ChatBloc>(),
      ),

      // Content BLoC for content management
      BlocProvider<ContentBloc>(
        create: (context) => di.sl<ContentBloc>(),
      ),

      // Bud BLoC for bud matching
      BlocProvider<BudBloc>(
        create: (context) => di.sl<BudBloc>(),
      ),

      // Authentication BLoC with token management
      BlocProvider<AuthBloc>(
        create: (context) => _createAuthBloc(context),
      ),

      // Search BLoC for search functionality
      BlocProvider<SearchBloc>(
        create: (context) => di.sl<SearchBloc>(),
      ),

      // Comprehensive Chat BLoC for comprehensive chat functionality
      BlocProvider<ComprehensiveChatBloc>(
        create: (context) => di.sl<ComprehensiveChatBloc>(),
      ),

      // Library BLoC for library functionality
      BlocProvider<LibraryBloc>(
        create: (context) => di.sl<LibraryBloc>(),
      ),
    ];
  }

  /// Creates and configures the AuthBloc with token management
  AuthBloc _createAuthBloc(BuildContext context) {
    final authBloc = AuthBloc(
      authRepository: di.sl<AuthRepository>(),
      tokenProvider: di.sl<TokenProvider>(),
    );

    // Listen to authentication state changes for token management
    authBloc.stream.listen((state) {
      if (!context.mounted) return;
      if (state is Authenticated) {
        _handleAuthenticationSuccess(context, state.token);
      } else if (state is Unauthenticated) {
        _handleLogout(context);
      }
    });

    return authBloc;
  }

  /// Handles successful authentication by updating tokens and user state
  void _handleAuthenticationSuccess(BuildContext context, String token) {
    if (context.mounted) {
      // Update token in storage
      di.sl<TokenProvider>().updateToken(token);

      // Update user bloc with new token
      context.read<UserBloc>().add(UpdateToken(token: token));
    }
  }

  /// Handles logout by clearing tokens
  void _handleLogout(BuildContext context) {
    if (context.mounted) {
      // Clear token from storage
      di.sl<TokenProvider>().clearToken();

      // Navigate to login
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }
}

/// Application startup utilities
class AppStartup {
  /// Validates API endpoints on app startup
  static void validateApiEndpoints() {
    ApiEndpointValidator.logEndpointValidation();
  }

  /// Performs any additional startup tasks
  static Future<void> performStartupTasks() async {
    // Validate API endpoints
    validateApiEndpoints();

    // TODO: Add other startup tasks like:
    // - Check for app updates
    // - Initialize analytics
    // - Load cached data
    // - Check device compatibility
  }
}
