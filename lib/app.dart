import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";

// BLoCs
import "blocs/auth/login/login_bloc.dart";
import "blocs/auth/register/register_bloc.dart";
import "blocs/likes/likes_bloc.dart";
import "blocs/settings/settings_bloc.dart";
import "blocs/event/event_bloc.dart";

// Repositories
import "domain/repositories/auth_repository.dart";
import "domain/repositories/content_repository.dart";

// Screens
import "presentation/screens/home/home_screen.dart";
import "presentation/screens/discover/discover_screen.dart";
import "presentation/screens/library/library_screen.dart";
import "presentation/screens/profile/profile_screen.dart";
import "presentation/screens/chat/chat_screen.dart";
import "presentation/screens/search/search_screen.dart";

// Design System
import "core/theme/design_system.dart";

// Legacy constants (for backward compatibility during migration)
import "core/theme/app_constants.dart";

/// Main application widget for MusicBud
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _buildBlocProviders(),
      child: _buildMaterialApp(),
    );
  }

  /// Builds the list of BLoC providers for the application
  List<BlocProvider> _buildBlocProviders() {
    final sl = GetIt.instance;

    return [
      // Authentication BLoCs
      BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(authRepository: sl<AuthRepository>()),
      ),
      BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(authRepository: sl<AuthRepository>()),
      ),
      BlocProvider<LikesBloc>(
        create: (context) => LikesBloc(contentRepository: sl<ContentRepository>()),
      ),
      // Settings BLoC
      BlocProvider<SettingsBloc>(
        create: (context) => sl<SettingsBloc>(),
      ),
      // Event BLoC
      BlocProvider<EventBloc>(
        create: (context) => sl<EventBloc>(),
      ),
    ];
  }

  /// Builds the MaterialApp with theme and routing
  Widget _buildMaterialApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: DesignSystem.darkTheme, // Using the new unified design system
      initialRoute: AppConstants.loginRoute,
      routes: _buildAppRoutes(),
    );
  }


  /// Builds the application routes
  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      AppConstants.homeRoute: (context) => const HomeScreen(),
      AppConstants.loginRoute: (context) => const HomeScreen(), // Placeholder
      AppConstants.homePageRoute: (context) => const HomeScreen(),
      "/discover": (context) => const DiscoverScreen(),
      "/library": (context) => const LibraryScreen(),
      "/profile": (context) => const ProfileScreen(),
      "/chat": (context) => const ChatScreen(),
      "/search": (context) => const SearchScreen(),
    };
  }
}
