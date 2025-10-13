import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";

// BLoCs
import "blocs/auth/auth_bloc.dart";
import "blocs/auth/login/login_bloc.dart";
import "blocs/auth/register/register_bloc.dart";
import "blocs/likes/likes_bloc.dart";
import "blocs/settings/settings_bloc.dart";
import "blocs/event/event_bloc.dart";
import "blocs/spotify/spotify_bloc.dart";
import "blocs/bud_matching/bud_matching_bloc.dart";
import "blocs/discover/discover_bloc.dart";

// Repositories
import "domain/repositories/auth_repository.dart";
import "domain/repositories/content_repository.dart";

// Screens
// Used screens
import "presentation/screens/home/dynamic_home_screen.dart";
import "presentation/screens/auth/login_screen.dart";
import "presentation/screens/auth/register_screen.dart";
import "presentation/screens/discover/dynamic_discover_screen.dart";
import "presentation/screens/discover/top_tracks_page.dart";
import "presentation/screens/library/dynamic_library_screen.dart";
import "presentation/screens/profile/dynamic_profile_screen.dart";
import "presentation/screens/profile/edit_profile_screen.dart";
import "presentation/screens/profile/artist_details_screen.dart";
import "presentation/screens/profile/genre_details_screen.dart";
import "presentation/screens/profile/track_details_screen.dart";
import "presentation/screens/chat/dynamic_chat_screen.dart";
import "presentation/screens/search/dynamic_search_screen.dart";
import "presentation/screens/buds/dynamic_buds_screen.dart";
import "presentation/screens/settings/dynamic_settings_screen.dart";
import "presentation/screens/settings/enhanced_settings_screen.dart";
import "presentation/screens/connect/connect_services_screen.dart";
import "presentation/screens/spotify/played_tracks_map_screen.dart";
import "presentation/screens/spotify/spotify_control_screen.dart";
import "presentation/pages/ui_showcase_page.dart";

// New onboarding page
import "presentation/pages/onboarding_page.dart";

// Providers
import "data/providers/token_provider.dart";

// Auth Gate
import "widgets/auth/auth_gate.dart";

// Design System
import "core/theme/musicbud_theme.dart";

// Dynamic Services
import "services/dynamic_navigation_service.dart";

// Legacy constants (for backward compatibility during migration)
import "core/theme/app_constants.dart";

// Navigation
import "core/navigation/app_routes.dart";

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
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          authRepository: sl<AuthRepository>(),
          tokenProvider: sl<TokenProvider>(),
        ),
      ),
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
      // Spotify BLoC
      BlocProvider<SpotifyBloc>(
        create: (context) => sl<SpotifyBloc>(),
      ),
      // Bud Matching BLoC
      BlocProvider<BudMatchingBloc>(
        create: (context) => sl<BudMatchingBloc>(),
      ),
      // Discover BLoC
      BlocProvider<DiscoverBloc>(
        create: (context) => sl<DiscoverBloc>(),
      ),
    ];
  }

  /// Builds the MaterialApp with theme and routing
  Widget _buildMaterialApp() {
    final navigationService = DynamicNavigationService.instance;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appTitle,
      theme: MusicBudTheme.lightTheme,
      darkTheme: MusicBudTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme to match UI designs
      navigatorKey: navigationService.navigatorKey,
      home: const AuthGate(),
      routes: _buildAppRoutes(),
      onGenerateRoute: navigationService.onGenerateRoute,
    );
  }


  /// Builds the application routes
  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      // Note: homeRoute ('/') is removed since we use AuthGate as home
      AppRoutes.login: (context) => const LoginScreen(),
      AppRoutes.home: (context) => const DynamicHomeScreen(),
      AppRoutes.discover: (context) => const DynamicDiscoverScreen(),
      AppRoutes.topTracks: (context) => const TopTracksPage(),
      AppRoutes.library: (context) => const DynamicLibraryScreen(),
      AppRoutes.profile: (context) => const DynamicProfileScreen(),
      AppRoutes.editProfile: (context) => const EditProfileScreen(),
      AppRoutes.chat: (context) => const DynamicChatScreen(),
      AppRoutes.search: (context) => const DynamicSearchScreen(),
      AppRoutes.buds: (context) => const DynamicBudsScreen(),
      AppRoutes.settings: (context) => const EnhancedSettingsScreen(),
      AppRoutes.settingsOld: (context) => const DynamicSettingsScreen(),
      AppRoutes.connectServices: (context) => const ConnectServicesScreen(),
      AppRoutes.register: (context) => const RegisterScreen(),
      AppRoutes.onboarding: (context) => const OnboardingPage(),
      AppRoutes.artistDetails: (context) => const ArtistDetailsScreen(),
      AppRoutes.genreDetails: (context) => const GenreDetailsScreen(),
      AppRoutes.trackDetails: (context) => const TrackDetailsScreen(),
      AppRoutes.playedTracksMap: (context) => const PlayedTracksMapScreen(),
      AppRoutes.spotifyControl: (context) => const SpotifyControlScreen(),
      AppRoutes.uiShowcase: (context) => const UIShowcasePage(),
    };
  }
}
