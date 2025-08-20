import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/user/user_event.dart';
import 'blocs/services/services_bloc.dart';
import 'data/providers/token_provider.dart';
import 'domain/repositories/auth_repository.dart';
import 'app.dart';
import 'injection_container.dart' as di;
import 'blocs/profile/profile_bloc.dart';
import 'utils/api_endpoint_validator.dart';
import 'presentation/constants/app_constants.dart';
import 'blocs/main/main_screen_bloc.dart';

/// Main entry point of the MusicBud Flutter application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Run the application
  runApp(const MusicBudApp());
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
      BlocProvider<ServicesBloc>(
        create: (context) => di.sl<ServicesBloc>(),
      ),

      // Main Screen BLoC for authentication status
      BlocProvider<MainScreenBloc>(
        create: (context) => di.sl<MainScreenBloc>(),
      ),

      // Authentication BLoC with token management
      BlocProvider<AuthBloc>(
        create: (context) => _createAuthBloc(context),
      ),
    ];
  }

  /// Creates and configures the AuthBloc with token management
  AuthBloc _createAuthBloc(BuildContext context) {
    final authBloc = AuthBloc(authRepository: di.sl<AuthRepository>());

    // Listen to authentication state changes for token management
    authBloc.stream.listen((state) {
      if (state is Authenticated) {
        _handleAuthenticationSuccess(context, state.token);
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
