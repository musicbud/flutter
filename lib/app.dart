import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get_it/get_it.dart";
import "package:google_fonts/google_fonts.dart";

// BLoCs
import "blocs/auth/login/login_bloc.dart";
import "blocs/auth/register/register_bloc.dart";
import "blocs/likes/likes_bloc.dart";
import "blocs/settings/settings_bloc.dart";
import "blocs/event/event_bloc.dart";

// Repositories
import "domain/repositories/auth_repository.dart";
import "domain/repositories/content_repository.dart";

// Pages
import "presentation/pages/home_page.dart";
import "presentation/pages/login_page.dart";
import "presentation/pages/new_pages/main.dart";
import "presentation/pages/new_pages/service_connection_page.dart";
import "presentation/pages/new_pages/settings_page.dart";
import "presentation/pages/new_pages/admin_dashboard_page.dart";
import "presentation/pages/new_pages/event_page.dart";
import "presentation/pages/new_pages/music_page.dart";
import "presentation/pages/new_pages/modern_music_page.dart";
import "presentation/pages/new_pages/dynamic_music_page.dart";
import "presentation/pages/new_pages/buds_page.dart";
import "presentation/pages/new_pages/modern_buds_page.dart";
import "presentation/pages/new_pages/dynamic_buds_page.dart";
import "presentation/pages/new_pages/user_management_page.dart";
import "presentation/pages/new_pages/channel_management_page.dart";
import "presentation/pages/new_pages/analytics_page.dart";
import "presentation/pages/new_pages/chat_screen.dart";
import "presentation/pages/new_pages/search.dart";
import "presentation/pages/new_pages/stories_page.dart";
import "presentation/pages/new_pages/register_page.dart";
import "presentation/pages/new_pages/top_profile.dart";
import "presentation/pages/new_pages/cards.dart";
import "presentation/pages/new_pages/main_navigation_page.dart";

// Utilities
import "utils/colors.dart";
import "presentation/constants/app_constants.dart";

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
      theme: _buildAppTheme(),
      initialRoute: AppConstants.loginRoute,
      routes: _buildAppRoutes(),
    );
  }

  /// Builds the application theme
  ThemeData _buildAppTheme() {
    return ThemeData(
      colorScheme: AppColors.colorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.josefinSansTextTheme(
        ThemeData.light().textTheme,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.backgroundColor,
        foregroundColor: AppConstants.textColor,
        elevation: 0,
      ),
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      primaryColor: AppConstants.primaryColor,
    );
  }

  /// Builds the application routes
  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      AppConstants.homeRoute: (context) => const NewMainScreen(),
      AppConstants.loginRoute: (context) => const LoginPage(),
      AppConstants.homePageRoute: (context) => const HomePage(),
      "/services": (context) => const ServiceConnectionPage(),
      "/settings": (context) => const SettingsPage(),
      "/admin": (context) => const AdminDashboardPage(),
      "/events": (context) => const EventPage(),
      "/music": (context) => const MusicPage(),
      "/music/modern": (context) => const ModernMusicPage(),
      "/music/dynamic": (context) => const DynamicMusicPage(),
      "/buds": (context) => const BudsPage(),
      "/buds/modern": (context) => const ModernBudsPage(),
      "/buds/dynamic": (context) => const DynamicBudsPage(),
      "/cards": (context) => const CardsScreen(),
      "/profile": (context) => const ProfilePage(),
      "/users": (context) => const UserManagementPage(),
      "/admin/users": (context) => const UserManagementPage(),
      "/admin/channels": (context) => const ChannelManagementPage(),
      "/admin/analytics": (context) => const AnalyticsPage(),
      "/chat": (context) => const ChatListScreen(),
      "/search": (context) => const SearchPage(),
      "/stories": (context) => const StoriesPage(),
      "/register": (context) => const RegisterPage(),
      "/navigation": (context) => const MainNavigationPage(),
    };
  }
}
